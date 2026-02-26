import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/profile_setup_controller.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:cleaning_service_app/features/location/screens/map_picker.dart';
import 'package:cleaning_service_app/features/location/widgets/location_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SetLocationSection extends StatefulWidget {
  const SetLocationSection({super.key});

  @override
  State<SetLocationSection> createState() => _SetLocationSectionState();
}

class _SetLocationSectionState extends State<SetLocationSection> {
  final selectionController = Get.find<ProfileSetupController>();

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
          onPressed: () async {
            // Navigate to the map picker and await the result (latitude, longitude, address)
            final result = await Get.to(() => PickerMapScreen());
            // print("Map Picker Result: $result");

            if (result != null && result is Map) {
              selectionController.address.value = result['address'] ?? '';
              selectionController.latitude.value =
                  result['latitude']?.toString() ?? '';
              selectionController.longitude.value =
                  result['longitude']?.toString() ?? '';
            }
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
                  max: 200.0,
                  divisions: 40,
                  label: '${selectionController.resultRange.value.round()} kilometer',
                  activeColor: AppColors.lightBlue,
                  onChanged: (double value) {
                    selectionController.resultRange.value = value;
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
                            "${selectionController.resultRange.value.round()} Kms",
                        fontWeight: FontWeight.w600,
                        color: AppColors.black_04,
                        fontSize: 14,
                      ),

                      const CustomText2(
                        text: "200 Kms",
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

        const SizedBox(height: 24),

        CustomButton(
          onTap: () {
            if (selectionController.address.value.isEmpty) {
              Toast.errorToast("Please select your location");
              return;
            }
            if (selectionController.experience.value.isEmpty &&
                selectionController.selectedRole.value == Role.provider) {
              Toast.errorToast("Please select your experience");
              return;
            }
            selectionController.currentIndex.value = 2;

            debugPrint(
              'Location: ${selectionController.address.value}, Experience: ${selectionController.experience.value}',
            );
          },
          title: AppStrings.continueText,
          fontSize: 16,
          width: double.infinity,
          height: 50,
          fillColor: AppColors.appColors,
          borderRadius: 24,
        ),

        const SizedBox(height: 16),

        // GestureDetector(
        //   onTap: () {
        //     selectionController.currentIndex.value = 2;
        //   },
        //   child: Center(
        //     child: CustomText(
        //       text: "Skip",
        //       color: const Color(0xFF98A1B2),
        //       fontSize: 14,
        //       fontFamily: 'Plus Jakarta Sans',
        //       fontWeight: FontWeight.w500,
        //       height: 1.50,
        //     ),
        //   ),
        // ),
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
    final options = ["0-1", "1-5", "+5"];

    return Column(
      spacing: 12.h,
      children: List.generate(options.length, (index) {
        return Obx(() {
          return GestureDetector(
            onTap: () => selectionController.setupExperience(options[index]),
            // onTap: () {

            //   selectionController.experience.value = options[index];
            // },
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF4899D1), width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: selectionController.experience.value == options[index]
                      ? Icon(Icons.check, size: 16, color: Color(0xFF43AF79))
                      : null,
                ),

                const SizedBox(width: 8),

                CustomText(
                  text: "${options[index]} years of experience",
                  color: const Color(0xFF0F0B18),
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ],
            ),
          );
        });
      }),
    );
  }
}
