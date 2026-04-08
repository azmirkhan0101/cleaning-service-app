// import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
// import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
// import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
// import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
// import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
// import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
// import 'package:cleaning_service_app/features/common/widgets/bulleted_list.dart';
// import 'package:cleaning_service_app/features/profile/controllers/referral_controller.dart';
// import 'package:cleaning_service_app/features/profile/models/referral_model.dart';
// import 'package:cleaning_service_app/features/profile/screens/redeem_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// class ReferScreen extends StatefulWidget {
//   const ReferScreen({super.key});
//
//   @override
//   State<ReferScreen> createState() => _ReferScreenState();
// }
//
// class _ReferScreenState extends State<ReferScreen> {
//   final ReferralController controller = Get.put(ReferralController());
//
//   @override
//   void initState() {
//     super.initState();
//     controller.fetchReferralInfo();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFE9EBF3),
//       appBar: CustomAppBar(
//         title: 'Refer Your \n Friends and Earn',
//         backButton: true,
//       ),
//       body: Obx(() {
//         // Loading state
//         if (controller.isLoading.value) {
//           return Center(
//             child: CircularProgressIndicator(color: AppColors.lightBlue),
//           );
//         }
//
//         // Error state
//         if (controller.errorMessage.value.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Display error icon and message
//                 Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
//                 SizedBox(height: 16),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                   child: CustomText2(
//                     text: controller.errorMessage.value,
//                     fontSize: 16,
//                     color: Colors.red.shade700,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () => controller.retry(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.lightBlue,
//                   ),
//                   child: Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         // Content state
//         final referralInfo = controller.referralInfo.value;
//         if (referralInfo == null) {
//           return Center(
//             child: CustomText2(
//               text: 'No referral information available',
//               fontSize: 16,
//             ),
//           );
//         }
//
//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(height: 24),
//
//                 /// Redeem balance card
//                 _buildRedeemBalanceCard(),
//
//                 /// Display credits if needed
//                 // if (referralInfo.myCredits > 0)
//                 // Container(
//                 //   padding: EdgeInsets.all(12),
//                 //   decoration: BoxDecoration(
//                 //     color: Colors.green.shade50,
//                 //     borderRadius: BorderRadius.circular(12),
//                 //     border: Border.all(color: Colors.green.shade200),
//                 //   ),
//                 //   child: Row(
//                 //     children: [
//                 //       Icon(Icons.card_giftcard, color: Colors.green),
//                 //       SizedBox(width: 8),
//                 //       CustomText2(
//                 //         text: 'My Credits: ${referralInfo.myCredits}',
//                 //         fontSize: 14,
//                 //         fontWeight: FontWeight.w600,
//                 //         color: Colors.green.shade700,
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//
//                 /// Gift box image
//                 CustomImage(imageSrc: AppImages.refer_image, height: 300),
//
//                 /// Get 10 free credits text
//                 _buildGet10Credit(),
//                 SizedBox(height: 16),
//
//                 _buildImportantNote(referralInfo),
//                 SizedBox(height: 32),
//                 ElevatedButton(
//                   onPressed: () => controller.shareReferralCode(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.appColors,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     minimumSize: Size(
//                       MediaQuery.of(context).size.width * 0.9,
//                       50,
//                     ),
//                   ),
//                   child: CustomText2(
//                     text: 'Share Now',
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   Padding _buildImportantNote(ReferralModel referralInfo) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomText(
//             text: 'Discount Criteria',
//             color: const Color(0xFF0F0B18),
//             fontSize: 14,
//             fontFamily: 'Lexend',
//             fontWeight: FontWeight.w700,
//             height: 1.50,
//           ),
//           SizedBox(height: 8),
//
//           BulletedList(
//             text:
//                 'Inviter (existing user) receives €10 credit when the invited user makes their first booking or service.',
//           ),
//           SizedBox(height: 6),
//
//           BulletedList(
//             text:
//                 'Bonus tier: if the invited user completed 3 booking or service, inviter gets additional €5 credit.',
//           ),
//           SizedBox(height: 6),
//
//           BulletedList(
//             text:
//                 'Can use your earned credits as a discount when purchasing a subscription plan.',
//           ),
//           SizedBox(height: 6),
//
//           BulletedList(
//             text:
//                 'Every referral done by you and earn 10 credits that respectively are 2€.',
//           ),
//           SizedBox(height: 32),
//
//           /// Referral Code Card
//           Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.lightBlue,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   offset: Offset(0, 4),
//                   blurRadius: 6,
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 /// Referral Code
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Your Referral Code',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       referralInfo.myReferralCode,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Spacer(),
//                 GestureDetector(
//                   onTap: () => controller.copyReferralCode(),
//                   child: Row(
//                     children: [
//                       Icon(Icons.copy, color: Colors.white, size: 20),
//                       SizedBox(width: 4),
//                       CustomText(
//                         text: "Copy Code",
//                         color: AppColors.white_50,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 12,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   Text _buildGet10Credit() {
//     return Text.rich(
//       TextSpan(
//         children: [
//           TextSpan(
//             text: 'Get ',
//             style: TextStyle(
//               color: const Color(0xFF0F0B18),
//               fontSize: 16,
//               fontFamily: 'Lexend',
//               fontWeight: FontWeight.w500,
//               height: 1.50,
//             ),
//           ),
//           TextSpan(
//             text: '10',
//             style: TextStyle(
//               color: const Color(0xFF4899D1),
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//               fontFamily: 'Lexend',
//               height: 1.50,
//             ),
//           ),
//           TextSpan(
//             text: ' free credit',
//             style: TextStyle(
//               color: const Color(0xFF0F0B18),
//               fontSize: 16,
//               fontFamily: 'Lexend',
//               fontWeight: FontWeight.w500,
//               height: 1.50,
//             ),
//           ),
//         ],
//       ),
//       textAlign: TextAlign.center,
//     );
//   }
//
//   Container _buildRedeemBalanceCard() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Icon(Icons.credit_card, color: Colors.black),
//           SizedBox(width: 8),
//           Text(
//             'Balance: ${controller.referralInfo.value?.myCredits ?? '...'} Credits',
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 14,
//               fontFamily: 'Lexend',
//               fontWeight: FontWeight.w400,
//               height: 1.50,
//             ),
//           ),
//           SizedBox(width: 28.w),
//           FilledButton(
//             onPressed: () async {
//               final result = await Get.to(
//                 RedeemScreen(
//                   currentBalance: controller.referralInfo.value?.myCredits ?? 0,
//                 ),
//               );
//
//               // Refetch referral info after returning from redeem screen
//               if (result == true) {
//                 controller.fetchReferralInfo();
//               }
//             },
//             style: FilledButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//               backgroundColor: const Color(0xFFF7A51D),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: CustomText(
//               text: 'Redeem',
//               textAlign: TextAlign.right,
//               color: Colors.white,
//               fontSize: 10,
//               fontFamily: 'Lexend',
//               fontWeight: FontWeight.w600,
//               height: 1.50,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
