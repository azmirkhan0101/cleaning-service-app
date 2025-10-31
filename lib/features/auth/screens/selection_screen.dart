import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/helper/extension/base_extensions.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/features/auth/controllers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/controllers/selection_controller.dart';
import 'package:cleaning_service_app/features/auth/widgets/set_location_section.dart';
import 'package:cleaning_service_app/features/auth/widgets/set_role_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

  final storage = GetStorage();

  int? _selectedExperience;
  // bool? _instantBooking;
  // String? _selectedGender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (selectionController.typeModeStatues.value == false) {
      storage.write("userType", "owner");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Current index: ${selectionController.currentIndex.value}");

    return Scaffold(
      // appBar: CustomAppbar(leftIcon: true,),
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
                  SetRoleSection(
                    selectionController: selectionController,
                    storage: storage,
                  ),

                if (selectionController.currentIndex.value == 1)
                  SetLocationSection(),

                if (selectionController.currentIndex.value == 2)
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
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

                        const CustomText2(
                          text: AppStrings.profileTitle,
                          fontSize: 12,
                          color: unselectedTextColor,
                          fontWeight: FontWeight.w400,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                        ),

                        const SizedBox(height: 32),

                        Center(
                          child: SizedBox(
                            width:
                                MediaQuery.of(context).size.width *
                                0.5, // 50% of the screen width
                            height:
                                MediaQuery.of(context).size.width *
                                0.5, // Maintain a square aspect ratio
                            child: CustomImage(imageSrc: AppIcons.add_image),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (selectionController.currentIndex.value == 3)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Heading and Subheading
                      const CustomText2(
                        text: AppStrings.VerifyProfile,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),

                      const SizedBox(height: 12),

                      const CustomText2(
                        text: AppStrings.VerifyProfileTitle,
                        fontSize: 12,
                        color: unselectedTextColor,
                        fontWeight: FontWeight.w400,
                        maxLines: 3,
                        textAlign: TextAlign.start,
                      ),

                      const SizedBox(height: 24),

                      // Upload Front Side of ID
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.lightBlue.withOpacity(
                              0.6,
                            ), // The white border for unselected
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText2(
                                text: "Upload the Front Side of Your ID",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),

                              SizedBox(height: 6),

                              CustomText2(
                                text:
                                    "Take a clear photo or upload the front side of your identity card. Make sure all details are visible.",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                maxLines: 3,
                                textAlign: TextAlign.start,
                              ),

                              SizedBox(height: 16),

                              ElevatedButton.icon(
                                onPressed: () {
                                  // Handle the upload action
                                  print("Upload Front Side clicked");
                                },
                                icon: Icon(Icons.add),
                                label: CustomText2(
                                  text: 'Upload Front Side',
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Colors.blue),
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.9,
                                    45,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 22),

                      // Upload Back Side of ID
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.lightBlue.withOpacity(
                              0.6,
                            ), // The white border for unselected
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText2(
                                text: "Upload the Back Side of Your ID",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),

                              SizedBox(height: 6),

                              CustomText2(
                                text:
                                    "Now, upload a clear photo of the back side of your identity card.",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                maxLines: 3,
                                textAlign: TextAlign.start,
                              ),

                              SizedBox(height: 16),

                              ElevatedButton.icon(
                                onPressed: () {
                                  // Handle the upload action
                                  print("Upload Front Side clicked");
                                },
                                icon: Icon(Icons.add),
                                label: CustomText2(
                                  text: 'Upload Back Side',
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Colors.blue),
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.9,
                                    45,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 22),

                      // Upload Selfie with ID
                      /*   Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.lightBlue.withOpacity(0.6), // The white border for unselected
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text:"Upload a Selfie with Your ID",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),

                                SizedBox(height: 6),

                                CustomText(
                                  text:"Take a selfie while holding your identity card next to your face. Ensure everything clearly visible.",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  maxLines: 3,
                                  textAlign: TextAlign.start,
                                ),

                                SizedBox(height: 16),

                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Handle the upload action
                                    print("Upload Front Side clicked");
                                  },
                                  icon: Icon(Icons.add),
                                  label: CustomText(text:
                                    'Upload Selfie with ID',
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(color: Colors.blue),
                                    minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),*/
                    ],
                  ),

                if (selectionController.currentIndex.value == 4)
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

                      const CustomText2(
                        text: AppStrings.chooseYourPlanTitle,
                        fontSize: 12,
                        color: unselectedTextColor,
                        fontWeight: FontWeight.w400,
                        maxLines: 3,
                        textAlign: TextAlign.start,
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Radio<bool>(
                            value: false, // Value for "No"
                            fillColor: WidgetStateColor.resolveWith(
                              (states) => AppColors.lightBlue,
                            ),
                            groupValue:
                                selectionController.typPaymentStatues.value,
                            onChanged: (bool? value) {
                              selectionController.typPaymentStatues.value =
                                  value!;
                            },
                          ),

                          ///Service Basic Plan  Card
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color:
                                    selectionController
                                            .typPaymentStatues
                                            .value ==
                                        false
                                    ? AppColors.lightBlue
                                    : null,
                                border: Border.all(
                                  color:
                                      selectionController
                                              .typPaymentStatues
                                              .value ==
                                          false
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
                                                false
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
                                                  false
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
                                                  false
                                              ? Colors.black
                                              : Colors.white, // Text color
                                          fontSize: 10.0, // Font size
                                          fontWeight:
                                              FontWeight.bold, // Bold text
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
                                            false
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
                                                false
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
                                                false
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
                                                false
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
                                                false
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
                          Radio<bool>(
                            value: true, // Value for "Yes"
                            fillColor: WidgetStateColor.resolveWith(
                              (states) => AppColors.primary,
                            ),
                            groupValue:
                                selectionController.typPaymentStatues.value,
                            onChanged: (bool? value) {
                              selectionController.typPaymentStatues.value =
                                  value!;
                            },
                          ),

                          ///Service Pro Plan  Card
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                color:
                                    selectionController
                                            .typPaymentStatues
                                            .value ==
                                        true
                                    ? AppColors.lightBlue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color:
                                      selectionController.typeModeStatues.value
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
                                                true
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
                                                  true
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
                                                  true
                                              ? AppColors.black
                                              : Colors.white, // Text color
                                          fontSize: 10.0, // Font size
                                          fontWeight:
                                              FontWeight.bold, // Bold text
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
                                            true
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
                                                true
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
                                                true
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
                                                true
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
                                                true
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
                                                true
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
                                                true
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

                SizedBox(height: 16),

                ///Professional's Experience Section
                if (selectionController.typeModeStatues.value == true &&
                    selectionController.currentIndex.value == 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Professional's experience"),
                      const SizedBox(height: 16),
                      _buildExperienceOptions(),
                      const SizedBox(height: 16),
                    ],
                  ),

                SizedBox(
                  height: selectionController.currentIndex.value == 4 ? 40 : 24,
                ),

                /// Continue Button
                CustomButton(
                  onTap: () {
                    if (selectionController.currentIndex.value < 4) {
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildExperienceOptions() {
    final options = [
      "0-2 years of experience",
      "2-5 years of experience",
      "6-10 years of experience",
      "11-20 years of experience",
      "+20 years of experience",
    ];

    return Column(
      children: List.generate(options.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Checkbox(
                value: _selectedExperience == index,
                onChanged: (bool? value) {
                  setState(() {
                    _selectedExperience = value == true ? index : null;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              const SizedBox(width: 8),

              CustomText2(
                text: options[index],
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        );
      }),
    );
  }
}
