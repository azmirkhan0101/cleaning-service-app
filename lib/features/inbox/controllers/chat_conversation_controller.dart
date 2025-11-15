import 'dart:async';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/inbox/controllers/socket_controller.dart';
import 'package:cleaning_service_app/features/inbox/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller that manages a single chat conversation (history + live updates)
class ChatConversationController extends GetxController {
  ChatConversationController({
    required this.userId,
    required this.userName,
    required this.avatar,
  });

  final String userId;
  final String userName;
  final String avatar;

  final NetworkHelper _network = Get.find<NetworkHelper>();
  final SocketController _socketController = Get.put(SocketController());

  final isLoading = false.obs;
  final isSending = false.obs;
  final errorMessage = ''.obs;
  final messages = <MessageModel>[].obs;

  final TextEditingController inputController = TextEditingController();
  StreamSubscription? _socketMessageSub;

  String? _currentUserId;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    await _ensureSocketConnected();
    await _loadCurrentUser();
    await fetchHistory();
    await _markMessagesAsRead();
    _listenForIncomingMessages();
  }

  Future<void> _loadCurrentUser() async {
    _currentUserId = await AppStorageService.getUserId();
  }

  Future<void> _ensureSocketConnected() async {
    if (!_socketController.isConnected) {
      final token = await AppStorageService.getAuthToken();
      if (token != null) {
        try {
          await _socketController.connect(token);
        } catch (e) {
          errorMessage.value = 'Socket connection failed';
        }
      }
    }
  }

  Future<void> fetchHistory() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _network.get<Map<String, dynamic>>(
      ApiUrl.messagesByUser(userId),
      parser: (data) => data as Map<String, dynamic>,
    );

    result.match(
      (err) {
        errorMessage.value = err.message ?? 'Failed to load messages';
      },
      (res) {
        final list = (res['data'] as List<dynamic>? ?? [])
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList();
        messages.assignAll(list);
        // Merge into global socket controller list for consistency
        _socketController.addHistoryMessages(list);
      },
    );

    isLoading.value = false;
  }

  void _listenForIncomingMessages() {
    _socketMessageSub = _socketController.incomingMessageStream.listen((raw) {
      try {
        final message = MessageModel.fromJson(raw);
        // Filter messages belonging to this conversation
        if (message.senderId == userId || message.receiverId == userId) {
          messages.add(message);
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        }
      } catch (_) {}
    });
  }

  Future<void> sendMessage() async {
    final text = inputController.text.trim();
    if (text.isEmpty || isSending.value) return;
    isSending.value = true;

    final success = await _socketController.sendMessage(
      receiverId: userId,
      text: text,
    );

    if (!success) {
      errorMessage.value = _socketController.lastError ?? 'Failed to send';
    } else {
      inputController.clear();
      // Optimistic message already added to global list; reflect in local view
      final last = _socketController.messages.last;
      if (last.receiverId == userId || last.senderId == userId) {
        messages.add(last);
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      }
    }

    isSending.value = false;
  }

  bool get isPeerOnline => _socketController.isUserOnline(userId);
  String? get currentUserId => _currentUserId;
  bool isMine(MessageModel m) => m.senderId == _currentUserId;

  Future<void> _markMessagesAsRead() async {
    try {
      final result = await _network.patch<Map<String, dynamic>>(
        ApiUrl.markMessagesAsRead(userId),
        parser: (data) => data as Map<String, dynamic>,
      );
      result.match(
        (err) => debugPrint('Failed to mark messages as read: ${err.message}'),
        (res) {
          debugPrint('Messages marked as read');
          // Refresh unread count in main layout
          _refreshUnreadCount();
        },
      );
    } catch (e) {
      debugPrint('Error marking messages as read: $e');
    }
  }

  void _refreshUnreadCount() {
    try {
      // Find main layout controller if it exists and refresh unread count
      if (Get.isRegistered<dynamic>(tag: 'MainLayoutController')) {
        final mainController = Get.find(tag: 'MainLayoutController');
        if (mainController.toString().contains('MainLayoutController')) {
          (mainController as dynamic).fetchUnreadMessagesCount();
        }
      }
    } catch (e) {
      debugPrint('Could not refresh unread count: $e');
    }
  }

  @override
  void onClose() {
    _socketMessageSub?.cancel();
    inputController.dispose();
    super.onClose();
  }
}
