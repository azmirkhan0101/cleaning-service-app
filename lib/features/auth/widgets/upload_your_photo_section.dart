import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/profile_setup_controller.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadYourPhotoSection extends StatelessWidget {
  UploadYourPhotoSection({super.key});

  final selectionController = Get.find<ProfileSetupController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Heading and Subheading
        const CustomText2(
          text: AppStrings.uploadPhoto,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),

        const SizedBox(height: 12),

        CustomText2(
          text: AppStrings.profileTitle,
          fontSize: 12,
          color: AppColors.unselectedTextColor,
          fontWeight: FontWeight.w400,
          maxLines: 3,
          textAlign: TextAlign.start,
        ),

        const SizedBox(height: 104),

        Center(
          child: GestureDetector(
            onTap: () => selectionController.showImageSourceSelection(context),
            child: Obx(() {
              return Container(
                width: 140,
                height: 140,
                decoration: ShapeDecoration(
                  color: const Color(0xFFE9EBF3),
                  shape: OvalBorder(
                    side: BorderSide(width: 1, color: const Color(0xFF1B2D51)),
                  ),
                ),
                child: selectionController.profileImage.value != null
                    ? ClipOval(
                        child: Image.file(
                          selectionController.profileImage.value!,
                          fit: BoxFit.cover,
                          width: 140,
                          height: 140,
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.add,
                          size: 40,
                          color: Color(0xFF1B2D51),
                        ),
                      ),
              );
            }),
          ),
        ),

        // const SizedBox(height: 104),
        // Center(
        //   child: SizedBox(
        //     width:
        //         MediaQuery.of(context).size.width *
        //         0.5, // 50% of the screen width
        //     height:
        //         MediaQuery.of(context).size.width *
        //         0.5, // Maintain a square aspect ratio
        //     child: CustomImage(imageSrc: AppIcons.add_image),
        //   ),
        // ),
        const SizedBox(height: 40),

        CustomButton(
          onTap: () {
            if (selectionController.profileImage.value == null) {
              Toast.errorToast("Please upload a photo");
              return;
            }
            // Go to next step (Upload Documents) for both Owner and Provider
            selectionController.currentIndex.value = 3;

            debugPrint(
              'Photo uploaded: ${selectionController.profileImage.value}',
            );
          },
          title: "Confirm",
          fontSize: 16,
          width: double.infinity,
          height: 50,
          fillColor: AppColors.appColors,
          borderRadius: 24,
        ),

        const SizedBox(height: 16),

        // if role is owner show skip option
        if (selectionController.selectedRole.value == Role.owner)
          GestureDetector(
            onTap: () {
              // Go to next step (Upload Documents) for both Owner and Provider
              selectionController.currentIndex.value = 3;

              debugPrint('Skipped photo upload');
            },
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: CustomText2(
                  text: "Skip for now",
                  color: AppColors.appColors,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
