// import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
// import 'package:cleaning_service_app/core/service/app_storage_service.dart';
// import 'package:cleaning_service_app/features/common/types/role.dart';
// import 'package:cleaning_service_app/features/profile/controllers/redeem_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// class RedeemScreen extends StatelessWidget {
//   final int currentBalance;
//
//   const RedeemScreen({super.key, required this.currentBalance});
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize controller and set balance
//     final controller = Get.put(RedeemController());
//     controller.setCurrentBalance(currentBalance);
//
//     final bool isOwner = AppStorageService.getUserRole() == Role.owner.value;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFF0F0B18)),
//           onPressed: () => Get.back(result: true),
//         ),
//         title: CustomText(
//           text: 'Redeem Point',
//           fontSize: 24,
//           fontWeight: FontWeight.w600,
//           color: const Color(0xFF0F0B18),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 8),
//
//               // Balance display
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.credit_card_outlined,
//                     size: 24,
//                     color: Color(0xFF0F0B18),
//                   ),
//                   const SizedBox(width: 10),
//                   CustomText(
//                     text: 'Balance: $currentBalance Credits',
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: const Color(0xFF0F0B18),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//
//               // Credits input field
//               Container(
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE9EBF3),
//                   border: Border.all(color: const Color(0xFF4F4F59), width: 1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: TextField(
//                   controller: controller.creditsController,
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.center,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   style: const TextStyle(
//                     fontFamily: 'Lexend',
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF0F0B18),
//                   ),
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 7,
//                       vertical: 10,
//                     ),
//                     hintText: 'Enter amount to calculate',
//                     hintStyle: TextStyle(
//                       fontFamily: 'Lexend',
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF4F4F59),
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               // Minimum credits message
//               Obx(
//                 () => Align(
//                   alignment: Alignment.centerLeft,
//                   child: CustomText(
//                     text:
//                         'Minimum redeemable amount is ${controller.minimumCreditsRequired.value} Credits',
//                     fontSize: 8,
//                     fontWeight: FontWeight.w400,
//                     color: const Color(0xFFDE5640),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Conversion icon
//               Center(
//                 child: Icon(
//                   Icons.swap_vert,
//                   size: 24,
//                   color: const Color(0xFF0F0B18),
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               // Dollar value display
//               Obx(
//                 () => Container(
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE9EBF3),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   alignment: Alignment.center,
//                   child: CustomText(
//                     text: '${controller.dollarValue.value.toStringAsFixed(1)}€',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                     color: const Color(0xFFDE5640),
//                   ),
//                 ),
//               ),
//
//               const Spacer(),
//
//               // Withdraw button
//               Obx(
//                 () => SizedBox(
//                   width: double.infinity,
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: controller.isWithdrawing.value
//                         ? null
//                         : () => controller.withdraw(isOwner),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFF7A51D),
//                       disabledBackgroundColor: const Color(
//                         0xFFF7A51D,
//                       ).withValues(alpha: 0.6),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 18,
//                         vertical: 12,
//                       ),
//                     ),
//                     child: controller.isWithdrawing.value
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.white,
//                               ),
//                             ),
//                           )
//                         : const CustomText(
//                             text: 'Withdraw',
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 16.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
