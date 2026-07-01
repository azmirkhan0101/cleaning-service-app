// import 'dart:async';
//
// import 'package:cleaning_service_app/core/service/api_url.dart';
// import 'package:cleaning_service_app/core/service/network_helper.dart';
// import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
// import 'package:cleaning_service_app/features/profile/widgets/withdraw_success_dialog.dart';
// import 'package:cleaning_service_app/features/provider/subscription/screens/subscription_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class RedeemController extends GetxController {
//   final _networkHelper = Get.find<NetworkHelper>();
//
//   final creditsController = TextEditingController();
//   Timer? _debounceTimer;
//
//   final isCalculating = false.obs;
//   final isWithdrawing = false.obs;
//
//   final dollarValue = 0.0.obs;
//   final minimumCreditsRequired = 10.obs;
//   final conversionRate = '10 credits = €2'.obs;
//
//   final currentBalance = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Listen to text changes and auto-calculate
//     creditsController.addListener(_onCreditsChanged);
//   }
//
//   void _onCreditsChanged() {
//     // Cancel the previous timer if it exists
//     _debounceTimer?.cancel();
//
//     final credits = int.tryParse(creditsController.text);
//     if (credits != null && credits > 0) {
//       // Wait 500ms after user stops typing before calling API
//       _debounceTimer = Timer(const Duration(milliseconds: 500), () {
//         calculatePreview(credits);
//       });
//     } else {
//       // Reset values if input is invalid
//       dollarValue.value = 0.0;
//     }
//   }
//
//   void setCurrentBalance(int balance) {
//     currentBalance.value = balance;
//   }
//
//   Future<void> calculatePreview(int credits) async {
//     if (isCalculating.value) return;
//
//     isCalculating.value = true;
//
//     try {
//       final result = await _networkHelper.request<Map<String, dynamic>>(
//         'POST',
//         ApiUrl.calculateRedemption,
//         body: {'credits': credits},
//         parser: (data) => data as Map<String, dynamic>,
//       );
//
//       result.fold(
//         (error) {
//           debugPrint('Calculate preview error: ${error.message}');
//           // Don't show error toast for auto-calculations
//         },
//         (response) {
//           final data = response['data'];
//           if (data != null) {
//             dollarValue.value = (data['dollarValue'] ?? 0.0).toDouble();
//             minimumCreditsRequired.value = data['minimumCreditsRequired'] ?? 10;
//             conversionRate.value = data['conversionRate'] ?? '10 credits = €2';
//           }
//         },
//       );
//     } catch (e) {
//       debugPrint('Error calculating preview: $e');
//     } finally {
//       isCalculating.value = false;
//     }
//   }
//
//   Future<void> withdraw(bool isOwner) async {
//     final credits = int.tryParse(creditsController.text);
//
//     if (credits == null || credits <= 0) {
//       Toast.errorToast('Please enter a valid amount');
//       return;
//     }
//
//     if (credits < minimumCreditsRequired.value) {
//       Toast.errorToast(
//         'Minimum redeemable amount is ${minimumCreditsRequired.value} Credits',
//       );
//       return;
//     }
//
//     if (credits > currentBalance.value) {
//       Toast.errorToast('Insufficient balance');
//       return;
//     }
//
//     // Check if user is owner
//     if (!isOwner) {
//       Toast.successToast('You can use redeem point in your subscription plan');
//       Get.to(SubscriptionScreen(redeemPoint: credits));
//       return;
//     }
//
//     isWithdrawing.value = true;
//
//     final result = await _networkHelper.request<Map<String, dynamic>>(
//       'POST',
//       ApiUrl.redeemForCash,
//       body: {'credits': credits},
//       parser: (data) => data as Map<String, dynamic>,
//     );
//
//     isWithdrawing.value = false;
//
//     result.fold(
//       (error) {
//         Toast.errorToast(error.message ?? 'Withdrawal failed');
//       },
//       (response) {
//         // Show success dialog for owner
//         Get.dialog(const WithdrawSuccessDialog(), barrierDismissible: false);
//       },
//     );
//   }
//
//   @override
//   void onClose() {
//     _debounceTimer?.cancel();
//     creditsController.dispose();
//     super.onClose();
//   }
// }
