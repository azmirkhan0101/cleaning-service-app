import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/screens/selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetLocationSection extends StatelessWidget {
  const SetLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppStrings.setLocation,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.40,
          letterSpacing: -0.50,
        ),

        const SizedBox(height: 12),

        const CustomText(
          text: AppStrings.locationTitle,
          fontSize: 12,
          color: unselectedTextColor,
          fontWeight: FontWeight.w400,
          maxLines: 3,
          textAlign: TextAlign.start,
        ),

        const SizedBox(height: 24),

        /// address Field
        CustomFormCard(
          title: "Enter your address",
          hintText: "your address",
          hasBackgroundColor: true,
          controller: TextEditingController(),
        ),

        SizedBox(height: 16),

        ///============ Location ============
        ElevatedButton(
          onPressed: () {
            Get.toNamed(AppRoutes.pickerMapScreen);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.white_50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50), // pill shape
              side: const BorderSide(
                color: Colors.lightBlue,
                width: 1,
              ), // border
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            elevation: 0, // flat style, remove shadow

            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.9,
              50,
            ), // 90% of screen width
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(imageSrc: AppIcons.send_icon),

              SizedBox(width: 8),

              CustomText(
                text: 'Use my current location',
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        //if(selectionController.typeModeStatues.value==false)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Show results within",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),

            Slider(
              value: 5.0, // Initial value
              min: 5.0, // Minimum value
              max: 100.0,
              activeColor: AppColors.lightBlue, // Maximum value
              // divisions: 95,       // Number of discrete steps
              onChanged: (double value) {
                // Handle the slider value change
                print("Selected distance: $value miles");
              },
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText2(
                    text: "5 miles",
                    fontWeight: FontWeight.w600,
                    color: AppColors.black_04,
                    fontSize: 14,
                  ),

                  CustomText2(
                    text: "100 Miles",
                    fontWeight: FontWeight.w600,
                    color: AppColors.black_04,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
