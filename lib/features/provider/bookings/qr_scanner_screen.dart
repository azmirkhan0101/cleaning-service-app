import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleName: "QR Code", leftIcon: true),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              showCustomDialog(context);
            },
            child: Center(
              child: CustomImage(
                imageSrc: AppImages.qr_code_image,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 24),

          Column(
            children: [
              Center(
                child: CustomImage(
                  imageSrc: AppImages.down_array,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 8),

              CustomText2(
                text: "Download",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(8),
          contentPadding: EdgeInsets.all(8),
          // Optional title if provided
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(imageSrc: AppImages.alertImage),

                  CustomText2(
                    text: "Booking Completed",
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),

                  SizedBox(height: 8),

                  CustomText2(
                    text: "You have successful made completed",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),

                  SizedBox(height: 12),

                  CustomButton(
                    onTap: () {
                      Get.offNamed(
                        AppRoutes.bookingsScreen,
                        arguments: [
                          {"status": "completed"},
                        ],
                      );

                      // Navigator.of(context).pop();
                    },
                    title: "Ok",
                    fontSize: 16, // Bigger button text for tablets
                    width: double.infinity,
                    height: 50,
                    fillColor: AppColors.appColors,
                    borderRadius: 24,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
