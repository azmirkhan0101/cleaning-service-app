import 'dart:async';
import 'dart:io';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/inbox/controllers/socket_controller.dart';
import 'package:cleaning_service_app/features/inbox/models/message_model.dart';
import 'package:cleaning_service_app/features/main-layout/controllers/main_layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
  final selectedImages = <File>[].obs;

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
        // Ensure chronological order (oldest first, newest last)
        list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
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

  Future<void> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);
      if (images.isNotEmpty) {
        selectedImages.addAll(images.map((xFile) => File(xFile.path)));
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
      errorMessage.value = 'Failed to pick images';
    }
  }

  void removeImage(int index) {
    if (index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  Future<void> sendMessage() async {
    final text = inputController.text.trim();
    if ((text.isEmpty && selectedImages.isEmpty) || isSending.value) return;
    isSending.value = true;
    errorMessage.value = '';

    try {
      final files = selectedImages
          .map((file) => MultipartBody(key: 'images', file: file))
          .toList();

      final result = await _network.multipart<Map<String, dynamic>>(
        url: ApiUrl.sendMessage(userId),
        method: 'POST',
        fields: text.isNotEmpty ? {'text': text} : null,
        files: files,
        parser: (data) => data as Map<String, dynamic>,
      );

      result.match(
        (err) {
          errorMessage.value = err.message ?? 'Failed to send message';
        },
        (res) {
          // Parse the sent message from response
          final sentMsg = MessageModel.fromJson(
            res['data'] as Map<String, dynamic>,
          );
          messages.add(sentMsg);
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

          // Clear inputs
          inputController.clear();
          selectedImages.clear();
        },
      );
    } catch (e) {
      debugPrint('Error sending message: $e');
      errorMessage.value = 'Failed to send message';
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
      if (Get.isRegistered<MainLayoutController>()) {
        final mainController = Get.find<MainLayoutController>();
        mainController.fetchUnreadMessagesCount();
      }
    } catch (e) {
      debugPrint('Could not refresh unread count: $e');
    }
  }

  @override
  void onClose() {
    // Ensure unread badge is up to date when leaving the conversation
    _refreshUnreadCount();
    _socketMessageSub?.cancel();
    inputController.dispose();
    super.onClose();
  }
}
