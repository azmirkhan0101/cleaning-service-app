import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../../core/components/app_routes/app_routes.dart';
import '../../../../core/service/subscription_service.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaywallView(
        displayCloseButton: true,
        onDismiss: (){
          Navigator.of(context).pop();
        },
        offering: null, // Loads the default active offering and paywall configured in RC dashboard
        onPurchaseCompleted: (customerInfo, storeTransaction) async {
          await SubscriptionService.to.checkPremiumStatus();
          if (SubscriptionService.to.hasPremium) {
            Get.offAllNamed(AppRoutes.providerHome);
            Toast.successToast("You have successfully subscribed!");
            }
        },
        onRestoreCompleted: (customerInfo) async {
          await SubscriptionService.to.checkPremiumStatus();
          if (SubscriptionService.to.hasPremium) {
            Get.offAllNamed(AppRoutes.providerHome);
            Get.snackbar("Restored!", "Your purchases have been successfully restored.", snackPosition: SnackPosition.TOP);
          } else {
            Get.snackbar("Restore Failed", "No active subscription found for this account.", snackPosition: SnackPosition.BOTTOM);
          }
        },
      ),
    );
  }
}