import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:cleaning_service_app/features/location/map_picker.dart';
import 'package:cleaning_service_app/features/location/widgets/location_search_widget.dart';
import 'package:cleaning_service_app/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                onResultSelected: (result) {
                  locationController.updateLocation(
                    result['address'] ?? '',
                    result['latitude'] ?? 0.0,
                    result['longitude'] ?? 0.0,
                  );
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
                    locationController.updateLocation(
                      result['address'] ?? '',
                      result['latitude'] ?? 0.0,
                      result['longitude'] ?? 0.0,
                    );
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
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
              // if (selectionController.selectedRole.value == Role.owner)
              //   Obx(() {
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         // Range Slider Text
              //         const CustomText(
              //           text: "Show results within",
              //           fontSize: 14,
              //           fontWeight: FontWeight.w600,
              //           color: Colors.black,
              //         ),
              //         // Range Slider
              //         Slider(
              //           value: selectionController.resultRange.value,
              //           min: 5.0,
              //           max: 100.0,
              //           divisions: 19,
              //           label:
              //               '${selectionController.resultRange.value.round()} miles',
              //           activeColor: AppColors.lightBlue,
              //           onChanged: (double value) {
              //             selectionController.resultRange.value = value;
              //             print("Selected distance: ${value.round()} miles");
              //           },
              //         ),
              //         // Range Slider Values
              //         Padding(
              //           padding: const EdgeInsets.only(left: 16, right: 16),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               CustomText2(
              //                 text:
              //                     "${selectionController.resultRange.value.round()} miles",
              //                 fontWeight: FontWeight.w600,
              //                 color: AppColors.black_04,
              //                 fontSize: 14,
              //               ),

              //               const CustomText2(
              //                 text: "100 Miles",
              //                 fontWeight: FontWeight.w600,
              //                 color: AppColors.black_04,
              //                 fontSize: 14,
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     );
              //   }),

              // Professional's Experience Section
              // if (selectionController.selectedRole.value == Role.provider)
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       _buildSectionHeader("Professional's experience"),
              //       const SizedBox(height: 16),
              //       _buildExperienceOptions(),
              //       const SizedBox(height: 16),
              //     ],
              //   ),

              // const SizedBox(height: 24),
              Spacer(),

              CustomButton(
                onTap: () async {
                  if (locationController.selectedAddress.text.isEmpty) {
                    Toast.errorToast("Please select your location");
                    return;
                  }

                  // Check if ProfileController is registered (editing existing profile)
                  if (Get.isRegistered<ProfileController>()) {
                    final profileController = Get.find<ProfileController>();

                    // Call update location API
                    final success = await profileController.updateLocation(
                      address: locationController.selectedAddress.text,
                      latitude: locationController.selectedLatitude.value,
                      longitude: locationController.selectedLongitude.value,
                    );

                    if (success) {
                      // Refetch profile to get updated data
                      await profileController.fetchProfile();

                      Toast.successToast("Location updated successfully");

                      // Go back to previous screen
                      Get.back();
                    }
                  } else {
                    // If not in profile edit mode, just go back
                    Toast.errorToast("Profile controller not found");
                  }
                },
                title: AppStrings.continueText,
                fontSize: 16,
                width: double.infinity,
                height: 50,
                fillColor: AppColors.appColors,
                borderRadius: 24,
              ),

              // const SizedBox(height: 16),

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
              SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
