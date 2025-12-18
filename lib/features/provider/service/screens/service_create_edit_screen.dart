import 'dart:io';

import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/common/widgets/custom_drop_down_button.dart';
import 'package:cleaning_service_app/features/provider/service/controllers/service_create_controller.dart';
import 'package:cleaning_service_app/features/provider/service/models/provider_service_model.dart';
import 'package:cleaning_service_app/features/provider/service/service_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ServiceCreateEditScreen extends StatefulWidget {
  const ServiceCreateEditScreen({super.key, this.serviceModel});
  final ProviderServiceModel? serviceModel;

  @override
  State<ServiceCreateEditScreen> createState() =>
      _ServiceCreateEditScreenState();
}

class _ServiceCreateEditScreenState extends State<ServiceCreateEditScreen> {
  final serviceController = Get.find<ServiceController>();
  final createController = Get.put(ServiceCreateController());

  // Text controllers
  final serviceNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final rateByHourController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.serviceModel != null) {
      // Load data into createController
      createController.loadServiceForEdit(widget.serviceModel!);

      // Populate text controllers
      serviceNameController.text = widget.serviceModel!.name;
      descriptionController.text = widget.serviceModel!.description;
      rateByHourController.text = widget.serviceModel!.rateByHour.toString();

      // Populate serviceController UI fields
      serviceController.selectedCategoryId.value =
          widget.serviceModel!.categoryId.id;
      serviceController.selectedCategoryName.value =
          widget.serviceModel!.categoryId.name;
      serviceController.typeModeStatues.value =
          widget.serviceModel!.needApproval;
      serviceController.genderType.value =
          widget.serviceModel!.gender == 'Female';
      serviceController.selectedLanguages.value =
          widget.serviceModel!.languages;
    }
  }

  @override
  void dispose() {
    serviceNameController.dispose();
    descriptionController.dispose();
    rateByHourController.dispose();
    super.dispose();
  }

  /// Compress image to reduce file size for upload
  /// Target: < 1-2MB per image
  Future<File?> _compressImage(File file, {int quality = 60}) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final splitPath = filePath.substring(0, lastIndex);
      final outPath = "${splitPath}_compressed.jpg";

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: quality,
        minWidth: 1024,
        minHeight: 1024,
        format: CompressFormat.jpeg,
      );

      if (result != null) {
        final compressedFile = File(result.path);
        final originalSize = await file.length();
        final compressedSize = await compressedFile.length();

        debugPrint(
          'Cover image compressed: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB '
          '-> ${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB '
          '(${((1 - compressedSize / originalSize) * 100).toStringAsFixed(1)}% reduction)',
        );

        // If still too large (> 2MB), compress again with lower quality
        if (compressedSize > 2 * 1024 * 1024 && quality > 30) {
          debugPrint('Image still large, compressing again...');
          return await _compressImage(compressedFile, quality: quality - 20);
        }

        return compressedFile;
      }

      return file;
    } catch (e) {
      debugPrint('Compression error: $e');
      return file;
    }
  }

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
                controller: serviceNameController,
              ),

              SizedBox(height: 12),

              /// Description Field
              CustomFormCard(
                title: "Description",
                hintText: "Enter description",
                hasBackgroundColor: true,
                controller: descriptionController,
                maxLine: 2,
              ),

              SizedBox(height: 12),

              /// Rate by hr Field
              CustomFormCard(
                title: "Rate by hr",
                hintText: "Enter €rate",
                hasBackgroundColor: true,
                controller: rateByHourController,
                keyboardType: TextInputType.number,
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
                      value: true, // Value for "No"
                      fillColor: WidgetStateColor.resolveWith(
                        (states) => AppColors.black_04,
                      ),

                      groupValue: !serviceController.typeModeStatues.value,
                      onChanged: (bool? value) {
                        serviceController.typeModeStatues.value = !value!;
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        serviceController.typeModeStatues.value = true;
                      },
                      child: const CustomText2(
                        text: "NO",
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Radio<bool>(
                      value: false, // Value for "Yes"
                      fillColor: WidgetStateColor.resolveWith(
                        (states) => AppColors.black_04,
                      ),
                      groupValue: !serviceController.typeModeStatues.value,
                      onChanged: (bool? value) {
                        serviceController.typeModeStatues.value = !value!;
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        serviceController.typeModeStatues.value = false;
                      },
                      child: const CustomText2(
                        text: "Yes",
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
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
                      value: false, // Value for "Male"
                      fillColor: WidgetStateColor.resolveWith(
                        (states) => AppColors.black_04,
                      ),
                      groupValue: serviceController.genderType.value,
                      onChanged: (bool? value) {
                        serviceController.genderType.value = value!;
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        serviceController.genderType.value = false;
                      },
                      child: const CustomText2(
                        text: "Male",
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Radio<bool>(
                      value: true, // Value for "Female"
                      fillColor: WidgetStateColor.resolveWith(
                        (states) => AppColors.black_04,
                      ),
                      groupValue: serviceController.genderType.value,
                      onChanged: (bool? value) {
                        serviceController.genderType.value = value!;
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        serviceController.genderType.value = true;
                      },
                      child: const CustomText2(
                        text: "Female",
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
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

              const CustomText(
                text: "Images",
                fontSize: 18,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 8),

              // Display selected images
              Obx(() {
                final hasNewImages = createController.coverImages.isNotEmpty;
                final hasExistingImages =
                    createController.existingImageUrls.isNotEmpty;

                if (!hasNewImages && !hasExistingImages) {
                  return SizedBox.shrink();
                }

                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Display existing images from URLs
                      ...createController.existingImageUrls.map((url) {
                        return Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -8,
                              right: -8,
                              child: IconButton(
                                icon: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  createController.existingImageUrls.remove(
                                    url,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      // Display newly selected images from files
                      ...createController.coverImages.map((file) {
                        return Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(file),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -8,
                              right: -8,
                              child: IconButton(
                                icon: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  createController.coverImages.remove(file);
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                );
              }),

              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.grey_3.withOpacity(0.6), // light background
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final List<XFile> images = await picker.pickMultiImage();

                    if (images.isNotEmpty) {
                      for (var image in images) {
                        final originalFile = File(image.path);
                        // Compress image before adding
                        final compressedFile = await _compressImage(
                          originalFile,
                        );
                        if (compressedFile != null) {
                          createController.coverImages.add(compressedFile);
                        }
                      }
                    }
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
                        "Select Images",
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
                  // Collect all form data
                  createController.selectedCategoryId.value =
                      serviceController.selectedCategoryId.value;
                  createController.serviceName.value =
                      serviceNameController.text;
                  createController.description.value =
                      descriptionController.text;
                  createController.rateByHour.value = rateByHourController.text;
                  createController.needApproval.value =
                      serviceController.typeModeStatues.value;
                  createController.isFemaleOnly.value =
                      serviceController.genderType.value;
                  createController.selectedLanguages.value =
                      serviceController.selectedLanguages;

                  // Validate before navigation
                  if (!createController.validateServiceData()) {
                    return; // Stop if validation fails (error will be shown by validateServiceData)
                  }

                  // Navigate to work schedule screen
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
                  text: 'Continue',
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
