/// Model class for chat messages
class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isSent;
  final bool isDelivered;
  final bool isRead;
  final List<String> images;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isSent = false,
    this.isDelivered = false,
    this.isRead = false,
    this.images = const [],
  });

  /// Create MessageModel from JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Support multiple timestamp field names
    final ts = json['timestamp'] ?? json['createdAt'];
    List<String> imgs = [];
    final rawImages = json['image'] ?? json['images'];
    if (rawImages is List) {
      imgs = rawImages.map((e) => e.toString()).toList();
    }
    return MessageModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? json['from']?.toString() ?? '',
      receiverId: json['receiverId']?.toString() ?? json['to']?.toString() ?? '',
      text: json['text']?.toString() ?? json['message']?.toString() ?? '',
      timestamp: ts != null ? DateTime.tryParse(ts.toString()) ?? DateTime.now() : DateTime.now(),
      isSent: json['isSent'] ?? true,
      isDelivered: json['isDelivered'] ?? json['delivered'] ?? false,
      isRead: json['isRead'] ?? json['isSeen'] ?? json['seen'] ?? false,
      images: imgs,
    );
  }

  /// Convert MessageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isSent': isSent,
      'isDelivered': isDelivered,
      'isRead': isRead,
      'images': images,
    };
  }

  /// Create a copy with updated fields
  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? text,
    DateTime? timestamp,
    bool? isSent,
    bool? isDelivered,
    bool? isRead,
    List<String>? images,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isSent: isSent ?? this.isSent,
      isDelivered: isDelivered ?? this.isDelivered,
      isRead: isRead ?? this.isRead,
      images: images ?? this.images,
    );
  }

  @override
  String toString() {
    return 'MessageModel(id: $id, senderId: $senderId, receiverId: $receiverId, text: $text, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel &&
      other.id == id &&
      other.senderId == senderId &&
      other.receiverId == receiverId &&
      other.text == text &&
      other.timestamp == timestamp &&
      _listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        text.hashCode ^
        timestamp.hashCode ^
        images.hashCode;
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}