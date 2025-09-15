import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/helper/shared_prefe/shared_prefe.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:get/get.dart';


class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) async {
    if (response.statusCode == 401) {
      await SharePrefsHelper.remove(AppConstants.bearerToken);
      Get.offAllNamed(AppRoutes.loginScreen);
    } else {
      Toast.errorToast(response.body["error"]!);
    }
  }
}