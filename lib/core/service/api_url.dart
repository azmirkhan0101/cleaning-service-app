class ApiUrl {
  static const String baseUrl = 'http://10.10.20.73:8000/api';

  /// =--> Auth Endpoints <--=
  static const String signup = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String validateToken = '$baseUrl/auth/check-token-validity';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String completeRegistration =
      '$baseUrl/auth/complete-registration';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyForgotPasswordOtp =
      '$baseUrl/auth/verify-forgot-password-otp';
  static const String resetPassword = '$baseUrl/auth/reset-password';

  /// =--> Content Endpoints <--=
  static const String getAboutUs = '$baseUrl/admin/content/about-us';
  static const String getPrivacyPolicy =
      '$baseUrl/admin/content/privacy-policy';
  static const String getTermsAndConditions =
      '$baseUrl/admin/content/terms-and-conditions';
  static const String getAffiliationProgram =
      '$baseUrl/admin/content/affiliation-program';
  static const String getKnowledgeHub = '$baseUrl/admin/knowledge-hub';
  static String getKnowledgeHubDetail(String id) =>
      '$baseUrl/admin/knowledge-hub/$id';

  /// =--> Profile Endpoints <--=
  static const String profile = '$baseUrl/auth/me';
  static const String updateOwnerProfile = '$baseUrl/profile/owner';
  static const String updateProviderProfile = '$baseUrl/profile/provider';
  static const String changePassword = '$baseUrl/auth/change-password';
  static const String getReferralInfo = '$baseUrl/referral/my-info';

  /// =--> Subscription Endpoints <--=
  static const String subscriptionPlans = '$baseUrl/subscription/plans';
  static const String subscriptionCheckout = '$baseUrl/subscription/checkout';

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
  static const String searchFilter = '$baseUrl/service/search-filter';

  /// =--> Service Details Endpoints <--=
  static String serviceDetails(String serviceId) =>
      '$baseUrl/service/details/$serviceId';
  static String serviceProviderDetails(String serviceId) =>
      '$baseUrl/service/provider/details/$serviceId';
  static String serviceRatingsReviews(String serviceId) =>
      '$baseUrl/service/ratings-reviews/$serviceId';
  static String serviceProviderSchedule(String serviceId) =>
      '$baseUrl/service/provider/schedule/$serviceId';
  static const String providerHomepageData =
      '$baseUrl/service/provider/homepage-data';

  /// =--> Provider Service Endpoints <--=
  static String myServices({int page = 1, int limit = 20}) =>
      '$baseUrl/service/my/services?page=$page&limit=$limit';
  static const String createService = '$baseUrl/service/create';

  /// =--> Discovery / Distance Endpoints <--=
  static String nearbyServices({int radiusKm = 200, int limit = 50}) =>
      '$baseUrl/distance/nearby?radiusKm=$radiusKm&limit=$limit';

  /// =--> Booking Endpoints <--=
  static const String bookNow = '$baseUrl/booking/book-now';

  /// =--> Payment Endpoints <--=
  static const String createPayment = '$baseUrl/payment/booking/create';

  /// =--> Messages Endpoints <--=
  static const String messagesUsers = '$baseUrl/messages/users';
  static const String messagesUnreadCount = '$baseUrl/messages/unread-count';
  static String messagesByUser(String userId) => '$baseUrl/messages/$userId';
  static String markMessagesAsRead(String userId) =>
      '$baseUrl/messages/mark-read/$userId';
  static String sendMessage(String userId) => '$baseUrl/messages/$userId';

  // Owner bookings
  static const String ownerMyBookings = '$baseUrl/booking/my-bookings';
  static const String ownerPendingBookings =
      '$baseUrl/booking/owner/pending-bookings';
  static const String ownerOngoingBookings =
      '$baseUrl/booking/owner/ongoing-bookings';
  static const String ownerCompletedBookings =
      '$baseUrl/booking/owner/completed-bookings';
  static const String ownerCancelledBookings =
      '$baseUrl/booking/owner/cancelled-bookings';

  // Provider bookings
  static const String providerMyBookings = '$baseUrl/booking/provider-bookings';
  static const String providerPendingBookings =
      '$baseUrl/booking/provider/pending-bookings';
  static const String providerOngoingBookings =
      '$baseUrl/booking/provider/ongoing-bookings';
  static const String providerCompletedBookings =
      '$baseUrl/booking/provider/completed-bookings';
  static const String providerCancelledBookings =
      '$baseUrl/booking/provider/cancelled-bookings';

  // Booking details
  static String bookingOwnerDetails(String bookingId) =>
      '$baseUrl/booking/owner/$bookingId';
  static String bookingProviderDetails(String bookingId) =>
      '$baseUrl/booking/provider/$bookingId';

  // Booking actions (provider)
  static String acceptBooking(String bookingId) =>
      '$baseUrl/booking/accept/$bookingId';
  static String rejectBooking(String bookingId) =>
      '$baseUrl/booking/reject/$bookingId';
  static String generateBookingQr(String bookingId) =>
      '$baseUrl/booking/generate-qr/$bookingId';
  static String cancelBooking(String bookingId) =>
      '$baseUrl/booking/cancel/$bookingId';
  static String completeBookingByQr(String bookingId) =>
      '$baseUrl/booking/complete-by-qr/$bookingId';
  static String bookingRatingReview(String bookingId) =>
      '$baseUrl/booking/rating-review/$bookingId';
}
