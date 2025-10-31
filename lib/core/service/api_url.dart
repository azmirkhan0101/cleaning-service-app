class ApiUrl {
  static const String baseUrl = 'http://10.10.20.73:8000/api';

  /// =--> Auth Endpoints <--=
  static const String signup = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String validateToken = '$baseUrl/auth/check-token-validity';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
}
