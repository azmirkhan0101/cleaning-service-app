import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/auth/models/subscription_plan_model.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/provider/subscription/models/subscription_checkout_response.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  RxBool isLoadingPlans = false.obs;
  RxString errorMessage = ''.obs;
  RxList<SubscriptionPlanModel> subscriptionPlans =
      <SubscriptionPlanModel>[].obs;
  Rx<SubscriptionPlanModel?> selectedPlan = Rx<SubscriptionPlanModel?>(null);

  // init
  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionPlans();
  }

  void selectPlan(SubscriptionPlanModel plan) {
    selectedPlan.value = plan;
  }

  RxBool isYearlyPlan = false.obs;
  void togglePlanType() {
    isYearlyPlan.value = !isYearlyPlan.value;
  }

  /// Calculate yearly price
  double calculateYearlyPrice(int monthlyPrice) {
    if (monthlyPrice == 0) return 0;
    return (monthlyPrice * 12);
  }

  /// add 20% discount
  /// Returns the discounted yearly price (monthly price * 12 * 0.8)
  double calculateDiscountedYearlyPrice(int monthlyPrice) {
    if (monthlyPrice == 0) return 0;
    return (monthlyPrice * 12 * 0.8);
  }

  /// Format price display based on billing period
  String formatPrice(int monthlyPrice, bool isYearly) {
    if (monthlyPrice == 0) return 'Free';
    if (isYearly) {
      final yearlyPrice = calculateYearlyPrice(monthlyPrice);
      return '€${yearlyPrice.toStringAsFixed(0)} / year';
    }
    return '€$monthlyPrice / month';
  }

  /// Fetch subscription plans from API
  Future<void> fetchSubscriptionPlans() async {
    try {
      isLoadingPlans.value = true;
      errorMessage.value = '';

      final response = await Get.find<NetworkHelper>()
          .request<SubscriptionPlansResponse>(
            HttpRequestType.get.method,
            ApiUrl.subscriptionPlans,
            parser: (data) => SubscriptionPlansResponse.fromJson(data),
          );

      response.fold(
        (error) {
          errorMessage.value = error.message ?? 'Failed to load plans';
          debugPrint('Error fetching plans: ${error.message}');
        },
        (data) {
          subscriptionPlans.value = data.data;
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to load subscription plans';
      debugPrint('Exception fetching plans: $e');
    } finally {
      isLoadingPlans.value = false;
    }
  }

  // Checkout state
  final isCreatingCheckout = false.obs;
  final checkoutData = Rxn<SubscriptionCheckoutData>();
  final checkoutError = ''.obs;

  Future<SubscriptionCheckoutData?> createCheckout({
    required String plan,
    required String paymentMethodId,
    required String timeline, // 'MONTHLY' | 'YEARLY'
    int creditsToUse = 0,
  }) async {
    if (isCreatingCheckout.value) return checkoutData.value;
    try {
      isCreatingCheckout.value = true;
      checkoutError.value = '';

      final body = <String, dynamic>{
        'plan': plan,
        'paymentMethodId': paymentMethodId,
        'timeline': timeline,
      };
      if (creditsToUse > 0) {
        body['creditsToUse'] = creditsToUse;
      }

      final response = await Get.find<NetworkHelper>()
          .request<SubscriptionCheckoutResponse>(
            HttpRequestType.post.method,
            ApiUrl.subscriptionCheckout,
            body: body,
            parser: (data) => SubscriptionCheckoutResponse.fromJson(data),
          );

      return response.fold(
        (error) {
          checkoutError.value = error.message ?? 'Failed to create checkout';
          debugPrint('Checkout error: ${error.message}');
          return null;
        },
        (data) {
          checkoutData.value = data.data;
          return data.data;
        },
      );
    } catch (e) {
      checkoutError.value = 'Failed to create checkout';
      debugPrint('Exception creating checkout: $e');
      return null;
    } finally {
      isCreatingCheckout.value = false;
    }
  }
}
