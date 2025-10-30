import 'dart:convert';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
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
      Permission.location,
      Permission.activityRecognition,
      Permission.locationAlways,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    return allGranted;
  }

  Future<void> validateToken() async {
    try {
      final String? token = await AppStorageService.getAuthToken();
      if (token == null || token.isEmpty) {
        debugPrint('No auth token found');
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

      // debugPrint
      debugPrint("request url: $uri");
      debugPrint("request body: ${jsonEncode({"token": token})}");
      debugPrint("response status: ${response.statusCode}");
      debugPrint("response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bool isValid = data['data']['isValid'] ?? false;

        if (!isValid) {
          debugPrint('Token is invalid or expired');
          Get.offAll(() => GetStartedScreen());
          return;
        }

        final String role = data['data']['decoded']['role'];
        debugPrint('Token is valid. User role: $role');
        Get.offAll(() => MainLayout(isOwner: role == 'owner'));
      } else {
        debugPrint(
          'Token validation failed with status: ${response.statusCode}',
        );
        Get.offAll(() => GetStartedScreen());
      }
    } catch (e) {
      debugPrint('Token validation error: $e');
      Get.offAll(() => GetStartedScreen());
    }
  }
}
