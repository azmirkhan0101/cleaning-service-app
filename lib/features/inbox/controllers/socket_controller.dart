import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/socket_service.dart';
import 'package:cleaning_service_app/features/inbox/models/connection_state.dart';
import 'package:cleaning_service_app/features/inbox/models/message_model.dart';
import 'package:get/get.dart';

/// GetX Controller for managing Socket.IO state across the application
class SocketController extends GetxController {
  final SocketService _socketService = SocketService();

  // Reactive state variables
  final Rx<ConnectionState> _connectionState = ConnectionState.disconnected.obs;
  final RxList<MessageModel> _messages = <MessageModel>[].obs;
  final RxList<String> _onlineUsers = <String>[].obs;
  final RxnString _lastError = RxnString();
  final RxBool _isInitialized = false.obs;

  // Getters
  ConnectionState get connectionState => _connectionState.value;
  List<MessageModel> get messages => _messages;
  List<String> get onlineUsers => _onlineUsers;
  String? get lastError => _lastError.value;
  bool get isConnected => _connectionState.value == ConnectionState.connected;
  bool get isInitialized => _isInitialized.value;
  // Expose raw incoming message stream for conversation controllers
  Stream<Map<String, dynamic>> get incomingMessageStream =>
      _socketService.messageStream;

  @override
  void onInit() {
    super.onInit();
    _initializeListeners();
  }

  /// Initialize all stream listeners
  void _initializeListeners() {
    // Listen to connection state changes
    _socketService.connectionStateStream.listen(
      (isConnected) {
        _connectionState.value = isConnected
            ? ConnectionState.connected
            : ConnectionState.disconnected;
      },
      onError: (error) {
        _lastError.value = error.toString();
      },
    );

    // Listen to incoming messages
    _socketService.messageStream.listen(
      (data) {
        try {
          final message = MessageModel.fromJson(data);
          _messages.add(message);
        } catch (e) {
          _lastError.value = 'Error parsing message: $e';
        }
      },
      onError: (error) {
        _lastError.value = error.toString();
      },
    );

    // Listen to online users updates
    _socketService.onlineUsersStream.listen(
      (users) {
        _onlineUsers.value = users.map((user) => user.toString()).toList();
      },
      onError: (error) {
        _lastError.value = error.toString();
      },
    );

    // Listen to errors
    _socketService.errorStream.listen((error) {
      _lastError.value = error;
    });

    _isInitialized.value = true;
  }

  /// Connect to the Socket.IO server
  Future<void> connect(String token) async {
    try {
      _connectionState.value = ConnectionState.connecting;
      _lastError.value = null;

      await _socketService.connect(token);
    } catch (e) {
      _connectionState.value = ConnectionState.error;
      _lastError.value = e.toString();
      rethrow;
    }
  }

  /// Disconnect from the server
  void disconnect() {
    _socketService.disconnect();
    _connectionState.value = ConnectionState.disconnected;
  }

  /// Send a message
  Future<bool> sendMessage({
    required String receiverId,
    required String text,
  }) async {
    if (!isConnected) {
      _lastError.value = 'Cannot send message: Not connected';
      return false;
    }

    try {
      final currentUserId = await AppStorageService.getUserId() ?? 'me';
      final success = await _socketService.sendMessage(
        receiverId: receiverId,
        text: text,
        waitForAck: false,
      );

      if (success) {
        // Add sent message to local list immediately for optimistic UI
        final sentMessage = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: currentUserId,
          receiverId: receiverId,
          text: text,
          timestamp: DateTime.now(),
          isSent: true,
        );
        _messages.add(sentMessage);
      } else {
        _lastError.value = 'Failed to send message';
      }

      return success;
    } catch (e) {
      _lastError.value = 'Error sending message: $e';
      return false;
    }
  }

  /// Merge history messages ensuring uniqueness by id
  void addHistoryMessages(List<MessageModel> history) {
    final existingIds = _messages.map((m) => m.id).toSet();
    final toAdd = history.where((m) => !existingIds.contains(m.id)).toList();
    if (toAdd.isNotEmpty) {
      _messages.addAll(toAdd);
      _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }
  }

  /// Reconnect to the server
  Future<void> reconnect() async {
    try {
      _connectionState.value = ConnectionState.connecting;
      _lastError.value = null;

      await _socketService.reconnect();
    } catch (e) {
      _connectionState.value = ConnectionState.error;
      _lastError.value = e.toString();
      rethrow;
    }
  }

  /// Update authentication token
  Future<void> updateToken(String newToken) async {
    try {
      _connectionState.value = ConnectionState.connecting;
      _lastError.value = null;

      await _socketService.updateToken(newToken);
    } catch (e) {
      _connectionState.value = ConnectionState.error;
      _lastError.value = e.toString();
      rethrow;
    }
  }

  /// Clear all messages
  void clearMessages() {
    _messages.clear();
  }

  /// Clear error
  void clearError() {
    _lastError.value = null;
  }

  /// Get messages for a specific user
  List<MessageModel> getMessagesForUser(String userId) {
    return _messages
        .where((msg) => msg.senderId == userId || msg.receiverId == userId)
        .toList();
  }

  /// Check if a user is online
  bool isUserOnline(String userId) {
    return _onlineUsers.contains(userId);
  }

  /// Get connection statistics
  Map<String, dynamic> getConnectionStats() {
    return _socketService.getConnectionStats();
  }

  @override
  void onClose() {
    // Only disconnect; do not dispose streams to avoid adding to closed streams
    _socketService.disconnect();
    super.onClose();
  }
}
