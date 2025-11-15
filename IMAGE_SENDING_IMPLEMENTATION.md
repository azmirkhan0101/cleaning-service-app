# Image Sending Implementation

## Overview

Added support for sending messages with image attachments using multipart form-data POST endpoint.

## API Endpoint

```
POST /messages/:userId
Content-Type: multipart/form-data

Form Fields:
- images: File[] (array of image files)
- text: String (message text)

Response:
{
  "data": {
    "_id": "string",
    "senderId": "string",
    "receiverId": "string",
    "text": "string",
    "image": ["url1", "url2", ...],
    "createdAt": "ISO8601",
    "isSeen": boolean
  }
}
```

## Changes Made

### 1. API URL Configuration

**File:** `lib/core/service/api_url.dart`

Added new endpoint:

```dart
static String sendMessage(String userId) => '$baseUrl/messages/$userId';
```

### 2. Chat Conversation Controller

**File:** `lib/features/inbox/controllers/chat_conversation_controller.dart`

**New Dependencies:**

- `dart:io` for File handling
- `image_picker` package

**New State Variables:**

```dart
final selectedImages = <File>[].obs;
```

**New Methods:**

- `pickImages()` - Opens image picker to select multiple images
- `removeImage(int index)` - Removes selected image from preview

**Updated Method:**

- `sendMessage()` - Now uses HTTP POST with multipart upload instead of socket emit
  - Accepts text and/or images
  - Sends via `NetworkHelper.multipart()`
  - Parses response and adds sent message to list
  - Clears input and selected images on success
  - Handles upload errors with user feedback

### 3. Conversation Screen UI

**File:** `lib/features/inbox/screens/conversation_screen.dart`

**Image Picker Integration:**

- Wired image icon button to `controller.pickImages()`

**Image Preview Display:**

- Added horizontal scrollable preview above input field
- Shows selected images with remove (X) button
- Auto-hides when no images selected
- Image display: 100x100 with rounded corners
- Remove button: positioned top-right with semi-transparent background

**Layout Changes:**

- Wrapped input Row in Column to accommodate preview
- Maintained responsive spacing with ScreenUtil

## User Flow

1. **Select Images:**
   - Tap image icon in input field
   - Select one or more images from gallery
   - Images appear in horizontal preview above input

2. **Review Selection:**
   - View thumbnail previews
   - Remove unwanted images by tapping X button

3. **Send Message:**
   - Type message text (optional if images selected)
   - Tap send button
   - Loading indicator appears during upload
   - Message appears in chat with image attachments

4. **View Sent Images:**
   - Sent messages display text + images
   - Images shown as 140x140 thumbnails
   - Tappable for full view (using existing `CustomNetworkImage`)

## Technical Details

### Multipart Upload

Uses existing `NetworkHelper.multipart()` method:

```dart
final files = selectedImages
    .map((file) => MultipartBody(key: 'images', file: file))
    .toList();

final result = await _network.multipart<Map<String, dynamic>>(
  url: ApiUrl.sendMessage(userId),
  method: 'POST',
  fields: text.isNotEmpty ? {'text': text} : null,
  files: files,
  parser: (data) => data as Map<String, dynamic>,
);
```

### Message Parsing

Existing `MessageModel.fromJson()` already supports:

- `image` field (array of URLs)
- Flexible timestamp parsing (`createdAt` or `timestamp`)
- Read status (`isSeen` or `isRead`)

### Error Handling

- Image picker errors: logged, user notified
- Upload errors: displayed in `errorMessage` observable
- Network errors: handled by `NetworkHelper` Either pattern

## Dependencies

All required packages already in `pubspec.yaml`:

- `image_picker: ^1.1.2` - Image selection
- `get: ^4.7.2` - State management
- Existing network/model infrastructure

## Testing Checklist

- [ ] Select single image
- [ ] Select multiple images
- [ ] Remove image from selection
- [ ] Send text only (should still work)
- [ ] Send images only
- [ ] Send text + images
- [ ] Verify upload progress indicator
- [ ] Check error handling for network failure
- [ ] Confirm images display in sent messages
- [ ] Verify image URLs load correctly
- [ ] Test on slow connection
- [ ] Verify message persistence after app restart

## Notes

- Image quality set to 80% to optimize upload size
- Preview limited to horizontal scroll (no max count enforced)
- Backend must handle multipart/form-data with `images` array key
- Response must include image URLs in `image` array field
- Socket events still used for real-time message delivery to receiver
