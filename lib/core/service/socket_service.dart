import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Professional Socket.IO Service Implementation
/// Handles connection management, authentication, and event handling
class SocketService {
  // Singleton pattern
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  // Socket instance
  IO.Socket? _socket;

  // Connection state
  bool _isConnected = false;
  bool _isConnecting = false;

  // Configuration
  static const String _baseUrl = 'http://10.10.20.73:8000';
  static const int _reconnectionAttempts = 5;
  static const int _reconnectionDelay = 2000; // milliseconds
  static const int _timeout = 10000; // milliseconds

  // Authentication token
  String? _authToken;

  // Stream controllers for events
  final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<List<dynamic>> _onlineUsersStreamController =
      StreamController<List<dynamic>>.broadcast();
  final StreamController<bool> _connectionStateController =
      StreamController<bool>.broadcast();
  final StreamController<String> _errorStreamController =
      StreamController<String>.broadcast();

  // Getters for streams
  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;
  Stream<List<dynamic>> get onlineUsersStream =>
      _onlineUsersStreamController.stream;
  Stream<bool> get connectionStateStream => _connectionStateController.stream;
  Stream<String> get errorStream => _errorStreamController.stream;

  // Getters for state
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  IO.Socket? get socket => _socket;

  /// Initialize and connect to the Socket.IO server
  /// [token] - Bearer authentication token
  Future<void> connect(String token) async {
    if (_isConnected || _isConnecting) {
      debugPrint('SocketService: Already connected or connecting');
      return;
    }

    _isConnecting = true;
    _authToken = token;

    try {
      debugPrint('SocketService: Connecting to $_baseUrl');

      _socket = IO.io(
        _baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // Use WebSocket transport
            .disableAutoConnect() // Manual connection control
            .setExtraHeaders({'Authorization': 'Bearer $token'})
            .setReconnectionAttempts(_reconnectionAttempts)
            .setReconnectionDelay(_reconnectionDelay)
            .setTimeout(_timeout)
            .enableForceNew() // Force new connection
            .build(),
      );

      _setupEventListeners();
      _socket!.connect();
    } catch (e) {
      _isConnecting = false;
      debugPrint('SocketService: Connection error: $e');
      _errorStreamController.add('Connection failed: $e');
      rethrow;
    }
  }

