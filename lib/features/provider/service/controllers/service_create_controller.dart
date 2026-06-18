import 'dart:convert';
import 'dart:io';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/provider/service/models/provider_service_model.dart';
import 'package:get/get.dart';

class ServiceCreateController extends GetxController {
  // Loading state
  RxBool isCreating = false.obs;

  // Edit mode
  RxBool isEditMode = false.obs;
  RxString editServiceId = ''.obs;

  // Form fields from service_add_screen
  var selectedCategoryId = ''.obs;
  var serviceName = ''.obs;
  var description = ''.obs;
  var rateByHour = ''.obs;
  var needApproval = false.obs;
  var isFemaleOnly = false.obs;
  var selectedLanguages = <String>[].obs;
  var coverImages = <File>[].obs;
  var existingImageUrls = <CoverImageMeta>[].obs; // For edit mode

  // Work schedule from work_schedule_screen
  var workSchedule = <String, Map<String, dynamic>>{}.obs;
  var bufferTime = 15.obs;

  /// Validates all service data before creation/update
  /// Returns true if valid, false otherwise (shows error message)
  bool validateServiceData() {
    if (selectedCategoryId.value.isEmpty) {
      Toast.errorToast('Please select a category');
      return false;
    }

    if (serviceName.value.isEmpty) {
      Toast.errorToast('Please enter service name');
      return false;
    }

    if (description.value.isEmpty) {
      Toast.errorToast('Please enter description');
      return false;
    }

    if (rateByHour.value.isEmpty) {
      Toast.errorToast('Please enter rate by hour');
      return false;
    }

    if (selectedLanguages.isEmpty) {
      Toast.errorToast('Please select at least one language');
      return false;
    }

    if (coverImages.isEmpty && existingImageUrls.isEmpty) {
      Toast.errorToast('Please select at least one cover image');
      return false;
    }

    return true;
  }

