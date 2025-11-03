import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/profile_setup_controller.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SetRoleSection extends StatelessWidget {
  const SetRoleSection({super.key, required this.selectionController});

  final ProfileSetupController selectionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Heading and Subheading
        const CustomText(
          text: 'How will you use our app?',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),

        const SizedBox(height: 12),

        CustomText(
          text:
              'Our app makes everyday tasks easier and faster, giving you the tools you need right at your fingertips.',
          fontSize: 12,
          color: AppColors.unselectedTextColor,
          fontWeight: FontWeight.w400,
          maxLines: 3,
          textAlign: TextAlign.start,
        ),

        SizedBox(height: 50.h),

        Obx(
          () => _buildSelectableRole(
            title: 'Owner',
            description:
                'As a Owner, you can easily book trusted services in just a few taps. Browse available providers, compare options, and schedule at your convenience. The app ensures a seamless experience, from booking to payment, so you can get the service you need without any hassle',
            isSelected: selectionController.selectedRole.value == Role.owner,
          ),
        ),
        SizedBox(height: 20.h),
        Obx(
          () => _buildSelectableRole(
            title: 'Service Provider',
            description:
                'As a Service provider, you get a powerful platform to showcase your skills and connect with new clients. Manage your availability, accept bookings, and grow your business with ease. Our app gives you the tools to build trust, increase visibility, and succeed in your profession.',
            isSelected: selectionController.selectedRole.value == Role.provider,
          ),
        ),
        SizedBox(height: 100.h),

        // Continue Button
        CustomButton(
          onTap: () {
            selectionController.currentIndex.value = 1;
          },
          title: AppStrings.continuetext,
          fontSize: 16,
          width: double.infinity,
          height: 50,
          fillColor: AppColors.appColors,
          borderRadius: 24,
        ),
      ],
    );
  }

  Widget _buildSelectableRole({
    required String title,
    required String description,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (title == "Owner") {
          selectionController.changeType(Role.owner);
        } else {
          selectionController.changeType(Role.provider);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12.w,
        children: [
          isSelected
              ? Assets.icons.checkCircleBlue.svg(width: 20.w, height: 20.h)
              : Assets.icons.circle.svg(width: 20.w, height: 20.h),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EBF3),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: isSelected ? 1.60 : 0.3,
                    color: isSelected
                        ? const Color(0xFF4899D1)
                        : Color(0xFF4F4F59),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF0F0B18),
                      fontSize: 16.sp,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  CustomText(
                    text: description,
                    color: const Color(0xFF4F4F59),
                    fontSize: 10.sp,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    maxLines: 5,
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