  /// Setup all event listeners
  void _setupEventListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      _isConnected = true;
      _isConnecting = false;
      _connectionStateController.add(true);
      debugPrint('SocketService: Connected successfully');
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      _isConnecting = false;
      _connectionStateController.add(false);
      debugPrint('SocketService: Disconnected');
    });

    _socket!.onConnectError((error) {
      _isConnecting = false;
      debugPrint('SocketService: Connection error: $error');
      _errorStreamController.add('Connection error: $error');
    });

    _socket!.onError((error) {
      debugPrint('SocketService: Socket error: $error');
      _errorStreamController.add('Socket error: $error');
    });

    _socket!.onReconnect((attempt) {
      debugPrint('SocketService: Reconnecting... Attempt: $attempt');
    });

    _socket!.onReconnectError((error) {
      debugPrint('SocketService: Reconnection error: $error');
      _errorStreamController.add('Reconnection error: $error');
    });

    _socket!.onReconnectFailed((_) {
      debugPrint('SocketService: Reconnection failed');
      _errorStreamController.add(
        'Reconnection failed after $_reconnectionAttempts attempts',
      );
    });

    // Custom event listeners
    _setupCustomEventListeners();
  }

  /// Setup custom event listeners for the application
  void _setupCustomEventListeners() {
    if (_socket == null) return;

    // Listen for incoming messages
    _socket!.on('receive_message', (data) {
      debugPrint('SocketService: Received message: $data');
      try {
        if (data is Map<String, dynamic>) {
          _messageStreamController.add(data);
        } else {
          debugPrint('SocketService: Invalid message format');
        }
      } catch (e) {
        debugPrint('SocketService: Error processing message: $e');
        _errorStreamController.add('Error processing message: $e');
      }
    });

    // Listen for online users updates
    _socket!.on('online_users', (data) {
      debugPrint('SocketService: Online users updated: $data');
      try {
        if (data is List) {
          _onlineUsersStreamController.add(data);
        } else if (data is Map && data.containsKey('users')) {
          _onlineUsersStreamController.add(data['users'] as List);
        } else {
          debugPrint('SocketService: Invalid online users format');
        }
      } catch (e) {
        debugPrint('SocketService: Error processing online users: $e');
        _errorStreamController.add('Error processing online users: $e');
      }
    });

    // Listen for send_message acknowledgment (if server sends it)
    _socket!.on('send_message', (data) {
      debugPrint('SocketService: Send message acknowledgment: $data');
    });
  }

  /// Send a message to a specific user
  /// [receiverId] - ID of the message recipient
  /// [text] - Message content
  /// Returns true if message was sent successfully
  Future<bool> sendMessage({
    required String receiverId,
    required String text,
    bool waitForAck = false,
  }) async {
    if (!_isConnected || _socket == null) {
      debugPrint('SocketService: Cannot send message - not connected');
      _errorStreamController.add('Cannot send message: Not connected');
      return false;
    }

    try {
      final messageData = {
        'receiverId': receiverId,
        'text': text,
        'timestamp': DateTime.now().toIso8601String(),
      };

      debugPrint('SocketService: Sending message: $messageData');

      if (waitForAck) {
        // Emit with acknowledgment and wait
        final completer = Completer<bool>();
        _socket!.emitWithAck(
          'send_message',
          messageData,
          ack: (response) {
            debugPrint('SocketService: Message sent acknowledgment: $response');
            if (response != null &&
                response is Map &&
                response['error'] != null) {
              _errorStreamController.add(
                'Message send error: ${response['error']}',
              );
              completer.complete(false);
            } else {
              completer.complete(true);
            }
          },
        );
        return await completer.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            debugPrint('SocketService: Message send timeout');
            return true; // Consider sent even without ack
          },
        );
      } else {
        // Fire and forget; return immediately
        _socket!.emit('send_message', messageData);
        return true;
      }
    } catch (e) {
      debugPrint('SocketService: Error sending message: $e');
      _errorStreamController.add('Error sending message: $e');
      return false;
    }
  }

  /// Emit a custom event
  /// [event] - Event name
  /// [data] - Event data
  void emit(String event, dynamic data) {
    if (!_isConnected || _socket == null) {
      debugPrint('SocketService: Cannot emit event - not connected');
      _errorStreamController.add('Cannot emit event: Not connected');
      return;
    }

    try {
      debugPrint('SocketService: Emitting event: $event with data: $data');
      _socket!.emit(event, data);
    } catch (e) {
      debugPrint('SocketService: Error emitting event: $e');
      _errorStreamController.add('Error emitting event: $e');
    }
  }

  /// Listen to a custom event
  /// [event] - Event name
  /// [callback] - Callback function
  void on(String event, Function(dynamic) callback) {
    if (_socket == null) {
      debugPrint(
        'SocketService: Cannot listen to event - socket not initialized',
      );
      return;
    }

    _socket!.on(event, callback);
    debugPrint('SocketService: Listening to event: $event');
  }

  /// Remove listener for a custom event
  /// [event] - Event name
  void off(String event) {
    if (_socket == null) return;
    _socket!.off(event);
    debugPrint('SocketService: Removed listener for event: $event');
  }

  /// Disconnect from the Socket.IO server
  void disconnect() {
    if (_socket != null) {
      debugPrint('SocketService: Disconnecting...');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _isConnected = false;
    _isConnecting = false;
    _connectionStateController.add(false);
  }

  /// Reconnect to the server with the same token
  Future<void> reconnect() async {
    if (_authToken == null) {
      debugPrint('SocketService: Cannot reconnect - no auth token');
      _errorStreamController.add('Cannot reconnect: No authentication token');
      return;
    }

    disconnect();
    await Future.delayed(const Duration(milliseconds: 500));
    await connect(_authToken!);
  }

  /// Update authentication token and reconnect
  /// [newToken] - New Bearer token
  Future<void> updateToken(String newToken) async {
    _authToken = newToken;
    await reconnect();
  }

  /// Dispose all resources and close streams
  void dispose() {
    debugPrint('SocketService: Disposing...');
    disconnect();
    _messageStreamController.close();
    _onlineUsersStreamController.close();
    _connectionStateController.close();
    _errorStreamController.close();
  }

  /// Check connection health
  bool isHealthy() {
    return _isConnected && _socket != null && _socket!.connected;
  }

  /// Get connection statistics
  Map<String, dynamic> getConnectionStats() {
    return {
      'isConnected': _isConnected,
      'isConnecting': _isConnecting,
      'hasSocket': _socket != null,
      'socketConnected': _socket?.connected ?? false,
      'hasAuthToken': _authToken != null,
      'baseUrl': _baseUrl,
    };
  }
}

/*
import 'package:flutter/foundation.dart';
import 'package:map_point_flutter_app/helper/shared_prefe/shared_prefe.dart';
import 'package:map_point_flutter_app/service/api_url.dart';
import 'package:map_point_flutter_app/utils/app_const/app_const.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketApi {
  // Singleton instance of the class
  factory SocketApi() {
    return _socketApi;
  }

  // Private constructor for singleton
  SocketApi._internal();

  static late io.Socket socket;

  ///<------------------------- Socket Initialization with dynamic User ID ---------------->

  static void init() async {
    String userId = await SharePrefsHelper.getString(AppConstants.userId);
    if (userId.isEmpty || userId == "null") {
      return;
    }
    socket = io.io(
      ApiUrl.socketUrl(id: userId),
      io.OptionBuilder().setTransports(['websocket']).build(),
    );

    debugPrint(
        '$userId=============> Socket initialization, connected: ${socket.connected}');

    // Listen for socket connection
    socket.onConnect((_) {
      debugPrint(
          '==============>>>>>>> Socket Connected ${socket.connected} ===============<<<<<<<');
    });

    // Listen for unauthorized events
    socket.on('unauthorized', (dynamic data) {
      debugPrint('Unauthorized');
    });

    // Listen for errors
    socket.onError((dynamic error) {
      debugPrint('Socket error: $error');
    });

    // Listen for disconnection
    socket.onDisconnect((dynamic data) {
      debugPrint('>>>>>>>>>> Socket instance disconnected <<<<<<<<<<<<$data');
    });
  } 
 static void sendEvent(String eventName, dynamic data)async {
    socket.emit(eventName, data, );
  }

  // Static instance of the class
  static final SocketApi _socketApi = SocketApi._internal();
}
*/
