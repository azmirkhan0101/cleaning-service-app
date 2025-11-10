import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/common/widgets/custom_drop_down_button.dart';
import 'package:cleaning_service_app/features/provider/service/service_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceAddScreen extends StatefulWidget {
  const ServiceAddScreen({super.key});

  @override
  State<ServiceAddScreen> createState() => _ServiceAddScreenState();
}

class _ServiceAddScreenState extends State<ServiceAddScreen> {
  final serviceController = Get.find<ServiceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Add Service", backButton: true),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText2(
                text: "Select Category",
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),

              SizedBox(height: 6),

              Obx(
                () => serviceController.isLoadingCategories.value
                    ? Card(
                        elevation: 0.5,
                        color: AppColors.white,
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Loading categories...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : serviceController.categoriesError.isNotEmpty
                    ? Card(
                        elevation: 0.5,
                        color: AppColors.white,
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  serviceController.categoriesError.value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: serviceController.fetchCategories,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : CustomDropDownButton(
                        items: serviceController.categories
                            .map((category) => category.name)
                            .toList(),
                        hintText: "Select Category",
                        selectedValue:
                            serviceController.selectedCategoryName.value.isEmpty
                            ? null
                            : serviceController.selectedCategoryName.value,
                        onChanged: (String? newValue) {
                          // Find the category by name and store both ID and name
                          final selectedCategory = serviceController.categories
                              .firstWhere((cat) => cat.name == newValue);
                          serviceController.selectedCategoryId.value =
                              selectedCategory.id;
                          serviceController.selectedCategoryName.value =
                              newValue!;
                        },
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

              Obx(
                () => Row(
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
              ),

              SizedBox(height: 12),

              const CustomText2(
                text: "Gender",
                fontSize: 18,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),

              Obx(
                () => Row(
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
              ),

              SizedBox(height: 12),

              const CustomText2(
                text: "Spoken languages",
                fontSize: 18,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 8),

              // Multi-select language dropdown with DropdownButton2
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Text(
                    'Select Languages',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  items: serviceController.availableLanguages.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      enabled: false,
                      child: StatefulBuilder(
                        builder: (context, menuSetState) {
                          final isSelected = serviceController.selectedLanguages
                              .contains(item);
                          return InkWell(
                            onTap: () {
                              if (isSelected) {
                                serviceController.selectedLanguages.remove(
                                  item,
                                );
                              } else {
                                serviceController.selectedLanguages.add(item);
                              }
                              menuSetState(() {});
                              setState(() {}); // Trigger parent widget rebuild
                            },
                            child: Container(
                              height: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Row(
                                children: [
                                  if (isSelected)
                                    Icon(
                                      Icons.check_box_outlined,
                                      color: AppColors.appColors,
                                    )
                                  else
                                    const Icon(Icons.check_box_outline_blank),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  value: serviceController.selectedLanguages.isEmpty
                      ? null
                      : serviceController.selectedLanguages.last,
                  onChanged: (value) {},
                  selectedItemBuilder: (context) {
                    return serviceController.availableLanguages.map((item) {
                      return Obx(
                        () => Container(
                          alignment: AlignmentDirectional.centerStart,
                          child: serviceController.selectedLanguages.isEmpty
                              ? const Text(
                                  'Select Languages',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                )
                              : Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: serviceController.selectedLanguages
                                      .map(
                                        (lang) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.appColors
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            border: Border.all(
                                              color: AppColors.appColors
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          child: Text(
                                            lang,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.appColors,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                        ),
                      );
                    }).toList();
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    padding: const EdgeInsets.only(left: 16, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey_1),
                      color: AppColors.white,
                    ),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.white,
                    ),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: WidgetStateProperty.all(6),
                      thumbVisibility: WidgetStateProperty.all(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 48,
                    padding: EdgeInsets.zero,
                  ),
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
                  color: AppColors.grey_3.withOpacity(0.6), // light background
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
                  Get.toNamed(AppRoutes.workScheduleScreen);
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
          ),
        ),
      ),
    );
  }
}
