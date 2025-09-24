
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';


class OwnerController extends GetxController {


  RxInt sliderCurrentIndex = 0.obs;


  // Rx variable to hold the selected index
  var selectedIndex = 0.obs;


  // Function to update selected index
  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  // List of services (this can be dynamic, or fetched from an API)
  final RxList<String> categoryName = [
    'All Service',
    'Cleaning',
    'Laundry',
    'Home Care',
  ].obs;
}