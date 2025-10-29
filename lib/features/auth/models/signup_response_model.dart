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

import 'package:cleaning_service_app/features/auth/models/user_model.dart';

class SignupResponseModel {
  final UserModel user;
  final String otp;

  SignupResponseModel({required this.user, required this.otp});

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      user: UserModel.fromJson(json['user']),
      otp: json['otp'],
    );
  }
}
