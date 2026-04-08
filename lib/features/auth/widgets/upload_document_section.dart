import 'dart:io';
import 'dart:ui';

import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/affiliation_controller.dart';
import 'package:cleaning_service_app/features/auth/controllers/profile_setup_controller.dart';
import 'package:cleaning_service_app/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

const Color primaryDarkBlue = Color(0xFF13224B);
const Color primaryYellow = Color(0xFFFFC000);
const Color cardBorderBlue = Color(0xFF1E88E5);
const Color unselectedTextColor = Color(0xFF6A6A6A);

class UploadDocumentSection extends StatelessWidget {
  UploadDocumentSection({super.key});

  final selectionController = Get.find<ProfileSetupController>();
  // final affiliationController = Get.put<AffiliationController>(
  //   AffiliationController(),
  // );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Verify Your Profile [title]
          const CustomText(
            text: AppStrings.verifyProfileText,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),

          const SizedBox(height: 12),

          /// Upload documentation ..... [description]
          const CustomText(
            text: AppStrings.uploadDocumentText,
            fontSize: 12,
            color: unselectedTextColor,
            fontWeight: FontWeight.w400,
            maxLines: 3,
            textAlign: TextAlign.start,
          ),

          const SizedBox(height: 24),

          /// Upload Front Side of ID
          _buildUploadDocument(
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

          SizedBox(height: 20.w),

          /// Upload Back Side of ID
          _buildUploadDocument(
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

          // SizedBox(height: 20.w),

          /// Upload Selfie with ID
          // if (selectionController.selectedRole.value == Role.provider)
          //   _buildUploadDocument(
          //     title: "Upload a Selfie with Your ID",
          //     description:
          //         "Take a selfie while holding your identity card next to your face. Ensure everything clearly visible.",
          //     onUpload: () {
          //       // Directly open camera for selfie
          //       selectionController.pickDocumentImage(
          //         image_picker.ImageSource.camera,
          //         (file) => selectionController.selfieWithIdImage.value = file,
          //       );
          //     },
          //     uploadedImage: selectionController.selfieWithIdImage.value,
          //     buttonLabel: 'Take Selfie',
          //   ),
          SizedBox(height: 150.w),

          /// Confirm Button
          CustomButton(
            onTap: () async {
              if (selectionController.isUploading.value) {
                return;
              }

              if (selectionController.frontIdImage.value == null) {
                Toast.errorToast("Please upload the front side of your ID");
                return;
              }

              if (selectionController.backIdImage.value == null) {
                Toast.errorToast("Please upload the back side of your ID");
                return;
              }

              final result = await selectionController
                  .completeRegistrationSetup();
              if (result) {
                // Close the dialog first
                //Navigator.of(context).pop();
                // Then navigate to login (this removes all previous routes)
                Get.offAll(() => LoginScreen());
                Toast.successToast(
                  "Registration completed successfully",
                );
              } else {
                // Check if error is session expired
                final errorMsg = selectionController.errorMessage.value
                    .toLowerCase();
                if (errorMsg.contains('session has expired') ||
                    errorMsg.contains(
                      'start registration from the first step',
                    )) {
                  // Close the dialog
                  Navigator.of(context).pop();
                  // Navigate to signup screen
                  Get.offAllNamed('/SignupScreen');
                  Toast.errorToast(
                    "Your session has expired. Please start registration again.",
                  );
                } else {
                  // Show error toast for other errors
                  Toast.errorToast(selectionController.errorMessage.value);
                }
              }

              // if (selectionController.selectedRole.value == Role.provider) {
              //   if (selectionController.selfieWithIdImage.value == null) {
              //     Toast.errorToast("Please upload a selfie with your ID");
              //     return;
              //   }
              // }
              // fetch affiliation condition text
              // await affiliationController.fetchAffiliationProgram();
              // if (!context.mounted) return;
              // // Show affiliation condition dialog for Provider
              // _showAffiliationConditionDialog(context);
              debugPrint(
                'Front side of id: ${selectionController.frontIdImage.value}',
              );
              debugPrint(
                'Back side of id: ${selectionController.backIdImage.value}',
              );
              debugPrint(
                'Selfie with ID uploaded: ${selectionController.selfieWithIdImage.value}',
              );
            },
            title: selectionController.isUploading.value
                ? 'Processing...'
                : 'Confirm',
            fontSize: 16,
            width: double.infinity,
            height: 50,
            fillColor: selectionController.isUploading.value
                ? AppColors.grey_1
                : AppColors.appColors,
            borderRadius: 24,
          ),

          SizedBox(height: 20),
        ],
      );
    });
  }

  // void _showAffiliationConditionDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierColor: Colors.white.withValues(alpha: 0.5), // Blur effect
  //     barrierDismissible: true,
  //     builder: (context) {
  //       return BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //         child: Dialog(
  //           elevation: 0,
  //           backgroundColor: Colors.transparent,
  //           insetPadding: EdgeInsets.symmetric(horizontal: 24),
  //           child: _showAffiliateDialog(context),
  //         ),
  //       );
  //     },
  //   );
  // }

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

  // Widget _showAffiliateDialog(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border.all(width: 2, color: const Color(0xFF1B2D51)),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           SizedBox(height: 16),
  //           // Title
  //           Text(
  //             'Affiliation Condition',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               color: const Color(0xFF0F0B18),
  //               fontSize: 24,
  //               fontFamily: 'Lexend',
  //               fontWeight: FontWeight.w700,
  //               height: 1.3,
  //             ),
  //           ),
  //           SizedBox(height: 24),
  //           // Content
  //           Obx(() {
  //             if (affiliationController.isLoading.value) {
  //               return CircularProgressIndicator();
  //             }
  //             return HtmlWidget(
  //               affiliationController.affiliationContent.value,
  //               textStyle: TextStyle(
  //                 color: const Color(0xFF0F0B18),
  //                 fontSize: 14,
  //                 fontFamily: 'Lexend',
  //                 fontWeight: FontWeight.w400,
  //                 height: 1.5,
  //               ),
  //             );
  //           }),
  //           SizedBox(height: 32),
  //           Obx(() {
  //             return GestureDetector(
  //               onTap: () async {
  //                 // If role is Provider, go to next step
  //                 // if (selectionController.selectedRole.value != Role.owner) {
  //                 //   Navigator.pop(context);
  //                 //   selectionController.currentIndex.value++;
  //                 // } else {
  //                 // else complete registration
  //                 // Upload all documents for Owner
  //                 final result = await selectionController
  //                     .completeRegistrationSetup();
  //                 if (result) {
  //                   // Close the dialog first
  //                   Navigator.of(context).pop();
  //                   // Then navigate to login (this removes all previous routes)
  //                   Get.offAll(() => LoginScreen());
  //                   Toast.successToast(
  //                     "Registration completed successfully",
  //                   );
  //                 } else {
  //                   // Check if error is session expired
  //                   final errorMsg = selectionController.errorMessage.value
  //                       .toLowerCase();
  //                   if (errorMsg.contains('session has expired') ||
  //                       errorMsg.contains(
  //                         'start registration from the first step',
  //                       )) {
  //                     // Close the dialog
  //                     Navigator.of(context).pop();
  //                     // Navigate to signup screen
  //                     Get.offAllNamed('/SignupScreen');
  //                     Toast.errorToast(
  //                       "Your session has expired. Please start registration again.",
  //                     );
  //                   } else {
  //                     // Show error toast for other errors
  //                     Toast.errorToast(selectionController.errorMessage.value);
  //                   }
  //                 }
  //                 // }
  //               },
  //               child: Container(
  //                 width: double.infinity,
  //                 padding: const EdgeInsets.symmetric(vertical: 16),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFF7A51D),
  //                   borderRadius: BorderRadius.circular(50),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   spacing: 16,
  //                   children: [
  //                     if (selectionController.isUploading.value)
  //                       SizedBox(
  //                         width: 24,
  //                         height: 24,
  //                         child: CircularProgressIndicator(),
  //                       ),
  //                     Text(
  //                       selectionController.isUploading.value
  //                           ? 'proceeding...'
  //                           : 'Accept',
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 16,
  //                         fontFamily: 'Lexend',
  //                         fontWeight: FontWeight.w600,
  //                         height: 1.5,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }),
  //
  //           SizedBox(height: 16),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
