import 'dart:convert';
import 'dart:io';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceCreateController extends GetxController {
  // Loading state
  RxBool isCreating = false.obs;

  // Form fields from service_add_screen
  RxString selectedCategoryId = ''.obs;
  RxString serviceName = ''.obs;
  RxString description = ''.obs;
  RxString rateByHour = ''.obs;
  RxBool needApproval = false.obs;
  RxBool isFemaleOnly = false.obs;
  RxList<String> selectedLanguages = <String>[].obs;
  RxList<File> coverImages = <File>[].obs;

  // Work schedule from work_schedule_screen
  RxMap<String, Map<String, dynamic>> workSchedule =
      <String, Map<String, dynamic>>{}.obs;

  Future<bool> createService() async {
    // Validation
    if (selectedCategoryId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (serviceName.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter service name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (description.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter description',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (rateByHour.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter rate by hour',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedLanguages.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one language',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (coverImages.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one cover image',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      return false;
    }

    // Validate that all image files exist
    for (var file in coverImages) {
      if (!await file.exists()) {
        Get.snackbar(
          'Error',
          'Some selected images are no longer available. Please select images again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
        coverImages.clear();
        return false;
      }
    }

    if (workSchedule.isEmpty) {
      Get.snackbar(
        'Error',
        'Please set your work schedule',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
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

          Get.snackbar(
            'Service Creation Failed',
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
            duration: Duration(seconds: 5),
            margin: EdgeInsets.all(16),
          );
          return false;
        },
        (data) {
          // success
          Get.snackbar(
            'Success',
            'Service created successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            colorText: Get.theme.colorScheme.onPrimary,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.all(16),
          );

          // Navigate back to services screen
          Get.until((route) => route.isFirst);

          // Reset state
          resetState();

          return true;
        },
      );
    } on PathNotFoundException {
      isCreating.value = false;
      Get.snackbar(
        'Error',
        'Image files are no longer available. Please select images again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: Duration(seconds: 4),
        margin: EdgeInsets.all(16),
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

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: Duration(seconds: 4),
        margin: EdgeInsets.all(16),
      );
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
    selectedCategoryId.value = '';
    serviceName.value = '';
    description.value = '';
    rateByHour.value = '';
    needApproval.value = false;
    isFemaleOnly.value = false;
    selectedLanguages.clear();
    coverImages.clear();
    workSchedule.value = {};
  }
}
