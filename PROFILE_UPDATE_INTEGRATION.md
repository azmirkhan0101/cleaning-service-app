# Profile Update API Integration

## Overview

This document describes the integration of profile update APIs for both Owner and Provider roles in the cleaning service app.

## API Endpoints

### 1. Owner Profile Update

**Endpoint:** `POST {{BaseURL}}/profile/owner`

**Form Data:**

- `profilePicture`: File (optional)
- `phoneNumber`: Text (required)
- `address`: Text (required)

### 2. Provider Profile Update

**Endpoint:** `POST {{BaseURL}}/profile/provider`

**Form Data:**

- `profilePicture`: File (optional)
- `userName`: Text (required)
- `phoneNumber`: Text (required)
- `address`: Text (required)
- `aboutMe`: Text (required)
- `experience`: Text (required - format: "0-1", "1-5", or "+5")

## Implementation Details

### 1. API URL Configuration

**File:** `lib/core/service/api_url.dart`

Added the provider profile update endpoint:

```dart
static const String updateOwnerProfile = '$baseUrl/profile/owner';
static const String updateProviderProfile = '$baseUrl/profile/provider';
```

### 2. Profile Model Updates

**File:** `lib/features/profile/models/profile_model.dart`

Updated `UpdatedProfileData` class to support provider-specific fields:

```dart
class UpdatedProfileData {
  final String id;
  final String profilePicture;
  final String userName;
  final String phoneNumber;
  final String address;
  final String? aboutMe;        // Provider only
  final String? experience;     // Provider only
  
  // ... constructor and fromJson method
}
```

### 3. Edit Profile Controller

**File:** `lib/features/profile/controllers/edit_profile_controller.dart`

#### Methods Added

1. **`updateOwnerProfile()`** - Updates owner profile
   - Fields: phoneNumber, address, profilePicture (optional)
   - Endpoint: POST `/profile/owner`

2. **`updateProviderProfile()`** - Updates provider profile
   - Fields: userName, phoneNumber, address, aboutMe, experience, profilePicture (optional)
   - Endpoint: POST `/profile/provider`

3. **`updateProfile()`** - Unified method that:
   - Detects user role from storage
   - Validates required fields based on role
   - Calls appropriate update method (owner or provider)
   - Shows validation error toasts
   - Returns success/failure boolean

#### Validation Logic

**Common (Both Roles):**

- Phone number (required)
- Address (required)

**Provider Only:**

- User name (required)
- About me (required)
- Experience level (required - must be selected)

### 4. Edit Profile Screen

**File:** `lib/features/profile/screens/edit_profile_screen.dart`

#### Changes

1. **Updated Save Button:**
   - Calls `editProfileController.updateProfile()`
   - Shows loading state during update
   - Refreshes profile data on success
   - Navigates back on success

2. **Form Fields:**
   - All fields are already present in the UI
   - Phone number field
   - Address field
   - User name field
   - About me field (provider only)
   - Experience selection (provider only)
   - Profile picture picker

## Usage Flow

1. User opens Edit Profile screen
2. Profile data is pre-filled from current profile
3. User modifies fields and/or selects new profile picture
4. User taps "SAVE" button
5. Controller validates fields based on user role
6. Appropriate API is called (owner or provider)
7. On success:
   - Toast message shown
   - Profile data refreshed
   - Screen closes
8. On failure:
   - Error toast shown
   - User stays on screen

## Testing

### Owner Profile Update

1. Login as an owner
2. Navigate to Edit Profile
3. Update phone number and address
4. Optionally select a profile picture
5. Tap SAVE
6. Verify profile updates successfully

### Provider Profile Update

1. Login as a provider
2. Navigate to Edit Profile
3. Update all fields:
   - User name
   - Phone number
   - Address
   - About me
   - Experience level
4. Optionally select a profile picture
5. Tap SAVE
6. Verify profile updates successfully

## Error Handling

- Network errors: Shown via error toast
- Validation errors: Shown via error toast with specific message
- File upload errors: Handled gracefully
- Backend errors: Displayed from API response message

## Notes

- Both APIs use POST method with multipart/form-data
- Profile picture is optional in both cases
- Experience field accepts: "0-1", "1-5", "+5"
- The unified `updateProfile()` method automatically detects user role
- Success messages come from the API response
- Profile data is automatically refreshed after successful update
