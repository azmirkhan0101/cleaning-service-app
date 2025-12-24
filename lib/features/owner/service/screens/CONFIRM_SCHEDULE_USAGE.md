/// USAGE EXAMPLE: How to navigate to ConfirmScheduleScreen
/// 
/// To use the new Confirm Schedule Screen in your app, follow these steps:
/// 
/// 1. Import the screen:
/// ```dart
/// import 'package:cleaning_service_app/features/owner/service/screens/confirm_schedule_screen.dart';
/// ```
/// 
/// 2. Navigate to the screen with provider ID:
/// ```dart
/// // Example: From a service details screen or provider profile
/// final result = await Get.to(() => ConfirmScheduleScreen(
///   providerId: '691ae8f1029b585129ecf6f1', // Replace with actual provider ID
///   serviceId: 'optional-service-id', // Optional parameter
/// ));
/// 
/// // Handle the returned data
/// if (result != null) {
///   final selectedDate = result['date'] as DateTime?;
///   final selectedTimeSlots = result['timeSlots'] as List<String>;
///   final duration = result['duration'] as double;
///   
///   print('Selected Date: $selectedDate');
///   print('Selected Time Slots: $selectedTimeSlots');
///   print('Total Duration: $duration hours');
/// }
/// ```
/// 
/// 3. The screen will:
///    - Display a calendar for date selection (only current and future dates)
///    - Automatically fetch available time slots when a date is selected
///    - Show time slots in a 3-column grid layout
///    - Allow users to select multiple time slots (minimum 2 for 1 hour)
///    - Highlight selected slots in orange
///    - Disable unavailable slots (shown in gray)
///    - Return selected data when "Book Your Schedule" is tapped
/// 
/// IMPORTANT NOTES:
/// - Users can only select dates from today onwards (no past dates)
/// - Only slots with available=true can be selected
/// - Minimum booking requirement is 1 hour (2 slots of 30 minutes each)
/// - The API endpoint used is: GET /service/provider/available-slots/{providerId}?date={YYYY-MM-DD}
/// - The controller automatically manages state and API calls
/// - When user taps "Book Your Schedule", the screen returns the selected data and closes

/// Example integration in a button:
/// ```dart
/// ElevatedButton(
///   onPressed: () async {
///     final result = await Get.to(() => ConfirmScheduleScreen(
///       providerId: providerController.providerId.value,
///     ));
///     
///     if (result != null) {
///       // Use the selected data for booking
///       bookingController.setSchedule(
///         date: result['date'],
///         timeSlots: result['timeSlots'],
///       );
///     }
///   },
///   child: Text('Select Schedule'),
/// )
/// ```
