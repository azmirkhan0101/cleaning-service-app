import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class Toast {
  static errorToast(String message) {
    showToast(
      message,
      dismissOtherToast: true,
      position: ToastPosition.bottom,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
      radius: 8,
    );
  }

  static successToast(String message) {
    showToast(
      message,
      dismissOtherToast: true,
      position: ToastPosition.bottom,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      radius: 8,
    );
  }
}
