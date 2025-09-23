import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerServiceController extends GetxController {
  // Observing the selected tab index
  var selectedIndex = 0.obs;

  // Function to update the tab index
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  RxList<String> tabNameList = [
    "Overview",
    "Details",
    "Review",
    "Schedule",
  ].obs;

  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setTime(TimeOfDay time) {
    selectedTime.value = time;
  }

}