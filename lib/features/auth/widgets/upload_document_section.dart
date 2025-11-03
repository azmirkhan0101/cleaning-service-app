import 'dart:io';
import 'dart:ui';

import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/profile_setup_controller.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const Color primaryDarkBlue = Color(0xFF13224B);
const Color primaryYellow = Color(0xFFFFC000);
const Color cardBorderBlue = Color(0xFF1E88E5);
const Color unselectedTextColor = Color(0xFF6A6A6A);

class UploadDocumentSection extends StatelessWidget {
  UploadDocumentSection({super.key});

  final selectionController = Get.find<ProfileSetupController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Heading and Subheading
        const CustomText2(
          text: AppStrings.VerifyProfile,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),

        const SizedBox(height: 12),

        const CustomText2(
          text: AppStrings.VerifyProfileTitle,
          fontSize: 12,
          color: unselectedTextColor,
          fontWeight: FontWeight.w400,
          maxLines: 3,
          textAlign: TextAlign.start,
        ),

        const SizedBox(height: 24),

        // Upload Front Side of ID
        Obx(
          () => _buildUploadDocument(
            title: "Upload the Front Side of Your ID",
            description:
                "Take a clear photo or upload the front side of your identity card. Make sure all details are visible.",
            onUpload: () {
              selectionController.showDocumentSourceSelection(
                context,
                'Front Side of ID',
                (file) => selectionController.frontIdImage.value = file,
              );
            },
            uploadedImage: selectionController.frontIdImage.value,
            buttonLabel: 'Upload Front Side',
          ),
        ),

        SizedBox(height: 20.w),

        // Upload Back Side of ID
        Obx(
          () => _buildUploadDocument(
            title: "Upload the Back Side of Your ID",
            description:
                "Now, upload a clear photo of the back side of your identity card.",
            onUpload: () {
              selectionController.showDocumentSourceSelection(
                context,
                'Back Side of ID',
                (file) => selectionController.backIdImage.value = file,
              );
            },
            uploadedImage: selectionController.backIdImage.value,
            buttonLabel: 'Upload Back Side',
          ),
        ),

        SizedBox(height: 20.w),

        // Upload Selfie with ID
        if (selectionController.selectedRole.value == Role.provider)
          Obx(
            () => _buildUploadDocument(
              title: "Upload a Selfie with Your ID",
              description:
                  "Take a selfie while holding your identity card next to your face. Ensure everything clearly visible.",
              onUpload: () {
                selectionController.showDocumentSourceSelection(
                  context,
                  'Selfie with ID',
                  (file) => selectionController.selfieWithIdImage.value = file,
                );
              },
              uploadedImage: selectionController.selfieWithIdImage.value,
              buttonLabel: 'Upload Selfie',
            ),
          ),

        SizedBox(height: 56.w),

        Obx(
          () => CustomButton(
            onTap: selectionController.isLoading.value
                ? () {} // Disabled state - do nothing
                : () {
                    _showAffiliationConditionDialog(context);
                  },
            title: selectionController.isLoading.value
                ? 'Processing...'
                : AppStrings.continuetext,
            fontSize: 16,
            width: double.infinity,
            height: 50,
            fillColor: selectionController.isLoading.value
                ? AppColors.grey_1
                : AppColors.appColors,
            borderRadius: 24,
          ),
        ),
      ],
    );
  }

  void _showAffiliationConditionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Blur effect
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 24),
            child: _showAffiliateDialog(context),
          ),
        );
      },
    );
  }

  Widget _showAffiliateDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: const Color(0xFF1B2D51)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),

          // Title
          Text(
            'Affiliation Condition',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF0F0B18),
              fontSize: 24,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),

          SizedBox(height: 24),

          // Content
          Text(
            "By using the app, you agree to create an account and keep your login information secure. Users can book appointments, and service providers manage availability and appointments. Payments are handled between users and providers. Follow the provider's cancellation and refund policy. You must use the app responsibly, and we are not liable for any issues. The terms may change, and by continuing to use the app, you agree to any updates. For questions, contact us at [Contact Email]",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF0F0B18),
              fontSize: 14,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),

          SizedBox(height: 32),

          // Accept Button - Call API for Owner
          Obx(
            () => GestureDetector(
              onTap: selectionController.isLoading.value
                  ? null
                  : () {
                      Navigator.pop(context);
                      // Call API to complete registration for Owner
                      selectionController.completeRegistration().then((
                        success,
                      ) {
                        if (success) {
                          Get.offNamed(AppRoutes.paymentScreen);
                        }
                      });
                    },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: selectionController.isLoading.value
                      ? const Color(0xFFCCCCCC)
                      : const Color(0xFFF7A51D),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  selectionController.isLoading.value
                      ? 'Processing...'
                      : 'Accept',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildUploadDocument({
    required String title,
    required String description,
    required VoidCallback onUpload,
    File? uploadedImage,
    required String buttonLabel,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF4899D1), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            color: const Color(0xFF0F0B18),
            fontSize: 14,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w600,
            height: 1.50,
          ),

          SizedBox(height: 4),

          CustomText(
            text: description,
            color: const Color(0xFF4F4F59),
            fontSize: 12,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),

          SizedBox(height: 16),

          // Show uploaded image preview if available
          if (uploadedImage != null) ...[
            Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF4899D1)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(uploadedImage, fit: BoxFit.cover),
              ),
            ),
          ],

          ElevatedButton.icon(
            onPressed: onUpload,
            icon: Icon(
              uploadedImage != null ? Icons.check_circle : Icons.add,
              color: Color(0xFF4899D1),
            ),
            label: CustomText(
              text: uploadedImage != null ? 'Change Photo' : buttonLabel,
              color: const Color(0xFF4899D1),
              fontSize: 14,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: uploadedImage != null
                  ? Color(0xFFE3F2FD)
                  : Colors.white,
              side: BorderSide(color: Color(0xFF4899D1)),
              fixedSize: Size(double.maxFinite, double.infinity),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
