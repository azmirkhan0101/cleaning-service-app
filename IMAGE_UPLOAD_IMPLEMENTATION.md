# Image Upload Implementation

## Overview

Added image upload functionality to the profile photo upload section with support for both camera and gallery options.

## Changes Made

### 1. Controller Updates (`lib/features/auth/controllers/selection_controller.dart`)

- Added `image_picker` package import
- Added `profileImage` reactive variable to store selected image
- Implemented `pickImageFromGallery()` method
- Implemented `pickImageFromCamera()` method
- Implemented `showImageSourceSelection()` to display bottom sheet with camera/gallery options

### 2. UI Updates (`lib/features/auth/widgets/upload_your_photo_section.dart`)

- Made the circular avatar container tappable using `GestureDetector`
- Used `Obx` widget for reactive updates when image is selected
- Display selected image using `ClipOval` and `Image.file`
- Show add icon when no image is selected

### 3. Android Permissions (`android/app/src/main/AndroidManifest.xml`)

Added required permissions:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
```

### 4. iOS Permissions (`ios/Runner/Info.plist`)

Added usage descriptions:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to your camera to take profile photos.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to your photo library to select profile photos.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs access to save photos to your photo library.</string>
```

## Features

### User Interaction

1. Tap on the circular avatar
2. Bottom sheet appears with two options:
   - **Choose from Gallery**: Opens device gallery to select existing photo
   - **Take a Photo**: Opens camera to capture new photo
3. Selected/captured image is displayed in the circular avatar
4. Image quality is optimized to 80% for better performance

### Error Handling

- Try-catch blocks handle errors during image selection
- User-friendly error messages displayed via snackbar

## Usage

The image can be accessed from the controller:

```dart
final selectionController = Get.find<SelectionController>();
File? image = selectionController.profileImage.value;
```

## Dependencies

- `image_picker: ^1.1.2` (already included in pubspec.yaml)
- `get: ^4.7.2` (already included in pubspec.yaml)

## Testing

1. Run the app on a physical device or emulator with camera support
2. Navigate to the upload photo screen
3. Tap the circular avatar
4. Test both gallery and camera options
5. Verify the selected image is displayed correctly

## Notes

- Image quality is set to 80% to balance quality and file size
- The image is stored as a File object in memory
- For production, you may want to:
  - Implement image compression
  - Add image cropping functionality
  - Upload the image to a backend server
  - Store the image path in persistent storage
