import 'dart:io';

import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SelectionController extends GetxController {
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
    selectedRole.value = type;
  }

  // Pick image from gallery
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
      Get.snackbar(
        'Error',
        'Failed to pick image from gallery',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Pick image from camera
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
      Get.snackbar(
        'Error',
        'Failed to take photo',
        snackPosition: SnackPosition.BOTTOM,
      );
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
                Get.back();
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
                Get.back();
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
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        onImagePicked(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
      );
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
                Get.back();
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
                Get.back();
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

  /// owner or provider type option
  RxBool typeModeStatues = false.obs;

  RxInt currentIndex = 0.obs;

  /// location text field
  Rx<TextEditingController> locationController = TextEditingController().obs;

  Rx<TextEditingController> loginEmailController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  /// plan selection (0: Free, 1: Silver, 2: Gold, 3: Platinum)
  RxInt typPaymentStatues = 0.obs;

  final Map<String, dynamic> data = {
    "email": "alif6@gmail.com",
    "lattitude": "40.7128",
    "longitude": "-74.0600",
    "resultRange": "25",
    "plan": "BASIC",
    "role": "OWNER",
    "affiliationCondition": "true",
  };
}
