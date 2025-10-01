import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/helper/shared_prefe/shared_prefe.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';

/*
class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) async {
    if (response.statusCode == 401) {
      await SharePrefsHelper.remove(AppConstants.bearerToken);
      Get.offAllNamed(AppRoutes.loginScreen);
    } else {
      Toast.errorToast(response.body["error"]!);
    }
  }
}*/



class ApiChecker {
  static Future<void> checkApi(Response response) async {
    final int? statusCode = response.statusCode;
    final dynamic data = response.data;

    switch (statusCode) {

      case 400:
        Toast.errorToast(data?['message'] ?? 'Bad request.');
        break;

      case 401:
        await SharePrefsHelper.remove(AppConstants.bearerToken);
        Get.offAllNamed(AppRoutes.loginScreen);
        break;

      case 403:
        Toast.errorToast(data?['message'] ?? 'Forbidden.');
        break;

      case 404:
        Toast.errorToast(data?['message'] ?? 'Not found.');
        break;

      case 405:
        Toast.errorToast(data?['message'] ?? 'Method not allowed.');
        break;

      case 415:
        Toast.errorToast(data?['message'] ?? 'Unsupported media type.');
        break;

      case 422:
      // Show validation errors
        if (data?['errors'] is Map) {
          final errors = (data['errors'] as Map).values.expand((v) => v).join("\n");
          Toast.errorToast(errors);
        } else {
          Toast.errorToast(data?['message'] ?? 'Validation failed.');
        }
        break;

      case 429:
        Toast.errorToast(data?['message'] ?? 'Too many requests. Try again later.');
        break;

      case 500:
        Toast.errorToast(data?['message'] ?? 'Internal server error.');
        break;

      default:
        Toast.errorToast(data?['message'] ?? 'Unexpected error occurred.');
        break;
    }
  }
}
