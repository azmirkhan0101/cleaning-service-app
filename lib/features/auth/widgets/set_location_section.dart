import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/selection_controller.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:cleaning_service_app/features/location/map_picker.dart';
import 'package:cleaning_service_app/features/location/widgets/location_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetLocationSection extends StatefulWidget {
  const SetLocationSection({super.key});

  @override
  State<SetLocationSection> createState() => _SetLocationSectionState();
}

class _SetLocationSectionState extends State<SetLocationSection> {
  final selectionController = Get.find<SelectionController>();

  int? _selectedExperience;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppStrings.setLocation,
          color: const Color(0xFF0F0B18),
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          height: 1.40,
          letterSpacing: -0.50,
        ),

        const SizedBox(height: 12),

        const CustomText(
          text:
              "Choose your location directly from the map to get the best service experience. This helps us connect you with nearby providers and ensures faster, more reliable service right at your doorstep.",
          color: Color(0xFF4F4F59),
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),

        const SizedBox(height: 24),

        LocationSearchWidget(
          // controller: Get.find<LocationController>(),
          onResultSelected: (result) {
            selectionController.address.value = result['address'] ?? '';
            selectionController.latitude.value =
                result['latitude']?.toString() ?? '';
            selectionController.longitude.value =
                result['longitude']?.toString() ?? '';
          },
        ),
        SizedBox(height: 16),

        ///============ Location ============
        ElevatedButton(
          onPressed: () {
            // Get.toNamed(AppRoutes.pickerMapScreen);
            Get.to(() => PickerMapScreen());
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

        // Range Slider Section
        if (selectionController.selectedRole.value == Role.owner)
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Range Slider Text
                const CustomText(
                  text: "Show results within",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                // Range Slider
                Slider(
                  value: selectionController.resultRange.value,
                  min: 5.0,
                  max: 100.0,
                  divisions: 19,
                  label:
                      '${selectionController.resultRange.value.round()} miles',
                  activeColor: AppColors.lightBlue,
                  onChanged: (double value) {
                    selectionController.resultRange.value = value;
                    print("Selected distance: ${value.round()} miles");
                  },
                ),
                // Range Slider Values
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText2(
                        text:
                            "${selectionController.resultRange.value.round()} miles",
                        fontWeight: FontWeight.w600,
                        color: AppColors.black_04,
                        fontSize: 14,
                      ),

                      const CustomText2(
                        text: "100 Miles",
                        fontWeight: FontWeight.w600,
                        color: AppColors.black_04,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

        // Professional's Experience Section
        if (selectionController.selectedRole.value == Role.provider)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Professional's experience"),
              const SizedBox(height: 16),
              _buildExperienceOptions(),
              const SizedBox(height: 16),
            ],
          ),

        SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildExperienceOptions() {
    final options = [
      "0-2 years of experience",
      "2-5 years of experience",
      "6-10 years of experience",
      "11-20 years of experience",
      "+20 years of experience",
    ];

    return Column(
      children: List.generate(options.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Checkbox(
                value: _selectedExperience == index,
                onChanged: (bool? value) {
                  setState(() {
                    _selectedExperience = value == true ? index : null;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              const SizedBox(width: 8),

              CustomText2(
                text: options[index],
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        );
      }),
    );
  }
}
