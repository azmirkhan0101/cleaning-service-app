# Quick Testing Guide - Profile Update APIs

## API Endpoints Summary

### Owner Profile Update

```
POST {{BaseURL}}/profile/owner

Form-Data:
- profilePicture: File (optional)
- phoneNumber: Text (required)
- address: Text (required)
```

### Provider Profile Update

```
POST {{BaseURL}}/profile/provider

Form-Data:
- profilePicture: File (optional)
- userName: Text (required)
- phoneNumber: Text (required)
- address: Text (required)
- aboutMe: Text (required)
- experience: Text (required - values: "0-1", "1-5", "+5")
```

## Implementation Status

✅ **API URL Configuration**

- Added `updateProviderProfile` endpoint in `api_url.dart`

✅ **Model Updates**

- Updated `UpdatedProfileData` to support `aboutMe` and `experience` fields

✅ **Controller Methods**

- `updateOwnerProfile()` - Handles owner profile updates
- `updateProviderProfile()` - Handles provider profile updates
- `updateProfile()` - Unified method with role detection and validation

✅ **UI Integration**

- Save button calls `updateProfile()`
- Automatic role detection
- Field validation before API call
- Loading state handling
- Success/error toast messages
- Profile refresh on success
- Auto-navigation back on success

## Testing Checklist

### As Owner

- [ ] Phone number is required
- [ ] Address is required
- [ ] Profile picture is optional
- [ ] Update without image
- [ ] Update with new image
- [ ] Validation errors show correctly
- [ ] Success toast shows
- [ ] Profile refreshes
- [ ] Screen closes on success

### As Provider

- [ ] User name is required
- [ ] Phone number is required
- [ ] Address is required
- [ ] About me is required
- [ ] Experience is required
- [ ] Profile picture is optional
- [ ] Update without image
- [ ] Update with new image
- [ ] All validation errors show
- [ ] Success toast shows
- [ ] Profile refreshes
- [ ] Screen closes on success

## Field Mapping

### Owner

```
UI Field          → API Parameter
─────────────────────────────────
Phone Number     → phoneNumber
Address          → address
Profile Image    → profilePicture
```

### Provider

```
UI Field          → API Parameter
─────────────────────────────────
Your Name        → userName
Phone Number     → phoneNumber
Address          → address
About Me         → aboutMe
Experience       → experience
Profile Image    → profilePicture
```

## Experience Values

The experience field accepts these exact values:

- `"0-1"` - for 0-1 years
- `"1-5"` - for 1-5 years
- `"+5"` - for more than 5 years

## Code Flow

1. User taps "SAVE" button
2. `updateProfile()` is called
3. User role is detected from storage
4. Common validations run (phone, address)
5. Role-specific validations run
6. Appropriate API method is called
7. Response is handled
8. On success: toast → refresh profile → close screen
9. On failure: show error toast

## Notes

- Both APIs use **POST** method (not PUT)
- Multipart form-data is used for file upload
- Authentication token is automatically included
- Profile image is optional in both cases
- All text fields are trimmed before sending
- Empty experience selection is caught by validation
