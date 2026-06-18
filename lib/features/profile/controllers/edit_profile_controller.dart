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

  double? selectedLatitude;
  double? selectedLongitude;

  List<String> experienceLevels = ['0-1', '1-5', '+5'];
  RxString selectedExperience = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);

  // Image picker
  final ImagePicker _picker = ImagePicker();
  Rx<File?> profileImage = Rx<File?>(null);

  void setSelectedAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) {
    addressController.text = address;
    selectedLatitude = latitude;
    selectedLongitude = longitude;
  }

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
    }
  }

  /// Update owner profile
  Future<bool> updateOwnerProfile(
    //   {
    //   required String phoneNumber,
    //   required String address,
    //   File? profilePicture,
    // }
  ) async {
    try {
      isUpdating.value = true;

      // Prepare form data
      final Map<String, String> fields = {
        'userName': nameController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'lattitude': selectedLatitude?.toString() ?? '',
        'longitude': selectedLongitude?.toString() ?? '',
        'aboutMe': aboutMeController.text.trim(),
        // 'experience': selectedExperience.value,
      };

      // Prepare files list
      final List<MultipartBody> files = [];
      if (profileImage.value != null) {
        files.add(
          MultipartBody(key: 'profilePicture', file: profileImage.value!),
        );
      }

      final response = await Get.find<NetworkHelper>().multipart(
        url: ApiUrl.updateOwnerProfile,
        method: HttpRequestType.put.method,
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
      return false;
    }
  }

  /// Update provider profile
  Future<bool> updateProviderProfile() async {
    try {
      isUpdating.value = true;

      // Prepare form data
      final Map<String, String> fields = {
        'userName': nameController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'lattitude': selectedLatitude?.toString() ?? '',
        'longitude': selectedLongitude?.toString() ?? '',
        'aboutMe': aboutMeController.text.trim(),
        'experience': selectedExperience.value,
      };

      // Prepare files list
      final List<MultipartBody> files = [];
      if (profileImage.value != null) {
        files.add(
          MultipartBody(key: 'profilePicture', file: profileImage.value!),
        );
      }

      final response = await Get.find<NetworkHelper>().multipart(
        url: ApiUrl.updateProviderProfile,
        method: HttpRequestType.put.method,
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

      return await updateProviderProfile();
    } else {
      // Owner profile update
      return await updateOwnerProfile();
    }
  }

  /// Clear selected image
  void clearImage() {
    // Delete the temporary file if it exists
    if (profileImage.value != null && profileImage.value!.existsSync()) {
      try {
        profileImage.value!.deleteSync();
      } catch (_) {
      }
    }
    profileImage.value = null;
  }

  /// Clean up temporary image after successful upload
  Future<void> _cleanupTempImage() async {
    if (profileImage.value != null && profileImage.value!.existsSync()) {
      try {
        await profileImage.value!.delete();
      } catch (_) {
      }
    }
  }
}
