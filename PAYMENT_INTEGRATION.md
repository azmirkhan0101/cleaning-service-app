# Payment Integration Implementation

## Overview

Integrated Stripe payment flow for booking services. After successful booking creation, the system automatically creates a payment session and redirects users to a WebView for secure payment processing.

## Flow

1. **User fills booking form** (Step 1 & Step 2)
2. **User clicks "Continue to Payment"**
3. **System creates booking** via POST `/booking/book-now`
4. **System creates payment session** via POST `/payment/booking/create` with booking ID
5. **User is redirected to WebView** with Stripe checkout URL
6. **User completes payment** in WebView
7. **System handles payment result** (success/cancel)

## Changes Made

### 1. API Endpoints (`lib/core/service/api_url.dart`)

Added payment endpoint:

```dart
static const String createPayment = '$baseUrl/payment/booking/create';
```

### 2. Service Booking Controller (`lib/features/owner/service/controllers/service_booking_controller.dart`)

**Added fields:**

- `isCreatingPayment` - Loading state for payment creation
- `bookingId` - Stores created booking ID
- `paymentUrl` - Stores payment checkout URL

**Updated `bookService()` method:**

- Changed return type from `Future<bool>` to `Future<Map<String, dynamic>?>`
- Returns full booking response including booking ID
- Extracts and stores booking ID from response

**Added `createPaymentSession()` method:**

```dart
Future<Map<String, dynamic>?> createPaymentSession(String bookingId) async {
  // Creates payment session via API
  // Extracts and stores payment URL
  // Returns full payment response
}
```

### 3. Payment WebView Screen (`lib/features/payment/payment_webview_screen.dart`)

**New screen created** with the following features:

- Loads Stripe checkout URL in WebView
- Shows loading indicator while page loads
- Monitors navigation for success/cancel URLs
- Handles payment success:
  - Closes WebView
  - Shows success message
  - Navigates to home screen
- Handles payment cancel:
  - Closes WebView
  - Shows cancellation message
- Back button confirmation:
  - Shows dialog asking user to confirm cancellation
  - Prevents accidental payment abandonment

**Key methods:**

- `_initializeWebView()` - Configures WebView with navigation delegates
- `_handlePaymentSuccess()` - Processes successful payment
- `_handlePaymentCancel()` - Processes cancelled payment

### 4. App Routes (`lib/core/components/app_routes/app_routes.dart`)

Added route for Payment WebView:

```dart
static const String paymentWebViewScreen = "/PaymentWebViewScreen";

GetPage(
  name: paymentWebViewScreen,
  page: () => PaymentWebViewScreen(
    paymentUrl: Get.arguments['paymentUrl'] ?? '',
    bookingId: Get.arguments['bookingId'] ?? '',
  ),
),
```

### 5. Booking Step Two UI (`lib/features/owner/service/widgets/service_booking_step_two.dart`)

**Updated button logic:**

1. Shows loading state during booking creation
2. Shows "Creating Payment..." state during payment session creation
3. Handles full booking + payment flow:

```dart
- Create booking
  ├─ Success → Extract booking ID
  │   └─ Create payment session
  │       ├─ Success → Extract payment URL
  │       │   └─ Navigate to WebView
  │       └─ Failure → Show error message
  └─ Failure → Show error message
```

**Button states:**

- Normal: "Continue to Payment"
- Booking: Loading spinner
- Creating Payment: Loading spinner + "Creating Payment..." text

### 6. Error Handling

All steps include proper error handling:

- Invalid booking data → Show error snackbar
- Booking API failure → Show error message
- Missing booking ID → Show warning message
- Payment API failure → Show error message
- Missing payment URL → Show error message
- WebView loading error → Show error snackbar

## API Structure

### Booking Request

```json
POST /booking/book-now
{
  "serviceId": "...",
  "scheduledAt": "2025-11-29T07:30:00.000Z",
  "phoneNumber": "+1234567890",
  "address": {
    "city": "...",
    "latitude": 37.774899,
    "longitude": -122.419400
  },
  "description": "...",
  "serviceDuration": 4,
  "paymentMethod": "STRIPE"
}
```

### Booking Response

```json
{
  "success": true,
  "message": "Booking created successfully",
  "data": {
    "_id": "6915bb89e314fd88bd83bc71",
    ...
  }
}
```

### Payment Request

```json
POST /payment/booking/create
{
  "bookingId": "6915bb89e314fd88bd83bc71"
}
```

### Payment Response

```json
{
  "success": true,
  "message": "Payment session created successfully...",
  "data": {
    "sessionId": "cs_test_...",
    "paymentUrl": "https://checkout.stripe.com/c/pay/cs_test_...",
    "amount": 208.45
  }
}
```

## User Experience

1. User fills booking form with service details
2. Clicks "Continue to Payment" button
3. Sees "Service booked successfully!" message (green snackbar)
4. Brief loading state showing "Creating Payment..."
5. Automatically redirected to Stripe checkout page in WebView
6. Completes payment on Stripe's secure checkout
7. On success: Returns to app, sees success message, navigates to home
8. On cancel: Returns to booking screen with cancellation message

## Testing Checklist

- [ ] Fill valid booking form and submit
- [ ] Verify booking API is called correctly
- [ ] Verify booking success message appears
- [ ] Verify payment session API is called with booking ID
- [ ] Verify WebView opens with payment URL
- [ ] Test payment completion (success flow)
- [ ] Test payment cancellation
- [ ] Test back button during payment (should show confirmation dialog)
- [ ] Test network errors at each step
- [ ] Verify proper error messages for all failure scenarios

## Dependencies

The WebView functionality uses the `webview_flutter` package which is already included in the project's pubspec.yaml.

## Notes

- Payment URL detection for success/cancel is configured in `onNavigationRequest`
- Adjust URL patterns if your backend uses different success/cancel URLs
- WebView supports JavaScript mode for Stripe checkout
- All API calls include proper loading states and error handling
- User cannot accidentally abandon payment (confirmation dialog on back press)