  Future<bool> createService() async {
    // Validation
    if (!validateServiceData()) {
      return false;
    }

    // Validate that all image files exist
    for (var file in coverImages) {
      if (!await file.exists()) {
        Toast.errorToast(
          'Some selected images are no longer available. Please select images again.',
        );
        coverImages.clear();
        return false;
      }
    }

    if (workSchedule.isEmpty) {
      Toast.errorToast('Please set your work schedule');
      return false;
    }

    isCreating.value = true;

    try {
      // Prepare fields as strings for multipart
      final Map<String, String> fields = {
        'categoryId': selectedCategoryId.value,
        'name': serviceName.value,
        'description': description.value,
        'rateByHour': rateByHour.value,
        'needApproval': needApproval.value.toString(),
        'gender': isFemaleOnly.value ? 'Female' : 'Male',
        'languages': selectedLanguages.join(','),
        'workSchedule': _convertWorkScheduleToJson(),
        'bufferTime': bufferTime.value.toString(),
      };

      // Prepare cover images for multipart
      final List<MultipartBody> files = coverImages
          .map((file) => MultipartBody(key: 'coverImages', file: file))
          .toList();

      final response = await Get.find<NetworkHelper>().multipart(
        url: ApiUrl.createService,
        method: "POST",
        fields: fields,
        files: files,
        withAuth: true,
        parser: (data) {
          return data; // Return raw data or create a response model
        },
      );

      isCreating.value = false;

      return response.fold(
        (error) {
          // Enhanced error message handling
          String errorMessage = error.message ?? 'Service creation failed';

          // Check for specific error types
          if (errorMessage.contains('Stripe')) {
            errorMessage =
                'Please connect your Stripe account in your profile settings before creating services.';
          } else if (errorMessage.contains('permission')) {
            errorMessage = 'You don\'t have permission to create services.';
          } else if (errorMessage.contains('network')) {
            errorMessage =
                'Network error. Please check your internet connection.';
          }
          Toast.errorToast(errorMessage);
          return false;
        },
        (data) {
          // success
          Toast.successToast('Service created successfully');

          // Navigate back to services screen
          Get.until((route) => route.isFirst);

          // Reset state
          resetState();

          return true;
        },
      );
    } on PathNotFoundException {
      isCreating.value = false;
      Toast.errorToast(
        'Image files are no longer available. Please select images again.',
      );
      coverImages.clear();
      return false;
    } catch (e) {
      isCreating.value = false;
      String errorMessage = e.toString();

      // Clean up error message
      if (errorMessage.contains('PathNotFoundException')) {
        errorMessage =
            'Image files are no longer available. Please select images again.';
        coverImages.clear();
      } else if (errorMessage.contains('SocketException')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else {
        errorMessage = 'An unexpected error occurred. Please try again.';
      }
      Toast.errorToast(errorMessage);
      return false;
    }
  }

  /// Convert work schedule map to JSON string
  String _convertWorkScheduleToJson() {
    // The API expects a JSON string, so we need to encode it properly
    return jsonEncode(workSchedule);
  }

  /// Reset controller state
  void resetState() {
    isEditMode.value = false;
    editServiceId.value = '';
    selectedCategoryId.value = '';
    serviceName.value = '';
    description.value = '';
    rateByHour.value = '';
    needApproval.value = false;
    isFemaleOnly.value = false;
    selectedLanguages.clear();
    coverImages.clear();
    existingImageUrls.clear();
    workSchedule.value = {};
  }

  /// Load service data for editing
  void loadServiceForEdit(ProviderServiceModel service) {
    isEditMode.value = true;
    editServiceId.value = service.id;
    selectedCategoryId.value = service.categoryId.id;
    serviceName.value = service.name;
    description.value = service.description;
    rateByHour.value = service.rateByHour;
    needApproval.value = service.needApproval;
    isFemaleOnly.value = service.gender == 'Female';
    selectedLanguages.value = service.languages;
    existingImageUrls.value = service.coverImagesMeta;

    // Convert WorkSchedule model to Map format for the controller
    workSchedule.value = {
      'Monday': {
        'isAvailable': service.workSchedule.monday.isAvailable,
        'startTime': service.workSchedule.monday.startTime,
        'endTime': service.workSchedule.monday.endTime,
        'bufferTime': service.bufferTime,
      },
      'Tuesday': {
        'isAvailable': service.workSchedule.tuesday.isAvailable,
        'startTime': service.workSchedule.tuesday.startTime,
        'endTime': service.workSchedule.tuesday.endTime,
        'bufferTime': service.bufferTime,
      },
      'Wednesday': {
        'isAvailable': service.workSchedule.wednesday.isAvailable,
        'startTime': service.workSchedule.wednesday.startTime,
        'endTime': service.workSchedule.wednesday.endTime,
        'bufferTime': service.bufferTime,
      },
      'Thursday': {
        'isAvailable': service.workSchedule.thursday.isAvailable,
        'startTime': service.workSchedule.thursday.startTime,
        'endTime': service.workSchedule.thursday.endTime,
        'bufferTime': service.bufferTime,
      },
      'Friday': {
        'isAvailable': service.workSchedule.friday.isAvailable,
        'startTime': service.workSchedule.friday.startTime,
        'endTime': service.workSchedule.friday.endTime,
        'bufferTime': service.bufferTime,
      },
      'Saturday': {
        'isAvailable': service.workSchedule.saturday.isAvailable,
        'startTime': service.workSchedule.saturday.startTime,
        'endTime': service.workSchedule.saturday.endTime,
        'bufferTime': service.bufferTime,
      },
      'Sunday': {
        'isAvailable': service.workSchedule.sunday.isAvailable,
        'startTime': service.workSchedule.sunday.startTime,
        'endTime': service.workSchedule.sunday.endTime,
        'bufferTime': service.bufferTime,
      },
    };
  }

  /// Update existing service
  Future<bool> updateService() async {
    if (editServiceId.value.isEmpty) {
      Toast.errorToast('Service ID is required');
      return false;
    }

    // Validation
    if (selectedCategoryId.value.isEmpty) {
      Toast.errorToast('Please select a category');
      return false;
    }

    if (serviceName.value.isEmpty) {
      Toast.errorToast('Please enter service name');
      return false;
    }

    if (description.value.isEmpty) {
      Toast.errorToast('Please enter description');
      return false;
    }

    if (rateByHour.value.isEmpty) {
      Toast.errorToast('Please enter rate by hour');
      return false;
    }

    if (selectedLanguages.isEmpty) {
      Toast.errorToast('Please select at least one language');
      return false;
    }

    if (coverImages.isEmpty && existingImageUrls.isEmpty) {
      Toast.errorToast('Please add at least one image');
      return false;
    }

    if (workSchedule.isEmpty) {
      Toast.errorToast('Please set your work schedule');
      return false;
    }

    isCreating.value = true;

    try {
      final network = Get.find<NetworkHelper>();

      // Create form data for multipart request
      final fields = <String, String>{
        'categoryId': selectedCategoryId.value,
        'name': serviceName.value,
        'description': description.value,
        'rateByHour': rateByHour.value,
        'needApproval': needApproval.value.toString(),
        'gender': isFemaleOnly.value ? 'Female' : 'Male',
        'languages': selectedLanguages.join(','),
        'workSchedule': _convertWorkScheduleToJson(),
        'bufferTime': bufferTime.value.toString(),
      };

      // Add existing image URLs
      if (existingImageUrls.isNotEmpty) {
        fields['existingImages'] = existingImageUrls.join(',');
      }

      final files = coverImages
          .map((file) => MultipartBody(key: 'coverImages', file: file))
          .toList();

      final response = await network.multipart(
        url: '${ApiUrl.baseUrl}/service/update/${editServiceId.value}',
        method: 'PUT',
        fields: fields,
        files: files,
        withAuth: true,
        parser: (data) {
          return data;
        },
      );

      isCreating.value = false;

      return response.fold(
        (error) {
          String errorMessage = error.message ?? 'Service update failed';

          if (errorMessage.contains('Stripe')) {
            errorMessage =
                'Please connect your Stripe account in your profile settings.';
          } else if (errorMessage.contains('permission')) {
            errorMessage = 'You don\'t have permission to update this service.';
          }

          Toast.errorToast(errorMessage);

          return false;
        },
        (data) {
          Toast.successToast('Service updated successfully');

          // Navigate back to services screen
          Get.until((route) => route.isFirst);

          // Reset state
          resetState();

          return true;
        },
      );
    } catch (e) {
      isCreating.value = false;
      Toast.errorToast('An unexpected error occurred. Please try again.');
      return false;
    }
  }
}
