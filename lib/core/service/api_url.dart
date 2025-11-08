class ApiUrl {
  static const String baseUrl = 'http://10.10.20.73:8000/api';

  /// =--> Auth Endpoints <--=
  static const String signup = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String validateToken = '$baseUrl/auth/check-token-validity';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String completeRegistration =
      '$baseUrl/auth/complete-registration';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyForgotPasswordOtp =
      '$baseUrl/auth/verify-forgot-password-otp';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String getAffiliationProgram =
      '$baseUrl/admin/content/affiliation-program';
  static const String profile = '$baseUrl/auth/me';
  static const String updateOwnerProfile = '$baseUrl/profile/owner';
  static const String changePassword = '$baseUrl/auth/change-password';

  /// =--> Notification Endpoints <--=
  static const String notifications = '$baseUrl/notifications';
  static String markNotificationAsRead(String notificationId) =>
      '$baseUrl/notifications/read/$notificationId';
  static const String markAllNotificationsAsRead =
      '$baseUrl/notifications/mark-all-read';
  static String deleteNotification(String notificationId) =>
      '$baseUrl/notifications/$notificationId';

  /// =--> Service Category Endpoints <--=
  static const String serviceCategories = '$baseUrl/service/categories';
  static String servicesByCategory(String categoryId) =>
      '$baseUrl/service/category/services/$categoryId';

  /// =--> Service Details Endpoints <--=
  static String serviceDetails(String serviceId) =>
      '$baseUrl/service/details/$serviceId';
  static String serviceProviderDetails(String serviceId) =>
      '$baseUrl/service/provider/details/$serviceId';
  static String serviceRatingsReviews(String serviceId) =>
      '$baseUrl/service/ratings-reviews/$serviceId';
  static String serviceProviderSchedule(String serviceId) =>
      '$baseUrl/service/provider/schedule/$serviceId';

  /// =--> Booking Endpoints <--=
  static const String myBookings = '$baseUrl/booking/my-bookings';
  static String bookingOwnerDetails(String bookingId) =>
      '$baseUrl/booking/owner/$bookingId';
  static const String pendingBookings =
      '$baseUrl/booking/owner/pending-bookings';
  static const String ongoingBookings =
      '$baseUrl/booking/owner/ongoing-bookings';
  static const String completedBookings =
      '$baseUrl/booking/owner/completed-bookings';
  static const String cancelledBookings =
      '$baseUrl/booking/owner/cancelled-bookings';
}
