class ReferralModel {
  final String myReferralCode;
  final int myCredits;
  final String shareMessage;

  ReferralModel({
    required this.myReferralCode,
    required this.myCredits,
    required this.shareMessage,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      myReferralCode: json['myReferralCode'] ?? '',
      myCredits: json['myCredits'] ?? 0,
      shareMessage: json['shareMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myReferralCode': myReferralCode,
      'myCredits': myCredits,
      'shareMessage': shareMessage,
    };
  }
}
