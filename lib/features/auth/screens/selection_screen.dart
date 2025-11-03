import 'dart:ui';

import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/helper/extension/base_extensions.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/controllers/selection_controller.dart';
import 'package:cleaning_service_app/features/auth/widgets/choose_plan_section.dart';
import 'package:cleaning_service_app/features/auth/widgets/set_location_section.dart';
import 'package:cleaning_service_app/features/auth/widgets/set_role_section.dart';
import 'package:cleaning_service_app/features/auth/widgets/upload_document_section.dart';
import 'package:cleaning_service_app/features/auth/widgets/upload_your_photo_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const Color primaryDarkBlue = Color(0xFF13224B);
const Color primaryYellow = Color(0xFFFFC000);
const Color cardBorderBlue = Color(0xFF1E88E5);
const Color unselectedTextColor = Color(0xFF6A6A6A);

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final selectionController = Get.find<SelectionController>();

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLineIndicator(),

                SizedBox(height: 22),

                if (selectionController.currentIndex.value == 0)
                  SetRoleSection(selectionController: selectionController),

                if (selectionController.currentIndex.value == 1)
                  SetLocationSection(),

                if (selectionController.currentIndex.value == 2)
                  UploadYourPhotoSection(),

                if (selectionController.currentIndex.value == 3)
                  UploadDocumentSection(),

                if (selectionController.currentIndex.value == 4)
                  ChoosePlanSection(),

                /// Continue Button
                CustomButton(
                  onTap: () {
                    if (selectionController.currentIndex.value < 4) {
                      if (selectionController.currentIndex.value == 3) {
                        _showAffiliationConditionDialog(context);
                      }
                      selectionController.currentIndex.value =
                          selectionController.currentIndex.value + 1;
                    } else {
                      Get.offNamed(AppRoutes.paymentScreen);
                    }
                  },
                  title: selectionController.currentIndex.value >= 4
                      ? 'Next'
                      : AppStrings.continuetext,
                  fontSize: 16, // Bigger button text for tablets
                  width: double.infinity,
                  height: 50,
                  fillColor: AppColors.appColors,
                  borderRadius: 24,
                  // Wider button on tablets
                ),

                16.w.heightBox,

                // Skip button
                if (selectionController.currentIndex.value == 1 ||
                    selectionController.currentIndex.value == 2)
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        selectionController.currentIndex.value =
                            selectionController.currentIndex.value + 1;
                      },
                      child: CustomText(
                        text: 'Skip',
                        color: const Color(0xFF98A1B2),
                        fontSize: 14,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLineIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: List.generate(5, (index) {
        return Expanded(
          child: Container(
            height: 6,
            decoration: ShapeDecoration(
              color: index == selectionController.currentIndex.value
                  ? AppColors.lightBlue
                  : AppColors.grey_3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 32),
        onPressed: () {
          if (selectionController.currentIndex.value > 0) {
            selectionController.currentIndex.value--;
          } else {
            // Action for the left icon
            Navigator.pop(context);
            // Get.offNamed(AppRoutes.loginScreen);
          }
        },
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Container(
        width: 70,
        margin: EdgeInsets.symmetric(horizontal: 6.0),
        height: 4.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selectionController.currentIndex.value == index
              ? AppColors.appColors
              : AppColors.grey_1,
        ),
      ),
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
            child: _showAffiliateDialog(),
          ),
        );
      },
    );
  }

  Widget _showAffiliateDialog() {
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

          // Accept Button
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7A51D),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                'Accept',
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

          SizedBox(height: 16),
        ],
      ),
    );
  }
}
