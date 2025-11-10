class ProviderPendingHomeBooking {
  final String bookingId;
  final String ownerName;
  final String ownerProfilePicture;
  final DateTime bookingDateTime;
  final String timeAgo; // already provided by API

  ProviderPendingHomeBooking({
    required this.bookingId,
    required this.ownerName,
    required this.ownerProfilePicture,
    required this.bookingDateTime,
    required this.timeAgo,
  });

  factory ProviderPendingHomeBooking.fromJson(Map<String, dynamic> json) {
    return ProviderPendingHomeBooking(
      bookingId: json['bookingId']?.toString() ?? '',
      ownerName: json['ownerName']?.toString() ?? '',
      ownerProfilePicture: json['ownerProfilePicture']?.toString() ?? '',
      bookingDateTime:
          DateTime.tryParse(json['bookingDateTime']?.toString() ?? '') ??
          DateTime.now(),
      timeAgo: json['timeAgo']?.toString() ?? '',
    );
  }
}
