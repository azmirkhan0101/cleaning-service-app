import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';


class AuthController extends GetxController {



  RxBool rememberPassword = false.obs;


  Rx<TextEditingController> loginEmailController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;


  Rx<TextEditingController> loginPasswordController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;

  Rx<TextEditingController> newTextEditingController = TextEditingController(
    text: kDebugMode ? "" : "",
  ).obs;
}