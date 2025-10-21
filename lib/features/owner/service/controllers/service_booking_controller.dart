import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceBookingController extends GetxController {
  final dateTimeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();

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
}
