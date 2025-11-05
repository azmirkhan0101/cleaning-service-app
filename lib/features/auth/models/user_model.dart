/*
{
    "success": true,
    "message": "Registration Initially successful. Please verify your email with the OTP sent to your email address.",
    "data": {
        "user": {
            "userName": "cs-test",
            "phoneNumber": "0123456789",
            "email": "cs-test@yopmail.com",
            "registrationStatus": "PARTIAL",
            "resultRange": 10,
            "plan": "BASIC",
            "status": "INACTIVE",
            "emailVerificationOtpExpiry": "2025-10-28T05:36:40.909Z",
            "isEmailVerified": false,
            "isOnline": false,
            "isDeleted": false,
            "_id": "69005411376a4cb9967edb52",
            "createdAt": "2025-10-28T05:26:41.119Z",
            "updatedAt": "2025-10-28T05:26:41.119Z",
            "__v": 0
        },
        "otp": "171518"
    }
}
*/

class UserModel {
  final String userName;
  final String phoneNumber;
  final String email;
  final String registrationStatus;
  final int resultRange;
  final String plan;
  final String status;
  final String emailVerificationOtpExpiry;
  final bool isEmailVerified;
  final bool isOnline;
  final bool isDeleted;
  final String id;
  final String createdAt;
  final String updatedAt;
  final int v;

  UserModel({
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.registrationStatus,
    required this.resultRange,
    required this.plan,
    required this.status,
    required this.emailVerificationOtpExpiry,
    required this.isEmailVerified,
    required this.isOnline,
    required this.isDeleted,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      registrationStatus: json['registrationStatus'],
      resultRange: json['resultRange'],
      plan: json['plan'],
      status: json['status'],
      emailVerificationOtpExpiry: json['emailVerificationOtpExpiry'],
      isEmailVerified: json['isEmailVerified'],
      isOnline: json['isOnline'],
      isDeleted: json['isDeleted'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}
