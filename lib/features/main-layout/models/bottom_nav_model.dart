import 'package:flutter/material.dart';

class BottomNavModel {
  final String label;
  final String selectedIconPath;
  final String unselectedIconPath;
  final Widget? ownerScreen;
  final Widget? providerScreen;

  BottomNavModel({
    required this.label,
    required this.selectedIconPath,
    required this.unselectedIconPath,
    this.ownerScreen,
    this.providerScreen,
  });
}
