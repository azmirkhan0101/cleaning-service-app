import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/auth/selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SetRoleSection extends StatelessWidget {
  const SetRoleSection({
    super.key,
    required this.selectionController,
    required this.storage,
  });

  final SelectionController selectionController;
  final GetStorage storage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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

        const SizedBox(height: 16),

        Row(
          children: [
            Radio<bool>(
              value: false, // Value for "No"
              fillColor: WidgetStateColor.resolveWith(
                (states) => AppColors.lightBlue,
              ),
              groupValue: selectionController.typeModeStatues.value,
              onChanged: (bool? value) {
                selectionController.typeModeStatues.value = value!;

                storage.write("userType", "owner");
              },
            ),
            // Owner Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectionController.typeModeStatues.value == false
                        ? Color(0xFF1E88E5) // The blue border for selected
                        : Colors.white, // The white border for unselected
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey_3.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Owner',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'As an Owner, you can easily book trusted services in just a few taps. Browse available providers, compare options, and schedule at your convenience. The app ensures a seamless experience, from booking to payment, so you can get the service you need without any hassle',
                      style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20.0), // Spacing between cards

        Row(
          children: [
            Radio<bool>(
              value: true, // Value for "Yes"
              fillColor: WidgetStateColor.resolveWith(
                (states) => AppColors.primary,
              ),
              groupValue: selectionController.typeModeStatues.value,
              onChanged: (bool? value) {
                selectionController.typeModeStatues.value = value!;

                storage.write("userType", "provider");
              },
            ),

            /// Service Provider Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: selectionController.typeModeStatues.value
                        ? Color(0xFF1E88E5) // The blue border for selected
                        : Colors.white, // The white border for unselected
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey_3.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Service Provider',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'As a Service provider, you get a powerful platform to showcase your skills and connect with new clients. Manage your availability, accept bookings, and grow your business with ease. Our app gives you the tools to build trust, increase visibility, and succeed in your profession.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
