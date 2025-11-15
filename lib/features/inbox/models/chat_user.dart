class ChatUser {
  final String id;
  final String userName;
  final String email;
  final String role;
  final String profilePicture;
  final int unreadCount;

  ChatUser({
    required this.id,
    required this.userName,
    required this.email,
    required this.role,
    required this.profilePicture,
    required this.unreadCount,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      userName: (json['userName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      profilePicture: (json['profilePicture'] ?? '').toString(),
      unreadCount: (json['unreadCount'] ?? 0) is int
          ? json['unreadCount']
          : int.tryParse((json['unreadCount'] ?? '0').toString()) ?? 0,
    );
  }
}
