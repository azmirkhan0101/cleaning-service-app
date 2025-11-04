import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/selection_controller.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProPlanSubscriptionScreen extends StatefulWidget {
  const ProPlanSubscriptionScreen({super.key});

  @override
  State<ProPlanSubscriptionScreen> createState() =>
      _ProPlanSubscriptionScreenState();
}

class _ProPlanSubscriptionScreenState extends State<ProPlanSubscriptionScreen> {
  final selectionController = Get.find<SelectionController>();

  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleName: "Choose Your Plan"),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Heading and Subheading
                  const CustomText2(
                    text: AppStrings.chooseYourPlan,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),

                  const SizedBox(height: 12),

                  CustomText2(
                    text: AppStrings.chooseYourPlanTitle,
                    fontSize: 12,
                    color: AppColors.unselectedTextColor,
                    fontWeight: FontWeight.w400,
                    maxLines: 3,
                    textAlign: TextAlign.start,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Radio<int>(
                        value: 0, // Free Plan
                        fillColor: WidgetStateColor.resolveWith(
                          (states) => AppColors.lightBlue,
                        ),
                        groupValue: selectionController.typPaymentStatues.value,
                        onChanged: (int? value) {
                          selectionController.typPaymentStatues.value = value!;
                        },
                      ),

                      ///Service Basic Plan  Card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color:
                                selectionController.typPaymentStatues.value == 0
                                ? AppColors.lightBlue
                                : null,
                            border: Border.all(
                              color:
                                  selectionController.typPaymentStatues.value ==
                                      0
                                  ? AppColors
                                        .lightBlue // The blue border for selected
                                  : Colors
                                        .white, // The white border for unselected
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.light_Blue,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText2(
                                    text: '€0 / month',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            0
                                        ? AppColors.white_50
                                        : Color(0xFF333333),
                                  ),

                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 6.0,
                                    ), // Padding inside the container
                                    decoration: BoxDecoration(
                                      color:
                                          selectionController
                                                  .typPaymentStatues
                                                  .value ==
                                              0
                                          ? AppColors.white_50
                                          : AppColors.grey_1.withOpacity(
                                              0.6,
                                            ), // Background color
                                      borderRadius: BorderRadius.circular(
                                        20.0,
                                      ), // Rounded corners
                                      // border: Border.all(color: Colors.blue), // Border color
                                    ),
                                    child: CustomText2(
                                      text: 'Pro Plan',
                                      color:
                                          selectionController
                                                  .typPaymentStatues
                                                  .value ==
                                              0
                                          ? Colors.black
                                          : Colors.white, // Text color
                                      fontSize: 10.0, // Font size
                                      fontWeight: FontWeight.bold, // Bold text
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 6.0),

                              CustomText2(
                                text: 'Commission: 15%',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color:
                                    selectionController
                                            .typPaymentStatues
                                            .value ==
                                        0
                                    ? AppColors.white_50
                                    : Color(0xFF333333),
                              ),

                              SizedBox(height: 8.0),

                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            0
                                        ? AppColors.white_50
                                        : AppColors.lightBlue,
                                  ),

                                  SizedBox(height: 8.0),

                                  CustomText2(
                                    text: 'Standard visibility ',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            0
                                        ? AppColors.white_50
                                        : Color(0xFF333333),
                                  ),
                                ],
                              ),

                              SizedBox(height: 8.0),

                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            0
                                        ? AppColors.white_50
                                        : AppColors.lightBlue,
                                  ),

                                  SizedBox(height: 8.0),

                                  CustomText2(
                                    text: 'Standard support',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            0
                                        ? AppColors.white_50
                                        : Color(0xFF333333),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0), // Spacing between cards

                  Row(
                    children: [
                      Radio<int>(
                        value: 1, // Pro Plan
                        fillColor: WidgetStateColor.resolveWith(
                          (states) => AppColors.primary,
                        ),
                        groupValue: selectionController.typPaymentStatues.value,
                        onChanged: (int? value) {
                          selectionController.typPaymentStatues.value = value!;
                        },
                      ),

                      ///Service Pro Plan  Card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color:
                                selectionController.typPaymentStatues.value == 1
                                ? AppColors.lightBlue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color:
                                  selectionController.selectedRole.value ==
                                      Role.provider
                                  ? Color(
                                      0xFF1E88E5,
                                    ) // The blue border for selected
                                  : Colors
                                        .white, // The white border for unselected
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey_3.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText2(
                                    text: '€29 / month',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            1
                                        ? AppColors.white_50
                                        : Color(0xFF333333),
                                  ),

                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 6.0,
                                    ), // Padding inside the container
                                    decoration: BoxDecoration(
                                      color:
                                          selectionController
                                                  .typPaymentStatues
                                                  .value ==
                                              1
                                          ? AppColors.white_50
                                          : Colors.blue, // Background color
                                      borderRadius: BorderRadius.circular(
                                        20.0,
                                      ), // Rounded corners
                                      border: Border.all(
                                        color: Colors.blue,
                                      ), // Border color
                                    ),
                                    child: CustomText2(
                                      text: 'Pro Plan',
                                      color:
                                          selectionController
                                                  .typPaymentStatues
                                                  .value ==
                                              1
                                          ? AppColors.black
                                          : Colors.white, // Text color
                                      fontSize: 10.0, // Font size
                                      fontWeight: FontWeight.bold, // Bold text
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 6.0),

                              CustomText2(
                                text: 'Commission: 10%',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color:
                                    selectionController
                                            .typPaymentStatues
                                            .value ==
                                        1
                                    ? AppColors.white_50
                                    : Color(0xFF333333),
                              ),

                              SizedBox(height: 8.0),

                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            1
                                        ? AppColors.white_50
                                        : AppColors.lightBlue,
                                  ),

                                  SizedBox(height: 8.0),

                                  CustomText2(
                                    text: 'Priority listing',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            1
                                        ? AppColors.white_50
                                        : Color(0xFF333333),
                                  ),
                                ],
                              ),

                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            1
                                        ? AppColors.white_50
                                        : AppColors.lightBlue,
                                  ),

                                  SizedBox(height: 8.0),

                                  CustomText2(
                                    text: 'Pro badge',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            1
                                        ? AppColors.white_50
                                        : Color(0xFF333333),
                                  ),
                                ],
                              ),

                              SizedBox(height: 8.0),

                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            1
                                        ? AppColors.white_50
                                        : AppColors.lightBlue,
                                  ),

                                  SizedBox(height: 8.0),

                                  CustomText2(
                                    text: ' €20 credits/month',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        selectionController
                                                .typPaymentStatues
                                                .value ==
                                            1
                                        ? AppColors.white_50
                                        : Color(0xFF333333),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// Continue Button
              CustomButton(
                onTap: () {
                  storage.write("userType", "provider");

                  Get.toNamed(AppRoutes.paymentScreen);
                },
                title: AppStrings.continueText,
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
    );
  }
}
