import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/auth/controllers/profile_setup_controller.dart';
import 'package:cleaning_service_app/features/provider/subscription/widgets/choose_plan_section.dart';
import 'package:cleaning_service_app/features/auth/widgets/set_location_section.dart';
import 'package:cleaning_service_app/features/auth/widgets/set_role_section.dart';
import 'package:cleaning_service_app/features/auth/widgets/upload_document_section.dart';
import 'package:cleaning_service_app/features/auth/widgets/upload_your_photo_section.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryDarkBlue = Color(0xFF13224B);
const Color primaryYellow = Color(0xFFFFC000);
const Color cardBorderBlue = Color(0xFF1E88E5);
const Color unselectedTextColor = Color(0xFF6A6A6A);

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key, required this.email});
  final String email;

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final selectionController = Get.find<ProfileSetupController>();

  // final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    selectionController.email.value = widget.email;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLineIndicator(
                  selectionController.selectedRole.value == Role.owner ? 4 : 5,
                ),

                SizedBox(height: 22),

                if (selectionController.currentIndex.value == 0)
                  SetRoleSection(selectionController: selectionController),

                if (selectionController.currentIndex.value == 1)
                  SetLocationSection(),

                if (selectionController.currentIndex.value == 2)
                  UploadYourPhotoSection(),

                // Upload Document Section - Only for Provider
                if (selectionController.currentIndex.value == 3)
                  UploadDocumentSection(),

                // Choose Plan Section - Only for Provider
                if (selectionController.currentIndex.value == 4 &&
                    selectionController.selectedRole.value == Role.provider)
                  ChoosePlanSection(),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLineIndicator(int totalSteps) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: List.generate(totalSteps, (index) {
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
}
