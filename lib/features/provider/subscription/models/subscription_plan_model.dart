class SubscriptionPlanModel {
  final String plan;
  final PlanLimits limits;
  final int price;
  final List<String> features;

  SubscriptionPlanModel({
    required this.plan,
    required this.limits,
    required this.price,
    required this.features,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      plan: json['plan'] as String,
      limits: PlanLimits.fromJson(json['limits'] as Map<String, dynamic>),
      price: json['price'] as int,
      features: (json['features'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan': plan,
      'limits': limits.toJson(),
      'price': price,
      'features': features,
    };
  }
}

class PlanLimits {
  final int servicesLimit; // -1 means unlimited
  final int bookingsPerMonth; // -1 means unlimited
  final int categoriesLimit; // -1 means unlimited
  final int priority;
  final String? badge;

  PlanLimits({
    required this.servicesLimit,
    required this.bookingsPerMonth,
    required this.categoriesLimit,
    required this.priority,
    this.badge,
  });

  factory PlanLimits.fromJson(Map<String, dynamic> json) {
    return PlanLimits(
      servicesLimit: json['servicesLimit'] as int,
      bookingsPerMonth: json['bookingsPerMonth'] as int,
      categoriesLimit: json['categoriesLimit'] as int,
      priority: json['priority'] as int,
      badge: json['badge'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'servicesLimit': servicesLimit,
      'bookingsPerMonth': bookingsPerMonth,
      'categoriesLimit': categoriesLimit,
      'priority': priority,
      'badge': badge,
    };
  }

  bool get hasUnlimitedServices => servicesLimit == -1;
  bool get hasUnlimitedBookings => bookingsPerMonth == -1;
  bool get hasUnlimitedCategories => categoriesLimit == -1;
}

class SubscriptionPlansResponse {
  final bool success;
  final String message;
  final List<SubscriptionPlanModel> data;

  SubscriptionPlansResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SubscriptionPlansResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => SubscriptionPlanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
