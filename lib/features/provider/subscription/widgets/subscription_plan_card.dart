import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/features/provider/subscription/controller/subscription_controller.dart';
import 'package:cleaning_service_app/features/provider/subscription/models/subscription_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/context_extension/context_extension.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.isYearly,
    this.isCheckIconVisible = true,
  });

  final SubscriptionPlanModel plan;
  final bool isSelected;
  final bool isYearly;
  final bool isCheckIconVisible;

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    final controller = Get.find<SubscriptionController>();
    return GestureDetector(
      onTap: () {
        controller.selectPlan(plan);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Check circle icon
          if (isCheckIconVisible)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: isSelected
                  ? Assets.icons.checkCircleBlue.svg(width: 20.w, height: 20.h)
                  : Assets.icons.circle.svg(width: 20.w, height: 20.h),
            ),

          if (isCheckIconVisible) SizedBox(width: 12.w),

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
                            if (isYearly && plan.price > 0) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomText(
                                    text: controller
                                        .calculateYearlyPrice(plan.price)
                                        .toString(),
                                    fontSize: isTab ? 12 : 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white70
                                        : const Color(0xFF4F4F59),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  const SizedBox(width: 6),
                                  CustomText(
                                    text:
                                        "${controller.calculateDiscountedYearlyPrice(plan.price).toString()} /year",
                                    fontSize: isTab ? 14 : 18,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF0F0B18),
                                  ),
                                ],
                              ),
                            ] else ...[
                              CustomText(
                                text: "€${plan.price.toString()} /month",
                                fontSize: isTab ? 12 : 18,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF0F0B18),
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
                          text: plan.plan,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4899D1),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  // SizedBox(height: commission != null ? 16 : 4),

                  // Features
                  ...plan.features.map(
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
