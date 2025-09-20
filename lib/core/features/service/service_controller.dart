import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceController  extends GetxController {

  /// Can owner book directly without approval?
  RxBool typeModeStatues= false.obs;


  RxBool genderType= false.obs;


  // Define an observable variable to store the selected value
  RxString selectedCountry = ''.obs;

  // You can also initialize the selectedCountry with a default value
  @override
  void onInit() {
    super.onInit();
    selectedCountry.value = 'USA'; // Default selection
  }
}