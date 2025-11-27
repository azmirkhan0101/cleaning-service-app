import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/profile/controllers/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ChangePasswordController changePasswordController = Get.put(
    ChangePasswordController(),
  );

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (changePasswordController.isLoading.value) {
      return; // Prevent multiple submissions
    }
    if (_formKey.currentState?.validate() ?? false) {
      final success = await changePasswordController.changePassword(
        oldPassword: oldPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      if (success) {
        // Clear fields
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        // Navigate back
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:
            ''
            'ChangePassword',
        backButton: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///================== Old password ===================//
                CustomFormCard(
                  isPassword: true,
                  title: 'Old password',
                  hintText: 'Enter Old Password',
                  controller: oldPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.fieldCantBeEmpty;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                ///================== New password ===================//
                CustomFormCard(
                  isPassword: true,
                  title: 'New password',
                  hintText: 'Enter New Password',
                  controller: newPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.fieldCantBeEmpty;
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                ///================== confirm Password===================//
                CustomFormCard(
                  isPassword: true,
                  title: 'Confirm Password',
                  hintText: 'Enter Confirm Password',
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.fieldCantBeEmpty;
                    }
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 50.h),

                Obx(() {
                  final isLoading = changePasswordController.isLoading.value;
                  return CustomButton(
                    onTap: () => _handleChangePassword(),
                    title: isLoading ? "Changing..." : "Save",
                    fontSize: 16,
                    width: double.infinity,
                    height: 50,
                    fillColor: isLoading
                        ? AppColors.grey_2
                        : AppColors.appColors,
                    borderRadius: 24,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
