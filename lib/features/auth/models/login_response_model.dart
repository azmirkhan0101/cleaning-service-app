/*
 {
    "success": true,
    "message": "User logged in successfully",
    "data": {
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4ZmNhZTFjNjU0YjJiOGU5MTY3OGVmNSIsImVtYWlsIjoib3duZXIxQGV4YW1wbGUuY29tIiwicm9sZSI6Ik9XTkVSIiwiaWF0IjoxNzYxNjUxMDIyLCJleHAiOjE3NjQyNDMwMjJ9.xww5rV6nkhutWsfjdJLWwIhI2O6LhOFlUYZ0BIGm0-g",
        "userData": {
            "_id": "68fcae1c654b2b8e91678ef5",
            "userName": "John Doe",
            "email": "owner1@example.com",
            "role": "OWNER",
            "profilePicture": "https://randomuser.me/api/portraits/men/1.jpg",
            "status": "ACTIVE",
            "createdAt": "2025-10-25T11:01:48.577Z",
            "updatedAt": "2025-10-26T11:51:33.294Z"
        }
    }
}
 */

class LoginResponseModel {
  final String token;
  final UserData userData;

  LoginResponseModel({required this.token, required this.userData});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      userData: UserData.fromJson(json['userData']),
    );
  }
}

class UserData {
  final String id;
  final String userName;
  final String email;
  final String role;
  final String profilePicture;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    required this.userName,
    required this.email,
    required this.role,
    required this.profilePicture,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      userName: json['userName'],
      email: json['email'],
      role: json['role'],
      profilePicture: json['profilePicture'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
