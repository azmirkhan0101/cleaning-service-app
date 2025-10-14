import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:cleaning_service_app/features/location/widgets/location_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LocationController locationController = Get.put(LocationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "", leftIcon: true),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText2(
                text: "Set Your Location",
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),

              SizedBox(height: 8),

              CustomText2(
                text:
                    "Choose your location directly from the map to get the best service experience. This helps us connect you with nearby providers and ensures faster, more reliable service right at your doorstep.",
                fontWeight: FontWeight.w400,
                fontSize: 12,
                maxLines: 4,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 32),

              /// Searchable Address Field
              LocationSearchWidget(
                controller: locationController,
                hintText: "Search for your address...",
                showLabel: true,
                labelText: "Enter your address",
              ),

              SizedBox(height: 16),

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

                    CustomText2(
                      text: 'Use my current location',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText2(
                    text: "Show results within",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),

                  Slider(
                    value: 5.0, // Initial value
                    min: 5.0, // Minimum value
                    max: 100.0, // Maximum value
                    // divisions: 95,       // Number of discrete steps
                    activeColor: AppColors.lightBlue,
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

              SizedBox(height: 32),

              /// Continue Button
              CustomButton(
                onTap: () {},
                title: "Save",
                fontSize: 16, // Bigger button text for tablets
                width: double.infinity,
                height: 50,
                fillColor: AppColors.appColors,
                borderRadius: 24,
                // Wider button on tablets
              ),
            ],
          ),
        ),
      ),
    );
  }
}
