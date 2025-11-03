import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const Color primaryDarkBlue = Color(0xFF13224B);
const Color primaryYellow = Color(0xFFFFC000);
const Color cardBorderBlue = Color(0xFF1E88E5);
const Color unselectedTextColor = Color(0xFF6A6A6A);

class ChoosePlanSection extends StatelessWidget {
  ChoosePlanSection({super.key});

  final SelectionController selectionController =
      Get.find<SelectionController>();

  @override
  Widget build(BuildContext context) {
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

          const SizedBox(height: 24),

          // Free Plan
          _buildPlanCard(
            value: 0,
            price: '€0 / month',
            commission: 'Commission: 15%',
            badge: 'Free Plan',
            features: ['Standard visibility', 'Standard support'],
          ),

          const SizedBox(height: 16),

          // Silver Plan
          _buildPlanCard(
            value: 1,
            price: '€27 / month',
            commission: null,
            badge: 'Silver',
            features: [
              'Standard visibility',
              'Badge None',
              'Up to 10 job inquiries per month',
              '1 service category only',
              'Eligible for affiliate program',
            ],
          ),

          const SizedBox(height: 16),

          // Gold Plan
          _buildPlanCard(
            value: 2,
            price: '€57 / month',
            commission: null,
            badge: 'Gold',
            features: [
              'Higher visibility',
              '"Gold Verified" badge',
              'Unlimited job inquiries',
              '1 service category only',
              '10% discount on Brikk promotions & campaigns\nHigher trust ranking',
            ],
          ),

          const SizedBox(height: 16),

          // Platinum Plan
          _buildPlanCard(
            value: 3,
            price: '€97 / month',
            commission: null,
            badge: 'Platinum',
            features: [
              'Top-tier visibility (always appears at the top of search results)',
              '"Platinum Partner" featured badge',
              'Unlimited',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required int value,
    required String price,
    String? commission,
    required String badge,
    required List<String> features,
  }) {
    final isSelected = selectionController.typPaymentStatues.value == value;

    return GestureDetector(
      onTap: () {
        selectionController.typPaymentStatues.value = value;
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
                            CustomText2(
                              text: price,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF0F0B18),
                            ),
                            if (commission != null) ...[
                              const SizedBox(height: 4),
                              CustomText2(
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
