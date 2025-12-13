import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
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

  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;

  var unAvailableSlots = <TimeOfDay>[
    TimeOfDay(hour: 22, minute: 00),
    TimeOfDay(hour: 22, minute: 30),
    TimeOfDay(hour: 23, minute: 00),
    TimeOfDay(hour: 23, minute: 30),
    TimeOfDay(hour: 24, minute: 00),
    TimeOfDay(hour: 24, minute: 30),
    TimeOfDay(hour: 0, minute: 00),
    TimeOfDay(hour: 0, minute: 30),
    TimeOfDay(hour: 1, minute: 00),
    TimeOfDay(hour: 1, minute: 30),
    TimeOfDay(hour: 2, minute: 00),
    TimeOfDay(hour: 2, minute: 30),
    TimeOfDay(hour: 3, minute: 00),
    TimeOfDay(hour: 3, minute: 30),
    TimeOfDay(hour: 4, minute: 00),
    TimeOfDay(hour: 4, minute: 30),
    TimeOfDay(hour: 5, minute: 00),
    TimeOfDay(hour: 5, minute: 30),
    TimeOfDay(hour: 6, minute: 00),
    TimeOfDay(hour: 6, minute: 30),
    TimeOfDay(hour: 7, minute: 00),
    TimeOfDay(hour: 7, minute: 30),
    TimeOfDay(hour: 8, minute: 00),
  ].obs;

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  void setSelectedTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  void setDateTimeController() {
    String formattedDate =
        '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')} ${selectedTime.value.hour}:${(selectedTime.value.minute).toString().padLeft(2, '0')}';
    dateTimeController.text = formattedDate;
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

  // print first step info
  void printStepOneInfo() {
    debugPrint('=== DateTime: ${dateTimeController.text} ===');
    debugPrint('=== Phone: ${phoneNumberController.text} ===');
    debugPrint('=== Address: ${addressController.text} ===');
    debugPrint('=== Description: ${descriptionController.text} ===');
    debugPrint('=== Duration: ${durationController.text} ===');
    debugPrint('=== Latitude: ${selectedLatitude.value} ===');
    debugPrint('=== Longitude: ${selectedLongitude.value} ===');
  }

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

      // Parse scheduledAt from dateTimeController
      // Format: "2025-11-12 16:30"
      final dateTimeParts = dateTimeController.text.split(' ');
      if (dateTimeParts.length != 2) {
        Toast.errorToast('Invalid date time format');
        return null;
      }

      final dateParts = dateTimeParts[0].split('-');
      final timeParts = dateTimeParts[1].split(':');

      final scheduledDateTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      // Ensure phone number is normalized; fallback to raw if already validated earlier
      final normalizedPhone = phoneNumberController.text.trim();

      final body = {
        'serviceId': serviceId.value,
        'scheduledAt': scheduledDateTime.toUtc().toIso8601String(),
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
