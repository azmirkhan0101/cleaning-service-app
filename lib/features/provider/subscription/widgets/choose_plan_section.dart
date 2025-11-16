import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/profile_setup_controller.dart';
import 'package:cleaning_service_app/features/auth/screens/login_screen.dart';
import 'package:cleaning_service_app/features/payment/screens/payment_screen.dart';
import 'package:cleaning_service_app/features/provider/subscription/controller/subscription_controller.dart';
import 'package:cleaning_service_app/features/provider/subscription/screens/subscription_payment_screen.dart';
import 'package:cleaning_service_app/features/provider/subscription/widgets/subscription_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const Color primaryDarkBlue = Color(0xFF13224B);
const Color primaryYellow = Color(0xFFFFC000);
const Color cardBorderBlue = Color(0xFF1E88E5);
const Color unselectedTextColor = Color(0xFF6A6A6A);

class ChoosePlanSection extends StatelessWidget {
  ChoosePlanSection({super.key, this.isProfileSetupSelectionScreen = false});
  final bool isProfileSetupSelectionScreen;

  final ProfileSetupController selectionController =
      Get.find<ProfileSetupController>();

  final subscriptionController = Get.put(SubscriptionController());

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
          const CustomText(
            text: AppStrings.chooseYourPlan,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),

          const SizedBox(height: 12),

          const CustomText(
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
                  value: subscriptionController.isYearlyPlan.value,
                  onChanged: (isYearly) {
                    // selectionController.isYearlyPlan.value = isYearly;
                    subscriptionController.isYearlyPlan.value = isYearly;
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
            ...subscriptionController.subscriptionPlans.asMap().entries.map((
              entry,
            ) {
              final plan = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SubscriptionPlanCard(
                  plan: plan,
                  isSelected: subscriptionController.selectedPlan.value == plan,
                  isYearly: subscriptionController.isYearlyPlan.value,
                ),
              );
            }),
          ],

          SizedBox(height: 20.h),

          CustomButton(
            onTap: () {
              if (!isProfileSetupSelectionScreen) {
                if (subscriptionController.selectedPlan.value?.price == 0) {
                  // Please select a paid plan to continue
                  Toast.errorToast('Please select a paid plan to continue');
                  return;
                }
                Get.to(() => SubscriptionPaymentScreen());
                return;
              }
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

  // Removed unused _buildPlanCard method.
}
