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
          // 1. Sync the local service status with RevenueCat
          await SubscriptionService.to.checkPremiumStatus();

          // 2. Verify if they unlocked any tier
          if (SubscriptionService.to.hasAnyPremium) {
            String planName = "";

            // Check descending order so we capture the highest tier they own
            if (SubscriptionService.to.hasPlatinum) {
              planName = "Platinum";
            } else if (SubscriptionService.to.hasGold) {
              planName = "Gold";
            } else if (SubscriptionService.to.hasSilver) {
              planName = "Silver";
            }

            // 3. Navigate the user to the home screen
            Get.offAllNamed(AppRoutes.providerHome);

            // 4. Show the tailored toast message
            if (planName.isNotEmpty) {
              Toast.successToast("You have successfully subscribed to $planName!");
            } else {
              Toast.successToast("You have successfully subscribed!");
            }
          }
        },
        onPurchaseError: (purchaseError){
          Toast.warningToast(purchaseError.message);
        },
        onRestoreError: (restoreError){
          Toast.warningToast( restoreError.message );
        },
        onRestoreCompleted: (customerInfo) async {
          await SubscriptionService.to.checkPremiumStatus();
          if (SubscriptionService.to.hasAnyPremium) {
            Get.offAllNamed(AppRoutes.providerHome);
            Toast.successToast("Your purchases have been successfully restored.");
          } else {
            Toast.warningToast("No active subscription found for this account.");
          }
        },
      ),
    );
  }
}