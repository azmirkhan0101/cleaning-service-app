import 'dart:io';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:cleaning_service_app/features/profile/models/profile_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class EditProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  List<String> experienceLevels = ['0-1', '1-5', '+5'];
  RxString selectedExperience = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);

  // Image picker
  final ImagePicker _picker = ImagePicker();
  Rx<File?> profileImage = Rx<File?>(null);

  void selectExperience(String experience) {
    selectedExperience.value = experience;
  }

  /// Copy image to app's permanent storage
  Future<File?> _saveImagePermanently(XFile image) async {
    try {
      // Get app's documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();

      // Create a unique filename with timestamp
      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
      final String permanentPath = path.join(appDir.path, fileName);

      // Copy the file to permanent location
      final File permanentFile = await File(image.path).copy(permanentPath);

      return permanentFile;
    } catch (e) {
      print('Error saving image permanently: $e');
      return null;
    }
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        // Save to permanent location to avoid cache clearing issues
        final permanentFile = await _saveImagePermanently(image);
        if (permanentFile != null) {
          profileImage.value = permanentFile;
        } else {
          Toast.errorToast('Failed to save image');
        }
      }
    } catch (e) {
      Toast.errorToast('Failed to pick image from gallery');
      print('Error picking image from gallery: $e');
    }
  }

  /// Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        // Save to permanent location to avoid cache clearing issues
        final permanentFile = await _saveImagePermanently(image);
        if (permanentFile != null) {
          profileImage.value = permanentFile;
        } else {
          Toast.errorToast('Failed to save image');
        }
      }
    } catch (e) {
      Toast.errorToast('Failed to take photo');
      print('Error taking photo: $e');
    }
  }

  /// Update owner profile
  Future<bool> updateOwnerProfile({
    required String phoneNumber,
    required String address,
    File? profilePicture,
  }) async {
    try {
      isUpdating.value = true;

      // Prepare form data
      final Map<String, String> fields = {
        'phoneNumber': phoneNumber,
        'address': address,
      };

      // Prepare files list
      final List<MultipartBody> files = [];
      if (profilePicture != null) {
        files.add(MultipartBody(key: 'profilePicture', file: profilePicture));
      }

      final response = await Get.find<NetworkHelper>().multipart(
        url: ApiUrl.updateOwnerProfile,
        method: HttpMethod.put.method,
        fields: fields,
        files: files,
        withAuth: true,
        parser: (data) => UpdateProfileResponseModel.fromJson(data),
      );

      isUpdating.value = false;

      return response.fold(
        (error) {
          Toast.errorToast(error.message ?? 'Failed to update profile');
          return false;
        },
        (data) async {
          Toast.successToast(data.message);
          // Clean up temporary image file
          await _cleanupTempImage();
          // Clear selected image reference
          profileImage.value = null;
          return true;
        },
      );
    } catch (e) {
      isUpdating.value = false;
      Toast.errorToast('Failed to update profile');
      print('Exception updating owner profile: $e');
      return false;
    }
  }

  /// Update provider profile
  Future<bool> updateProviderProfile({
    required String userName,
    required String phoneNumber,
    required String address,
    required String aboutMe,
    required String experience,
    File? profilePicture,
  }) async {
    try {
      isUpdating.value = true;

      // Prepare form data
      final Map<String, String> fields = {
        'userName': userName,
        'phoneNumber': phoneNumber,
        'address': address,
        'aboutMe': aboutMe,
        'experience': experience,
      };

      // Prepare files list
      final List<MultipartBody> files = [];
      if (profilePicture != null) {
        files.add(MultipartBody(key: 'profilePicture', file: profilePicture));
      }

      final response = await Get.find<NetworkHelper>().multipart(
        url: ApiUrl.updateProviderProfile,
        method: HttpMethod.put.method,
        fields: fields,
        files: files,
        withAuth: true,
        parser: (data) => UpdateProfileResponseModel.fromJson(data),
      );

      isUpdating.value = false;

      return response.fold(
        (error) {
          Toast.errorToast(error.message ?? 'Failed to update profile');
          return false;
        },
        (data) async {
          Toast.successToast(data.message);
          // Clean up temporary image file
          await _cleanupTempImage();
          // Clear selected image reference
          profileImage.value = null;
          return true;
        },
      );
    } catch (e) {
      isUpdating.value = false;
      Toast.errorToast('Failed to update profile');
      print('Exception updating provider profile: $e');
      return false;
    }
  }

  /// Unified update profile method
  Future<bool> updateProfile({String? role}) async {
    // Get user role from storage if not provided
    final userRole = role ?? AppStorageService.getUserRole();

    // Validate common fields
    if (phoneController.text.trim().isEmpty) {
      Toast.errorToast('Phone number is required');
      return false;
    }

    if (addressController.text.trim().isEmpty) {
      Toast.errorToast('Address is required');
      return false;
    }

    // Check if user is provider or owner and call appropriate method
    if (userRole == Role.provider.value) {
      // Validate provider-specific fields
      if (nameController.text.trim().isEmpty) {
        Toast.errorToast('User name is required');
        return false;
      }

      if (aboutMeController.text.trim().isEmpty) {
        Toast.errorToast('About me is required');
        return false;
      }

      if (selectedExperience.value.isEmpty) {
        Toast.errorToast('Please select your experience level');
        return false;
      }

      return await updateProviderProfile(
        userName: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        address: addressController.text.trim(),
        aboutMe: aboutMeController.text.trim(),
        experience: selectedExperience.value,
        profilePicture: profileImage.value,
      );
    } else {
      // Owner profile update
      return await updateOwnerProfile(
        phoneNumber: phoneController.text.trim(),
        address: addressController.text.trim(),
        profilePicture: profileImage.value,
      );
    }
  }

  /// Clear selected image
  void clearImage() {
    // Delete the temporary file if it exists
    if (profileImage.value != null && profileImage.value!.existsSync()) {
      try {
        profileImage.value!.deleteSync();
      } catch (e) {
        print('Error deleting temporary image: $e');
      }
    }
    profileImage.value = null;
  }

  /// Clean up temporary image after successful upload
  Future<void> _cleanupTempImage() async {
    if (profileImage.value != null && profileImage.value!.existsSync()) {
      try {
        await profileImage.value!.delete();
        print('Temporary image deleted successfully');
      } catch (e) {
        print('Error deleting temporary image: $e');
      }
    }
  }
}
