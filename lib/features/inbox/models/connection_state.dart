/// Enum representing the connection state of the Socket.IO service
enum ConnectionState {
  /// Not connected to the server
  disconnected,

  /// Currently attempting to connect
  connecting,

  /// Successfully connected to the server
  connected,

  /// Connection error occurred
  error,

  /// Attempting to reconnect
  reconnecting,
}

/// Extension methods for ConnectionState
extension ConnectionStateExtension on ConnectionState {
  /// Get a human-readable description of the connection state
  String get description {
    switch (this) {
      case ConnectionState.disconnected:
        return 'Disconnected';
      case ConnectionState.connecting:
        return 'Connecting...';
      case ConnectionState.connected:
        return 'Connected';
      case ConnectionState.error:
        return 'Connection Error';
      case ConnectionState.reconnecting:
        return 'Reconnecting...';
    }
  }

  /// Check if the state represents an active connection
  bool get isActive {
    return this == ConnectionState.connected;
  }

  /// Check if the state represents a transitional state
  bool get isTransitional {
    return this == ConnectionState.connecting ||
        this == ConnectionState.reconnecting;
  }

  /// Check if the state represents an error
  bool get isError {
    return this == ConnectionState.error;
  }
}