class SubscriptionCheckoutData {
  final String sessionId;
  final String url;
  final String timeline;
  final num monthlyPrice;
  final num originalAmount;
  final num amountAfterYearlyDiscount;
  final num yearlyDiscount;
  final num creditsDiscountApplied;
  final num totalDiscount;
  final num finalAmount;
  final int creditsUsed;
  final int durationDays;
  final String savings;

  SubscriptionCheckoutData({
    required this.sessionId,
    required this.url,
    required this.timeline,
    required this.monthlyPrice,
    required this.originalAmount,
    required this.amountAfterYearlyDiscount,
    required this.yearlyDiscount,
    required this.creditsDiscountApplied,
    required this.totalDiscount,
    required this.finalAmount,
    required this.creditsUsed,
    required this.durationDays,
    required this.savings,
  });

  factory SubscriptionCheckoutData.fromJson(Map<String, dynamic> json) {
    return SubscriptionCheckoutData(
      sessionId: json['sessionId'] as String,
      url: json['url'] as String,
      timeline: json['timeline'] as String,
      monthlyPrice: json['monthlyPrice'] ?? 0,
      originalAmount: json['originalAmount'] ?? 0,
      amountAfterYearlyDiscount: json['amountAfterYearlyDiscount'] ?? 0,
      yearlyDiscount: json['yearlyDiscount'] ?? 0,
      creditsDiscountApplied: json['creditsDiscountApplied'] ?? 0,
      totalDiscount: json['totalDiscount'] ?? 0,
      finalAmount: json['finalAmount'] ?? 0,
      creditsUsed: (json['creditsUsed'] ?? 0) as int,
      durationDays: (json['durationDays'] ?? 0) as int,
      savings: json['savings'] as String? ?? '',
    );
  }
}

class SubscriptionCheckoutResponse {
  final bool success;
  final String message;
  final SubscriptionCheckoutData data;

  SubscriptionCheckoutResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SubscriptionCheckoutResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionCheckoutResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: SubscriptionCheckoutData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }
}
