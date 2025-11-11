class ProviderHomepageData {
  final double latitude;
  final double longitude;
  final int pendingBookings;
  final int unreadMessages;
  final String currentPlan;

  const ProviderHomepageData({
    required this.latitude,
    required this.longitude,
    required this.pendingBookings,
    required this.unreadMessages,
    required this.currentPlan,
  });

  factory ProviderHomepageData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final loc = data['location'] as Map<String, dynamic>? ?? {};
    return ProviderHomepageData(
      latitude: (loc['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (loc['longitude'] as num?)?.toDouble() ?? 0.0,
      pendingBookings: (data['pendingBookings'] as num?)?.toInt() ?? 0,
      unreadMessages: (data['unreadMessages'] as num?)?.toInt() ?? 0,
      currentPlan: data['currentPlan']?.toString() ?? '',
    );
  }
}
