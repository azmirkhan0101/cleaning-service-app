import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/provider/service/service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditServiceScreen extends StatefulWidget {
  const EditServiceScreen({super.key});

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final serviceController = Get.find<ServiceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Service", backButton: true),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText2(
                  text: "Select Category",
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),

                SizedBox(height: 6),

                Card(
                  elevation: 0.5,
                  color: AppColors.white,
                  child: SizedBox(
                    width: 200,
                    child: DropdownButton<String>(
                      value:
                          serviceController.selectedCategoryName.value.isEmpty
                          ? null
                          : serviceController
                                .selectedCategoryName
                                .value, // Bind to the GetX value
                      onChanged: (String? newValue) {
                        serviceController.selectedCategoryName.value =
                            newValue!;
                      },
                      items:
                          <String>[
                            'Cleaning',
                            'Laundry',
                            'Handyman',
                            'Electrical',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              enabled: true,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(value),

                                    Radio<bool>(
                                      value: false, // Value for "No"
                                      fillColor: WidgetStateColor.resolveWith(
                                        (states) => AppColors.black_04,
                                      ),
                                      groupValue: true,

                                      onChanged: (bool? value) {
                                        // serviceController.genderType.value=value!;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                      icon: Icon(
                        Icons.arrow_drop_down,
                      ), // Adding the dropdown icon
                      iconSize: 24, // Adjust the icon size if needed
                      isExpanded:
                          true, // Makes the DropdownButton take up all available space
                    ),
                  ),
                ),

                SizedBox(height: 12),

                /// Service name Field
                CustomFormCard(
                  title: "Service Name",
                  hintText: "Enter name",
                  hasBackgroundColor: true,
                  controller: TextEditingController(),
                ),

                SizedBox(height: 12),

                /// Service name Field
                CustomFormCard(
                  title: "Description",
                  hintText: "Enter description",
                  hasBackgroundColor: true,
                  controller: TextEditingController(),
                ),

                SizedBox(height: 12),

                /// Service name Field
                CustomFormCard(
                  title: "Rate by hr",
                  hintText: "Enter €rate",
                  hasBackgroundColor: true,
                  controller: TextEditingController(),
                ),

                SizedBox(height: 12),

                /// Service name Field
                CustomFormCard(
                  title: "Rate by hr",
                  hintText: "Enter €rate",
                  hasBackgroundColor: true,
                  controller: TextEditingController(),
                ),

                SizedBox(height: 12),

                const CustomText2(
                  text: "Can owner book directly without approval?",
                  fontSize: 16,
                  color: AppColors.black_04,
                  fontWeight: FontWeight.w600,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<bool>(
                      value: false, // Value for "No"
                      fillColor: WidgetStateColor.resolveWith(
                        (states) => AppColors.black_04,
                      ),
                      groupValue: serviceController.typeModeStatues.value,

                      onChanged: (bool? value) {
                        serviceController.typeModeStatues.value = value!;
                      },
                    ),

                    const CustomText2(
                      text: "NO",
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    Radio<bool>(
                      value: true, // Value for "Yes"
                      fillColor: WidgetStateColor.resolveWith(
                        (states) => AppColors.black_04,
                      ),
                      groupValue: serviceController.typeModeStatues.value,
                      onChanged: (bool? value) {
                        serviceController.typeModeStatues.value = value!;
                      },
                    ),

                    const CustomText2(
                      text: "Yes",
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),

                SizedBox(height: 12),

                const CustomText2(
                  text: "Gender",
                  fontSize: 18,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<bool>(
                      value: false, // Value for "No"
                      fillColor: WidgetStateColor.resolveWith(
                        (states) => AppColors.black_04,
                      ),
                      groupValue: serviceController.genderType.value,

                      onChanged: (bool? value) {
                        serviceController.genderType.value = value!;
                      },
                    ),

                    const CustomText2(
                      text: "NO",
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    Radio<bool>(
                      value: true, // Value for "Yes"
                      fillColor: WidgetStateColor.resolveWith(
                        (states) => AppColors.black_04,
                      ),
                      groupValue: serviceController.genderType.value,
                      onChanged: (bool? value) {
                        serviceController.genderType.value = value!;
                      },
                    ),

                    const CustomText2(
                      text: "Yes",
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),

                SizedBox(height: 12),

                const CustomText2(
                  text: "Spoken languages",
                  fontSize: 18,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),

                Card(
                  elevation: 0.5,
                  color: AppColors.white,
                  child: DropdownButton<String>(
                    value: serviceController.selectedCountry.value.isEmpty
                        ? null
                        : serviceController
                              .selectedCountry
                              .value, // Bind to the GetX value
                    onChanged: (String? newValue) {
                      serviceController.selectedCountry.value = newValue!;
                    },
                    items: <String>['USA', 'Canada', 'India', 'Australia']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            enabled: true,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(value),
                            ),
                          );
                        })
                        .toList(),
                    icon: Icon(
                      Icons.arrow_drop_down,
                    ), // Adding the dropdown icon
                    iconSize: 24, // Adjust the icon size if needed
                    isExpanded:
                        true, // Makes the DropdownButton take up all available space
                  ),
                ),

                SizedBox(height: 12),

                CustomFormCard(
                  title: "Image (Cover)",
                  hintText: "browse image",
                  hasBackgroundColor: true,
                  prefixIcon: Icon(Icons.image_search),
                  controller: TextEditingController(),
                ),

                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.grey_3.withOpacity(
                      0.6,
                    ), // light background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Handle file selection logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Select file tapped")),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          size: 32,
                          color: Colors.black54,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Select file",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.workScheduleScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColors,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.9,
                      50,
                    ), // 90% of screen width
                  ),
                  child: CustomText2(
                    text: 'Confirm',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
