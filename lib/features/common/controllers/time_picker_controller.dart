import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimePickerController extends GetxController {
  var selectedDate = Rxn<DateTime>();

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  var selectedTime = Rx<TimeOfDay?>(null);

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selectedTime.value = picked;
    }
  }
}
