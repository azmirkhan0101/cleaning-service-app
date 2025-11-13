import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceBookingController extends GetxController {
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
}
