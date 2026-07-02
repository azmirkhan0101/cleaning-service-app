import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../utils/app_const/revcat_constants.dart';

class SubscriptionService extends GetxService {
  static SubscriptionService get to => Get.find<SubscriptionService>();
  final storage = GetStorage();

  // RevenueCat Status Observables
  final RxBool isRevenueCatSilver = false.obs;
  final RxBool isRevenueCatGold = false.obs;
  final RxBool isRevenueCatPlatinum = false.obs;

  // Backend Status Observables (mapped to the three tiers if needed)
  final RxBool isBackendSilver = false.obs;
  final RxBool isBackendGold = false.obs;
  final RxBool isBackendPlatinum = false.obs;

  // Hierarchical Getters: Higher tiers automatically include lower tier features.
  // (e.g., If hasPlatinum is true, hasGold and hasSilver will also evaluate to true)
  bool get hasPlatinum => isBackendPlatinum.value || isRevenueCatPlatinum.value;
  bool get hasGold => isBackendGold.value || isRevenueCatGold.value || hasPlatinum;
  bool get hasSilver => isBackendSilver.value || isRevenueCatSilver.value || hasGold;

  // Quick helper check if the user has any active premium tier
  bool get hasAnyPremium => hasSilver || hasGold || hasPlatinum;

  Future<SubscriptionService> init() async {
    await Purchases.setLogLevel(LogLevel.info);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(RevenueCatConstants.androidApiKey);
    } else {
      configuration = PurchasesConfiguration(RevenueCatConstants.iosApiKey);
    }

    // Configure the SDK. Identify the user later during your custom login.
    await Purchases.configure(configuration);

    // Listen to entitlement changes (from external purchases or background renewals)
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _updateRevenueCatStatus(customerInfo);
    });

    return this;
  }

  // Identifies the user in RevenueCat using your backend User ID
  Future<void> loginUser(String providerUserId) async {
    try {
      LogInResult result = await Purchases.logIn(providerUserId);
      _updateRevenueCatStatus(result.customerInfo);

      // Log current statuses for debugging
      print("isRcLoginSuccessful: ${result.created}");
      print("RC Login Success!");
      print("Silver Active: ${isRevenueCatSilver.value}");
      print("Gold Active: ${isRevenueCatGold.value}");
      print("Platinum Active: ${isRevenueCatPlatinum.value}");
    } catch (e) {
      print("RevenueCat Login Error: $e");
    }
  }

  // Clears all subscription states when logging out
  Future<void> logoutUser() async {
    try {
      await Purchases.logOut();
      _clearStatus();
    } catch (e) {
      print("RevenueCat Logout Error: $e");
    }
  }

  // Validates the combined status on app restart or manual refresh
  Future<void> checkPremiumStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      _updateRevenueCatStatus(customerInfo);
    } catch (e) {
      print("Error fetching RC customer info: $e");
    }
  }

  // Parses entitlement maps and updates local reactive states
  void _updateRevenueCatStatus(CustomerInfo customerInfo) {
    isRevenueCatSilver.value = customerInfo.entitlements.all[RevenueCatConstants.entitlementSilver]?.isActive ?? false;
    isRevenueCatGold.value = customerInfo.entitlements.all[RevenueCatConstants.entitlementGold]?.isActive ?? false;
    isRevenueCatPlatinum.value = customerInfo.entitlements.all[RevenueCatConstants.entitlementPlatinum]?.isActive ?? false;
  }

  // Reset helper helper to prevent leaks on logout
  void _clearStatus() {
    isRevenueCatSilver.value = false;
    isRevenueCatGold.value = false;
    isRevenueCatPlatinum.value = false;

    isBackendSilver.value = false;
    isBackendGold.value = false;
    isBackendPlatinum.value = false;
  }

  Future<void> restorePurchase(BuildContext context) async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      _updateRevenueCatStatus(customerInfo); // Updates the UI state immediately

      if (customerInfo.entitlements.active.isNotEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Purchases successfully restored!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Restoration complete, but no active purchases were found.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restore purchases: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}