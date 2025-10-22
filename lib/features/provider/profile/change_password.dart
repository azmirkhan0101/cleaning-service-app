import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        titleName:
            ''
            'ChangePassword',
        leftIcon: true,
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
                  controller: TextEditingController(),
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
                  controller: TextEditingController(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.fieldCantBeEmpty;
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
                  controller: TextEditingController(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.fieldCantBeEmpty;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 50.h),

                CustomButton(
                  onTap: () {
                    Get.back();
                  },
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
      ),
    );
  }
}
