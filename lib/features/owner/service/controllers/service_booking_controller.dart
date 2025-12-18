import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceBookingController extends GetxController {
  final _networkHelper = Get.find<NetworkHelper>();

  final isBooking = false.obs;
  final isCreatingPayment = false.obs;
  final selectedPaymentMethod = 'STRIPE'.obs;
  final bookingId = ''.obs;
  final paymentUrl = ''.obs;
  final sessionId = ''.obs;
  final dateTimeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();

  RxInt currentStep = 1.obs;

  // IDs and coordinates
  final serviceId = ''.obs;
  final selectedLatitude = 0.0.obs;
  final selectedLongitude = 0.0.obs;
  var selectedTimeString = ''.obs;
  var selectedDateString = ''.obs;

  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;



  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    selectedDateString.value = _formatDate(date);
  }

  void setSelectedTime(TimeOfDay time) {
    selectedTime.value = time;
    selectedTimeString.value = _formatTime(time);
  }

  void setDateTimeController() {
    final formattedDate = _formatDate(selectedDate.value);
    final formattedTime = _formatTime(selectedTime.value);

    // Keep the display field in sync with the API payload
    selectedDateString.value = formattedDate;
    selectedTimeString.value = formattedTime;

    dateTimeController.text = '$formattedDate $formattedTime';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void setServiceId(String id) {
    serviceId.value = id;
  }

  void setSelectedAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) {
    addressController.text = address;
    selectedLatitude.value = latitude;
    selectedLongitude.value = longitude;
  }

  // // print first step info
  // void printStepOneInfo() {
  //   debugPrint('=== DateTime: ${dateTimeController.text} ===');
  //   debugPrint('=== Phone: ${phoneNumberController.text} ===');
  //   debugPrint('=== Address: ${addressController.text} ===');
  //   debugPrint('=== Description: ${descriptionController.text} ===');
  //   debugPrint('=== Duration: ${durationController.text} ===');
  //   debugPrint('=== Latitude: ${selectedLatitude.value} ===');
  //   debugPrint('=== Longitude: ${selectedLongitude.value} ===');
  // }

  void clearControllers() {
    dateTimeController.clear();
    phoneNumberController.clear();
    addressController.clear();
    descriptionController.clear();
    durationController.clear();
  }

  // Phone normalization/validation is now handled by PhoneInputField.
  // Keep only the controller value set via widget callback.

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  /// Book service API call
  Future<Map<String, dynamic>?> bookService() async {
    if (isBooking.value) return null;

    try {
      isBooking.value = true;

      // Ensure phone number is normalized; fallback to raw if already validated earlier
      final normalizedPhone = phoneNumberController.text.trim();

      final scheduledDate = selectedDateString.value.isNotEmpty
          ? selectedDateString.value
          : _formatDate(selectedDate.value);
      final scheduledTime = selectedTimeString.value.isNotEmpty
          ? selectedTimeString.value
          : _formatTime(selectedTime.value);

      final body = {
        'serviceId': serviceId.value,
        'scheduledTime': scheduledTime,
        'scheduledDate': scheduledDate,
        'phoneNumber': normalizedPhone,
        'address': {
          'city': addressController.text,
          'latitude': selectedLatitude.value,
          'longitude': selectedLongitude.value,
        },
        'description': descriptionController.text,
        'serviceDuration': int.tryParse(durationController.text) ?? 2,
        'paymentMethod': selectedPaymentMethod.value,
      };

      final result = await _networkHelper.request<Map<String, dynamic>>(
        'POST',
        ApiUrl.bookNow,
        body: body,
        parser: (data) => data as Map<String, dynamic>,
      );

      return result.fold(
        (error) {
          debugPrint('Booking error: ${error.message}');
          // Return error details for conflict detection
          return {
            'success': false,
            'message': error.message,
            'statusCode': error.statusCode,
          };
        },
        (response) {
          debugPrint('=== BOOKING RESPONSE ===');
          debugPrint('Full response: $response');
          debugPrint('Response type: ${response.runtimeType}');
          debugPrint('Response keys: ${response.keys}');

          // New response shape includes bookingId, sessionId, paymentUrl
          final data = response['data'];
          debugPrint('Data: $data');
          debugPrint('Data type: ${data.runtimeType}');

          if (data is Map<String, dynamic>) {
            debugPrint('Data keys: ${data.keys}');
            debugPrint('bookingId: ${data['bookingId']}');
            debugPrint('_id: ${data['_id']}');
            debugPrint('sessionId: ${data['sessionId']}');
            debugPrint('paymentUrl: ${data['paymentUrl']}');

            bookingId.value = (data['bookingId'] ?? data['_id'] ?? '')
                .toString();
            sessionId.value = (data['sessionId'] ?? '').toString();
            paymentUrl.value = (data['paymentUrl'] ?? '').toString();

            debugPrint('=== EXTRACTED VALUES ===');
            debugPrint('bookingId.value: ${bookingId.value}');
            debugPrint('sessionId.value: ${sessionId.value}');
            debugPrint('paymentUrl.value: ${paymentUrl.value}');
          }
          return response;
        },
      );
    } catch (e) {
      debugPrint('Error booking service: $e');
      return null;
    } finally {
      isBooking.value = false;
    }
  }

  /// Create payment session for booking
  Future<Map<String, dynamic>?> createPaymentSession(String bookingId) async {
    if (isCreatingPayment.value) return null;

    try {
      isCreatingPayment.value = true;

      final body = {'bookingId': bookingId};

      final result = await _networkHelper.request<Map<String, dynamic>>(
        'POST',
        ApiUrl.createPayment,
        body: body,
        parser: (data) => data as Map<String, dynamic>,
      );

      return result.fold(
        (error) {
          debugPrint('Payment creation error: ${error.message}');
          return null;
        },
        (response) {
          debugPrint('Payment session created: $response');
          // Extract payment URL from response
          if (response['data'] != null &&
              response['data']['paymentUrl'] != null) {
            paymentUrl.value = response['data']['paymentUrl'];
          }
          return response;
        },
      );
    } catch (e) {
      debugPrint('Error creating payment session: $e');
      return null;
    } finally {
      isCreatingPayment.value = false;
    }
  }
}
