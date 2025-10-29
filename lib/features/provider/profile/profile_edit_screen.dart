import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditPersonProfileScreen extends StatefulWidget {
  const EditPersonProfileScreen({super.key});

  @override
  State<EditPersonProfileScreen> createState() =>
      _EditPersonProfileScreenState();
}

class _EditPersonProfileScreenState extends State<EditPersonProfileScreen> {
  bool valuefirst = false;

  String checkValueStatues = "";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Scaffold(
          appBar: const CustomAppBar(titleName: "Edit Profile", leftIcon: true),
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
                    child: Stack(
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
                            image: DecorationImage(
                              image: AssetImage(AppImages.user_image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: isTablet ? -80 : -70,
                          left: 0,
                          child: GestureDetector(
                            onTap: () {
                              //  authController.chooseUserPhoto();
                            },
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
                    ),
                  ),

                  /// =====Profile Name List =========
                  SizedBox(height: 12.h),

                  ///============ First Name ============
                  CustomFormCard(
                    title: AppStrings.yourFirstName,
                    hintText: AppStrings.enterYourName,
                    fontSize: isTablet ? 16 : 16,
                    hasBackgroundColor: true,
                    controller: TextEditingController(),
                  ),

                  SizedBox(height: 12.h),

                  ///============ Phone Number ============
                  CustomFormCard(
                    title: 'Phone Number',
                    hintText: "Enter Phone Number",
                    fontSize: isTablet ? 16 : 16,
                    hasBackgroundColor: true,
                    controller: TextEditingController(),
                  ),

                  SizedBox(height: 12.h),

                  ///============ address ============
                  CustomFormCard(
                    title: "Enter your address",
                    hintText: "Enter address",
                    hasBackgroundColor: true,
                    fontSize: isTablet ? 16 : 16,
                    controller: TextEditingController(),
                  ),

                  SizedBox(height: 12.h),

                  ///============ Experience ============
                  CustomFormCard(
                    title: "Experience",
                    hintText: "Enter Experience",
                    hasBackgroundColor: true,
                    fontSize: isTablet ? 16 : 16,
                    controller: TextEditingController(),
                  ),

                  SizedBox(height: 12.h),

                  ///============ About me ============
                  CustomFormCard(
                    title: "About me",
                    hintText: "About me",
                    hasBackgroundColor: true,
                    fontSize: isTablet ? 16 : 16,
                    maxLine: 3,
                    controller: TextEditingController(),
                  ),

                  SizedBox(height: 16.h),
                  CustomButton(
                    onTap: () {
                      //  Get.toNamed(AppRoutes.loginScreen);
                      Get.back();
                    },
                    title: "SAVE",
                    height: isTablet ? 70 : 60,
                    fontSize: isTablet ? 16 : 14,
                    fillColor: AppColors.appColors,
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
