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

  /// Validate and normalize a phone number to an E.164-like format.
  /// Returns normalized value (e.g., +880123456789) or null if invalid.
  String? validateAndNormalizePhone(String input) {
    String s = input.trim();
    // Remove common separators/spaces/parentheses
    s = s.replaceAll(RegExp(r"[\s\-\(\)]"), '');
    // Convert 00 prefix to +
    if (s.startsWith('00')) {
      s = '+${s.substring(2)}';
    }
    // Require leading +
    if (!s.startsWith('+')) {
      return null;
    }
    // E.164: + followed by 8-15 digits total, first digit 1-9
    final e164 = RegExp(r'^\+[1-9]\d{7,14}$');
    if (!e164.hasMatch(s)) {
      return null;
    }
    return s;
  }

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
        Get.snackbar('Error', 'Invalid date time format');
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
      final normalizedPhone =
          validateAndNormalizePhone(phoneNumberController.text) ??
          phoneNumberController.text.trim();

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
          return null;
        },
        (response) {
          debugPrint('Booking successful: $response');
          // New response shape includes bookingId, sessionId, paymentUrl
          final data = response['data'];
          if (data is Map<String, dynamic>) {
            bookingId.value = (data['bookingId'] ?? data['_id'] ?? '')
                .toString();
            sessionId.value = (data['sessionId'] ?? '').toString();
            paymentUrl.value = (data['paymentUrl'] ?? '').toString();
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
