import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/core/utils/context_extension/context_extension.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:cleaning_service_app/features/common/widgets/phone_input_field.dart';
import 'package:cleaning_service_app/features/profile/controllers/edit_profile_controller.dart';
import 'package:cleaning_service_app/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.isOwner});

  final bool isOwner;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final editProfileController = Get.put(EditProfileController());
  final profileController = Get.find<ProfileController>();

  final role = AppStorageService.getUserRole();

  @override
  void initState() {
    super.initState();

    final profile = profileController.profile.value;

    // Initialize common fields
    editProfileController.nameController.text = profile?.userName ?? '';
    editProfileController.phoneController.text = profile?.phoneNumber ?? '';
    editProfileController.addressController.text = profile?.address ?? '';
    editProfileController.aboutMeController.text = profile?.aboutMe ?? '';
    editProfileController.selectedExperience.value = profile?.experience ?? '';
    editProfileController.setSelectedAddress(
      address: profile?.address ?? '',
      latitude: profile?.latitude ?? 0.0,
      longitude: profile?.longitude ?? 0.0,
    );
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
                editProfileController.pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.appColors),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                editProfileController.pickImageFromCamera();
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

    bool isTab = context.isTab;

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
                      final selectedImage =
                          editProfileController.profileImage.value;
                      final profilePictureUrl =
                          profileController.profile.value?.profilePicture ?? '';

                      // Helper function to check if URL is valid
                      bool isValidUrl(String url) {
                        if (url.isEmpty) return false;
                        return Uri.tryParse(url)?.hasAbsolutePath ?? false;
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                              border: Border.all(
                                width: 1,
                                color: AppColors.white_50,
                              ),
                            ),
                            child: ClipOval(
                              child: selectedImage != null
                                  // Show selected image from gallery/camera
                                  ? Image.file(selectedImage, fit: BoxFit.cover)
                                  : isValidUrl(profilePictureUrl)
                                  // Show network image if valid URL
                                  ? Image.network(
                                      profilePictureUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        // Show icon if network image fails to load
                                        return Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Colors.grey.shade400,
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                    )
                                  // Show icon placeholder if no valid image
                                  : Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey.shade400,
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
                    controller: editProfileController.nameController,
                  ),

                  SizedBox(height: 12.h),

                  ///============ Phone Number ============
                  CustomText(
                    text: 'Phone Number',
                    color: const Color(0xFF0F0B18),
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                  const SizedBox(height: 4),
                  PhoneInputField(
                    initialE164: editProfileController.phoneController.text,
                    onChanged: (e164) {
                      editProfileController.phoneController.text = e164;
                    },
                  ),

                  SizedBox(height: 12.h),

                  ///============ address ============
                  /// Service name Field
                  CustomFormCard(
                    title: "Enter your Address",
                    hintText: "Enter your Address",
                    prefixIcon: Icon(Icons.location_pin),
                    hasBackgroundColor: true,
                    controller: editProfileController.addressController,
                    readOnly: true,
                    onTap: () async {
                      final result = await Get.toNamed(
                        AppRoutes.pickerMapScreen,
                      );
                      if (result is Map) {
                        final address = result['address']?.toString() ?? '';
                        final lat =
                            (result['latitude'] as num?)?.toDouble() ?? 0.0;
                        final lng =
                            (result['longitude'] as num?)?.toDouble() ?? 0.0;
                        editProfileController.setSelectedAddress(
                          address: address,
                          latitude: lat,
                          longitude: lng,
                        );
                      }
                    },
                  ),

                  // CustomFormCard(
                  //   title: "Enter your address",
                  //   hintText: "Enter address",
                  //   hasBackgroundColor: true,
                  //   fontSize: isTablet ? 16 : 16,
                  //   controller: editProfileController.addressController,
                  // ),
                  SizedBox(height: 12.h),

                  ///============ About me (Only for Provider)============
                  // if (role == Role.provider.value)
                  CustomFormCard(
                    title: "About me",
                    hintText: "About me",
                    hasBackgroundColor: true,
                    fontSize: isTablet ? 16 : 16,
                    maxLine: 3,
                    controller: editProfileController.aboutMeController,
                  ),
                  SizedBox(height: 12.h),

                  // Select Experience (Only for Provider)
                  if (!widget.isOwner)
                    CustomText(
                      text: "Experience",
                      color: const Color(0xFF0F0B18),
                      fontSize: 16,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),

                  ...List.generate(
                    role != Role.provider.value
                        ? 0
                        : editProfileController.experienceLevels.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          editProfileController.selectedExperience.value =
                              editProfileController.experienceLevels[index];
                        },
                        child: _buildExperienceRow(
                          editProfileController,
                          editProfileController.experienceLevels[index],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),
                  Obx(() {
                    final isUpdating = editProfileController.isUpdating.value;
                    return CustomButton(
                      onTap: () async {
                        if (!isUpdating) {
                          final success = await editProfileController
                              .updateProfile();
                          if (success) {
                            // Refresh profile data
                            await profileController.fetchProfile();
                            Get.back();
                          }
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

  Widget _buildExperienceRow(
    EditProfileController controller,
    String experience,
  ) {
    return InkWell(
      onTap: () {
        controller.selectedExperience.value = experience;
      },
      child: Obx(() {
        final bool isSelected =
            controller.selectedExperience.value == experience;
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.w,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFF4899D1)),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Color(0xFF4899D1),
                      ),
                    )
                  : null,
            ),

            CustomText(
              text: "$experience years of experience",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF0F0B18),
            ),
          ],
        );
      }),
    );
  }
}
