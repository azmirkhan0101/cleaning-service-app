import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingController extends GetxController{

  RxInt currentIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    pageController = PageController(initialPage: currentIndex.value);
    super.onInit();
  }


  Future<bool> checkAndRequestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.activityRecognition,
      Permission.locationAlways,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    return allGranted;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

}