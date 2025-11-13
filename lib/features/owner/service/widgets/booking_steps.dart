import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingSteps extends StatelessWidget {
  const BookingSteps({super.key, required this.currentStep});
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16.w,
      children: [
        _buildCircularStep(label: "Step 1", isCompleted: currentStep >= 1),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.w,
              children: List.generate(
                12,
                (index) => Container(
                  width: 8,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Color(0xFF4899D1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Text(" "),
          ],
        ),

        _buildCircularStep(label: "Step 2", isCompleted: currentStep >= 2),
      ],
    );
  }

  Widget _buildCircularStep({
    required String label,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(11),
          decoration: ShapeDecoration(
            color: isCompleted ? const Color(0xFF4899D1) : Color(0xFFDDE1ED),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: isCompleted
              ? Assets.icons.checkCircle.svg()
              : Assets.icons.circle.svg(),
        ),
        // StepCircle(isActive: true, isCompleted: true),
        CustomText(
          text: label,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: FontFamily.lexend,
          color: isCompleted ? AppColors.black : const Color(0xFFB9C2DB),
        ),
      ],
    );
  }
}
