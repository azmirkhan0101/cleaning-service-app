import 'dart:io';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/profile/models/profile_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  // Observable profile data
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString errorMessage = ''.obs;

  // Image picker
  final ImagePicker _picker = ImagePicker();
  Rx<File?> profileImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// Fetch user profile from API
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await Get.find<NetworkHelper>()
          .request<ProfileResponseModel>(
            HttpMethod.get.method,
            ApiUrl.profile,
            withAuth: true,
            parser: (data) => ProfileResponseModel.fromJson(data),
          );

      isLoading.value = false;

      response.fold(
        (error) {
          // Handle error
          errorMessage.value = error.message ?? 'Failed to load profile';
          print('Error fetching profile: ${error.message}');
          Get.snackbar(
            'Error',
            error.message ?? 'Failed to load profile',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (data) {
          // Parse response
          profile.value = data.data;
        },
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load profile';
      print('Exception fetching profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        profileImage.value = File(image.path);
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
        profileImage.value = File(image.path);
      }
    } catch (e) {
      Toast.errorToast('Failed to take photo');
    }
  }

  /// Update owner profile
  Future<bool> updateProfile({
    required String userName,
    required String phoneNumber,
    required String address,
    File? profilePicture,
  }) async {
    try {
      isUpdating.value = true;

      // Prepare form data
      final Map<String, String> fields = {
        'userName': userName,
        'phoneNumber': phoneNumber,
        'address': address,
      };

      // Prepare files list
      final List<MultipartBody> files = [];
      if (profilePicture != null) {
        files.add(MultipartBody(key: 'profilePicture', file: profilePicture));
      }

      final response = await Get.find<NetworkHelper>()
          .multipart<UpdateProfileResponseModel>(
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
        (data) {
          Toast.successToast(data.message);
          // Refresh profile data
          fetchProfile();
          // Clear selected image
          profileImage.value = null;
          return true;
        },
      );
    } catch (e) {
      isUpdating.value = false;
      Toast.errorToast('Failed to update profile');
      print('Exception updating profile: $e');
      return false;
    }
  }

  /// Clear selected image
  void clearImage() {
    profileImage.value = null;
  }
}
