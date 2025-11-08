import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OwnerEditProfileScreen extends StatefulWidget {
  const OwnerEditProfileScreen({super.key});

  @override
  State<OwnerEditProfileScreen> createState() => _OwnerEditProfileScreenState();
}

class _OwnerEditProfileScreenState extends State<OwnerEditProfileScreen> {
  final ProfileController profileController = Get.find<ProfileController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with profile data
    final profile = profileController.profile.value;
    if (profile != null) {
      nameController.text = profile.userName;
      phoneController.text = profile.phoneNumber;
      addressController.text = ''; // Address not in current profile model
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    // Validate inputs
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your phone number',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (addressController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Call update profile
    final success = await profileController.updateProfile(
      userName: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      address: addressController.text.trim(),
      profilePicture: profileController.profileImage.value,
    );

    if (success) {
      Get.back();
    }
  }

  void _showImageSourceSelection() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.appColors,
              ),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                profileController.pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.appColors),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                profileController.pickImageFromCamera();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Scaffold(
          appBar: const CustomAppBar(title: "Edit Profile", backButton: true),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 16,
                bottom: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///====================== profile image===================
                  Center(
                    child: Obx(() {
                      final profile = profileController.profile.value;
                      final selectedImage =
                          profileController.profileImage.value;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 130.h,
                            width: 130.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(
                                width: 1,
                                color: AppColors.white_50,
                              ),
                            ),
                            child: selectedImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      selectedImage,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : profile?.profilePicture.isNotEmpty == true
                                ? ClipOval(
                                    child: Image.network(
                                      profile!.profilePicture,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              AppImages.user_image,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.asset(
                                      AppImages.user_image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: isTablet ? -80 : -70,
                            left: 0,
                            child: GestureDetector(
                              onTap: _showImageSourceSelection,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),

                  /// =====Profile Name List =========
                  SizedBox(height: 12.h),

                  ///============ First Name ============
                  CustomFormCard(
                    title: AppStrings.yourFirstName,
                    hintText: AppStrings.enterYourName,
                    fontSize: isTablet ? 16 : 16,
                    hasBackgroundColor: true,
                    controller: nameController,
                  ),

                  SizedBox(height: 12.h),

                  ///============ Phone Number ============
                  CustomFormCard(
                    title: 'Phone Number',
                    hintText: "Enter Phone Number",
                    fontSize: isTablet ? 16 : 16,
                    hasBackgroundColor: true,
                    controller: phoneController,
                  ),

                  SizedBox(height: 12.h),

                  ///============ address ============
                  CustomFormCard(
                    title: "Enter your address",
                    hintText: "Enter address",
                    hasBackgroundColor: true,
                    fontSize: isTablet ? 16 : 16,
                    controller: addressController,
                  ),

                  // SizedBox(height: 12.h),

                  // ///============ Experience ============
                  // CustomFormCard(
                  //   title: "Experience",
                  //   hintText: "Enter Experience",
                  //   hasBackgroundColor: true,
                  //   fontSize: isTablet ? 16 : 16,
                  //   controller: TextEditingController(),
                  // ),
                  // SizedBox(height: 12.h),

                  // ///============ About me ============
                  // CustomFormCard(
                  //   title: "About me",
                  //   hintText: "About me",
                  //   hasBackgroundColor: true,
                  //   fontSize: isTablet ? 16 : 16,
                  //   maxLine: 3,
                  //   controller: TextEditingController(),
                  // ),
                  SizedBox(height: 16.h),
                  Obx(() {
                    final isUpdating = profileController.isUpdating.value;
                    return CustomButton(
                      onTap: () {
                        if (!isUpdating) {
                          _handleUpdate();
                        }
                      },
                      title: isUpdating ? "UPDATING..." : "SAVE",
                      height: isTablet ? 70 : 60,
                      fontSize: isTablet ? 16 : 14,
                      fillColor: isUpdating
                          ? AppColors.grey_2
                          : AppColors.appColors,
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
