import 'dart:io';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/auth/models/profile_setup_response_model.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/ToastMsg/toast.dart';

class ProfileSetupController extends GetxController {
  RxString email = ''.obs;
  RxString errorMessage = ''.obs;
  Rx<ProfileSetupResponseModel?> profileSetupResponse =
      Rx<ProfileSetupResponseModel?>(null);

  RxBool isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure LocationController is available for location search widget
    if (!Get.isRegistered<LocationController>()) {
      Get.put(LocationController(), permanent: true);
    }
  }

  Future<bool> completeRegistrationSetup({String? plan}) async {
    isUploading.value = true;

    // Prepare fields as strings for multipart
    final Map<String, String> fields = {
      'email': email.value,
      'lattitude': latitude.value,
      'longitude': longitude.value,
      'role': selectedRole.value.value,
      "address": address.value,
      'affiliationCondition': 'true',
    };

    if (selectedRole.value == Role.provider) {
      fields['experience'] = experience.value;
      // fields['experience'] = "0-2";
    }
    if (selectedRole.value == Role.owner) {
      fields['resultRange'] = resultRange.value.toString();
    }
    if (plan != null && plan.isNotEmpty) {
      fields['plan'] = plan;
    }

    final List<MultipartBody> files = [
      MultipartBody(key: "profilePicture", file: profileImage.value!),
      MultipartBody(key: "NIDFront", file: frontIdImage.value!),
      MultipartBody(key: "NIDBack", file: backIdImage.value!),
    ];

    // if (selfieWithIdImage.value != null) {
    //   files.add(
    //     MultipartBody(key: "selfieWithNID", file: selfieWithIdImage.value!),
    //   );
    // }

    try {
      final response = await Get.find<NetworkHelper>().multipart(
        url: ApiUrl.completeRegistration,
        method: "POST",
        fields: fields,
        files: files,
        withAuth: false,
        parser: (data) {
          return ProfileSetupResponseModel.fromJson(data);
        },
      );

      isUploading.value = false;

      return response.fold(
        (error) {
          // Log error and return false
          errorMessage.value = error.message ?? 'Upload failed';
          return false;
        },
        (data) {
          // success
          profileSetupResponse.value = data;
          errorMessage.value = '';
          resetState();
          return true;
        },
      );
    } catch (e) {
      isUploading.value = false;
      errorMessage.value = e.toString();
      return false;
    }
  }

  /// Reset controller state
  void resetState() {
    errorMessage.value = '';
    profileSetupResponse.value = null;
    profileImage.value = null;
    frontIdImage.value = null;
    backIdImage.value = null;
    selfieWithIdImage.value = null;
    latitude.value = '';
    longitude.value = '';
    resultRange.value = 25.0;
    experience.value = '';
    currentIndex.value = 0;
    selectedRole.value = Role.owner;
    locationController.value.text = '';
    address.value = "";
  }


  //##############################################################################
  RxInt currentIndex = 0.obs;

  /// location text field
  Rx<TextEditingController> locationController = TextEditingController().obs;

  Rx<TextEditingController> loginEmailController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<Role> selectedRole = Role.owner.obs;
  RxString address = ''.obs;
  RxString latitude = ''.obs;
  RxString longitude = ''.obs;
  RxDouble resultRange = 25.0.obs;
  RxString experience = ''.obs;

  // Image picker
  final ImagePicker _picker = ImagePicker();
  Rx<File?> profileImage = Rx<File?>(null);

  // Document images
  Rx<File?> frontIdImage = Rx<File?>(null);
  Rx<File?> backIdImage = Rx<File?>(null);
  Rx<File?> selfieWithIdImage = Rx<File?>(null);

  void changeType(Role type) {
    experience.value = '';
    selectedRole.value = type;
  }

  void setupExperience(String exp) {
    if (experience.value == exp) {
      experience.value = '';
    } else {
      experience.value = exp;
    }
  }

  Future<File?> _compressImage(File file, {int quality = 60}) async {
    debugPrint("Compression starteddddddddddddddddd");
    try {
      final dir = await getApplicationDocumentsDirectory();
      final outPath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: quality,
        minWidth: 1024,
        minHeight: 1024,
        format: CompressFormat.jpeg,
      );

      if ( result == null ) {
        debugPrint('Compression failed or file not created');
        return file;
      }

      debugPrint("Compression doneeeeeeeeeeeee");

      final compressedSize = await result.length();

      if (compressedSize > 2 * 1024 * 1024 && quality > 30) {
        debugPrint("Compression againnnnnnnnnnnnnnnnnnnnnnnnnnn");
        return await _compressImage(
          File(result.path),
          quality: quality - 20,
        );
      }

      return File(result.path);
    } catch (e, s) {
      debugPrint('Compression error: $e');
      debugPrintStack(stackTrace: s);
      return file;
    }
  }


  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final file = File(image.path);
        final originalSize = await file.length();
        debugPrint(
          'Original gallery image: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB',
        );

        // Compress image
        final compressedFile = await _compressImage(file, quality: 70);
        profileImage.value = compressedFile;
      }
    } catch (e) {
      Toast.errorToast('Failed to pick image from gallery');
    }
  }

  // Pick image from camera with aggressive compression
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        final file = File(image.path);
        final originalSize = await file.length();
        debugPrint(
          'Original camera image: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB',
        );

        // Compress image with lower quality for camera photos
        final compressedFile = await _compressImage(file, quality: 50);
        profileImage.value = compressedFile;
      }
    } catch (e) {
      Toast.errorToast('Failed to take photo');
    }
  }

  // Show image source selection bottom sheet
  void showImageSourceSelection(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF1B2D51),
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                pickImageFromGallery();
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              leading: const Icon(Icons.camera_alt, color: Color(0xFF1B2D51)),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.of(context).pop();
                pickImageFromCamera();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Document upload methods
  Future<void> pickDocumentImage(
      ImageSource source,
      Function(File) onImagePicked,
      ) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final file = File(image.path);
        final originalSize = await file.length();
        debugPrint(
          'Original ${source == ImageSource.camera ? "camera" : "gallery"} document: '
              '${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB',
        );

        // Compress with source-specific quality
        final quality = source == ImageSource.camera ? 50 : 70;
        final compressedFile = await _compressImage(file, quality: quality);
        onImagePicked(compressedFile!);
      }
    } catch (e) {
      Toast.errorToast('Failed to pick image');
    }
  }

  void showDocumentSourceSelection(
      BuildContext context,
      String documentType,
      Function(File) onImagePicked,
      ) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Upload $documentType',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B2D51),
                ),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF1B2D51),
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                pickDocumentImage(ImageSource.gallery, onImagePicked);
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              leading: const Icon(Icons.camera_alt, color: Color(0xFF1B2D51)),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.of(context).pop();
                pickDocumentImage(ImageSource.camera, onImagePicked);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// Show camera only option for selfie
  void showSelfieSourceSelection(
      BuildContext context,
      String documentType,
      Function(File) onImagePicked,
      ) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Take $documentType',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B2D51),
                ),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              leading: const Icon(Icons.camera_alt, color: Color(0xFF1B2D51)),
              title: const Text('Take a Selfie'),
              onTap: () {
                Navigator.of(context).pop();
                pickDocumentImage(ImageSource.camera, onImagePicked);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

/// plan selection (0: Free, 1: Silver, 2: Gold, 3: Platinum)
// RxInt typPaymentStatues = 1000.obs;
  //##############################################################################
}
