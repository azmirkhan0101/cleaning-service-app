/*
Actual API Response:
{
    "success": true,
    "message": "Registration initiated successfully. Please verify your email with the OTP sent to your email address.",
    "data": {
        "email": "provider2@yopmail.com",
        "userName": "Provider 2",
        "otp": "809419"
    }
}
*/

class SignupResponseModel {
  final String email;
  final String userName;
  final String otp;

  SignupResponseModel({
    required this.email,
    required this.userName,
    required this.otp,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      email: json['email'] ?? '',
      userName: json['userName'] ?? '',
      otp: json['otp'] ?? '',
    );
  }
}
