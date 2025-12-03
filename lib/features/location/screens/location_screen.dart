import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:cleaning_service_app/features/location/screens/map_picker.dart';
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
  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    final profile = profileController.profile.value;
    if (profile != null) {
      final address = profile.address;
      final lat = profile.latitude;
      final lng = profile.longitude;
      if (address.isNotEmpty && (lat != 0.0 || lng != 0.0)) {
        locationController.updateLocation(address, lat, lng);
      }
    }
  }

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
              // Scrollable content area to prevent overflow when suggestions show
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
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
                        onResultSelected: (_) {
                          // Ensure controller values are committed if parent relies on callback
                          locationController.updateLocation(
                            locationController.selectedAddress.text,
                            locationController.selectedLatitude.value,
                            locationController.selectedLongitude.value,
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
                            borderRadius: BorderRadius.circular(
                              50,
                            ), // pill shape
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
                    ],
                  ),
                ),
              ),

              Obx(() {
                return CustomButton(
                  onTap: _onTapSaveLocation,
                  title: profileController.isUpdating.value
                      ? 'Updating...'
                      : 'Save',
                  fontSize: 16,
                  width: double.infinity,
                  height: 50,
                  fillColor: profileController.isUpdating.value
                      ? AppColors.grey_1
                      : AppColors.appColors,
                  borderRadius: 24,
                );
              }),

              SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapSaveLocation() async {
    if (profileController.isUpdating.value) {
      return;
    }

    if (locationController.selectedAddress.text.isEmpty) {
      Toast.errorToast("Please select your location");
      return;
    }

    // Call update location API
    final success = await profileController.updateLocation(
      address: locationController.selectedAddress.text,
      latitude: locationController.selectedLatitude.value,
      longitude: locationController.selectedLongitude.value,
    );

    if (success) {
      Get.back(); // Close location screen
      // Refetch profile to get updated data
      await profileController.fetchProfile();

      Toast.successToast("Location updated successfully");

      // Go back to previous screen
      Get.back();
    } else {
      profileController.errorMessage.value.isNotEmpty
          ? Toast.errorToast(profileController.errorMessage.value)
          : Toast.errorToast("Failed to update location");
    }
  }
}
