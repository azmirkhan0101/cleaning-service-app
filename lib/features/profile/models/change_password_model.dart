class ChangePasswordResponseModel {
  final bool success;
  final String message;
  final ChangePasswordData data;

  ChangePasswordResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ChangePasswordData.fromJson(json['data'] ?? {}),
    );
  }
}

class ChangePasswordData {
  final String id;
  final String userName;
  final String phoneNumber;
  final String email;
  final String role;
  final String status;

  ChangePasswordData({
    required this.id,
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.role,
    required this.status,
  });

  factory ChangePasswordData.fromJson(Map<String, dynamic> json) {
    return ChangePasswordData(
      id: json['_id'] ?? '',
      userName: json['userName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
