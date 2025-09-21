
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';


class OwnerController extends GetxController {


  RxInt sliderCurrentIndex = 0.obs;


  ///  slider image Define the RxList holding the data
  RxList<Map<String, String>> sliderImageIndex = <Map<String, String>>[
    {
      'name': 'John Doe',
      'time': '34m ago',
      'appointment': 'Sep 10, 2025 - 11:30 AM with John Doe (Cleaning)',
      'avatar': 'https://www.w3schools.com/w3images/avatar2.png',
    },
  ].obs;  // Using `.obs` to make it reactive

}