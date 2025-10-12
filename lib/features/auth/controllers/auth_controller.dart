import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool rememberPassword = false.obs;

  Rx<TextEditingController> signupNameController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> signupPhoneController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> signupEmailController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> signupPasswordController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> signupConfirmPasswordController =
      TextEditingController(text: kDebugMode ? "" : "").obs;

  Rx<TextEditingController> signupReferralController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> loginEmailController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> loginPasswordController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> newTextEditingController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  @override
  void onClose() {
    // Make sure you dispose of the controller when it's no longer needed
    newTextEditingController.value.dispose();
    super.onClose();
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
