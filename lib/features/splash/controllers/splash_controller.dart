import 'dart:convert';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:cleaning_service_app/features/main-layout/screens/main_layout.dart';
import 'package:cleaning_service_app/features/splash/screens/get_started_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () async {
        checkAndRequestPermissions();
        await validateToken();
      });
    });
    super.onInit();
  }

  Future<bool> checkAndRequestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    return allGranted;
  }

  Future<void> validateToken() async {
    try {
      final String? token = await AppStorageService.getAuthToken();
      if (token == null || token.isEmpty) {
        Get.offAll(() => GetStartedScreen());
        return;
      }

      // Use custom GET request with body (non-standard but supported)
      final uri = Uri.parse(ApiUrl.validateToken);
      final request = http.Request('GET', uri);

      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({"token": token});

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bool isValid = data['data']['isValid'] ?? false;

        if (!isValid) {
          Get.offAll(() => GetStartedScreen());
          return;
        }

        final String role = data['data']['decoded']['role'];
        Get.offAll(() => MainLayout(isOwner: role == Role.owner.value));
      } else {
        Get.offAll(() => GetStartedScreen());
      }
    } catch (e) {
      Get.offAll(() => GetStartedScreen());
    }
  }
}
