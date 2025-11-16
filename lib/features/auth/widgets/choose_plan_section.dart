import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/profile_setup_controller.dart';
import 'package:cleaning_service_app/features/auth/screens/login_screen.dart';
import 'package:cleaning_service_app/features/payment/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const Color primaryDarkBlue = Color(0xFF13224B);
const Color primaryYellow = Color(0xFFFFC000);
const Color cardBorderBlue = Color(0xFF1E88E5);
const Color unselectedTextColor = Color(0xFF6A6A6A);

class ChoosePlanSection extends StatelessWidget {
  ChoosePlanSection({super.key});

  final ProfileSetupController selectionController =
      Get.find<ProfileSetupController>();

  @override
  Widget build(BuildContext context) {
    // Fetch plans when widget builds
    if (selectionController.subscriptionPlans.isEmpty) {
      selectionController.fetchSubscriptionPlans();
    }

    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Heading and Subheading
          const CustomText2(
            text: AppStrings.chooseYourPlan,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),

          const SizedBox(height: 12),

          const CustomText2(
            text: AppStrings.chooseYourPlanTitle,
            fontSize: 12,
            color: unselectedTextColor,
            fontWeight: FontWeight.w400,
            maxLines: 3,
            textAlign: TextAlign.start,
          ),

          const SizedBox(height: 16),

          // Loading indicator
          if (selectionController.isLoadingPlans.value)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (selectionController.subscriptionPlans.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('No subscription plans available'),
              ),
            )
          else ...[
            // Monthly Plans or Annual Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8.w,
              children: [
                CustomText(
                  text: 'Billed Monthly',
                  textAlign: TextAlign.right,
                  color: const Color(0xFF4F4F59),
                  fontSize: 12,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                  height: 1.20,
                ),
                Switch(
                  value: selectionController.isYearlyPlan.value,
                  onChanged: (isYearly) {
                    selectionController.isYearlyPlan.value = isYearly;
                  },
                ),
                CustomText(
                  text: 'Billed Yearly (save 20%)',
                  color: const Color(0xFF1B2D51),
                  fontSize: 12,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Dynamic plan cards from API
            ...selectionController.subscriptionPlans.asMap().entries.map((
              entry,
            ) {
              final index = entry.key;
              final plan = entry.value;
              final isYearly = selectionController.isYearlyPlan.value;
              final monthlyPrice = plan.price; // integer monthly price
              final originalYearly = monthlyPrice * 12;
              final discountedYearly = (monthlyPrice * 12 * 0.8).round();
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildPlanCard(
                  value: index,
                  price: selectionController.formatPrice(
                    monthlyPrice,
                    isYearly,
                  ),
                  originalYearlyPrice: '€$originalYearly',
                  discountedYearlyPrice: '€$discountedYearly / year',
                  isYearly: isYearly,
                  monthlyPrice: monthlyPrice,
                  badge: plan.limits.badge ?? plan.plan,
                  features: plan.features,
                ),
              );
            }),
          ],

          SizedBox(height: 20.h),

          CustomButton(
            onTap: () {
              Get.to(
                () => PaymentScreen(),
              ); // TEMPORARY BYPASS FOR TESTING PAYMENT SCREEN
              return; // TEMPORARY BYPASS FOR TESTING PAYMENT SCREEN
              if (selectionController.isUploading.value) {
                return; // Disabled state - do nothing
              }
              // Call API for Provider after selecting plan
              selectionController.completeRegistrationSetup().then((success) {
                if (success) {
                  if (selectionController.typPaymentStatues.value == 0) {
                    // Free plan selected
                    Get.offAll(() => LoginScreen());
                    return;
                  }
                  Get.to(() => PaymentScreen());
                }
              });
            },

            title: selectionController.isUploading.value
                ? 'Processing...'
                : AppStrings.continueText,
            fontSize: 16,
            width: double.infinity,
            height: 50,
            fillColor: selectionController.isUploading.value
                ? AppColors.grey_1
                : AppColors.appColors,
            borderRadius: 24,
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required int value,
    required String price, // Used when monthly billing
    required String originalYearlyPrice, // e.g. €324 / year
    required String discountedYearlyPrice, // e.g. €259 / year
    required bool isYearly,
    required int monthlyPrice,
    String? commission,
    required String badge,
    required List<String> features,
  }) {
    final isSelected = selectionController.typPaymentStatues.value == value;

    return GestureDetector(
      onTap: () {
        selectionController.typPaymentStatues.value = value;
        debugPrint('Selected Plan Value: $value');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Check circle icon
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: isSelected
                ? Assets.icons.checkCircleBlue.svg(width: 20.w, height: 20.h)
                : Assets.icons.circle.svg(width: 20.w, height: 20.h),
          ),

          SizedBox(width: 12.w),

          // Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4899D1)
                    : const Color(0xFFE9EBF3),
                border: Border.all(
                  width: isSelected ? 1.60 : 0.3,
                  color: isSelected
                      ? const Color(0xFF4899D1)
                      : const Color(0xFF4F4F59),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Price and Badge Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price and Commission
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pricing display
                            if (isYearly && monthlyPrice > 0) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomText(
                                    text: originalYearlyPrice,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white70
                                        : const Color(0xFF4F4F59),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  const SizedBox(width: 6),
                                  CustomText(
                                    text: discountedYearlyPrice,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF0F0B18),
                                  ),
                                ],
                              ),
                            ] else ...[
                              CustomText(
                                text: price,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF0F0B18),
                              ),
                            ],
                            if (commission != null) ...[
                              const SizedBox(height: 4),
                              CustomText(
                                text: commission,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF4F4F59),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFB9C2DB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomText2(
                          text: badge,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4899D1),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: commission != null ? 16 : 4),

                  // Features
                  ...features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 18,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF4899D1),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: CustomText(
                              text: feature,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF0F0B18),
                              maxLines: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
