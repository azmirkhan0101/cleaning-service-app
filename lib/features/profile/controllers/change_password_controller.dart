import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/profile/models/change_password_model.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final RxBool isLoading = false.obs;

  /// Change password
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Validate passwords match
    if (newPassword != confirmPassword) {
      Toast.errorToast('New password and confirm password do not match');
      return false;
    }

    // Validate password length
    if (newPassword.length < 8) {
      Toast.errorToast('Password must be at least 8 characters long');
      return false;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic> body = {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };

      final response = await Get.find<NetworkHelper>()
          .request<ChangePasswordResponseModel>(
            HttpRequestType.put.method,
            ApiUrl.changePassword,
            body: body,
            withAuth: true,
            parser: (data) => ChangePasswordResponseModel.fromJson(data),
          );

      isLoading.value = false;

      return response.fold(
        (error) {
          Toast.errorToast(error.message ?? 'Failed to change password');
          return false;
        },
        (data) {
          Toast.successToast(data.message);
          return true;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Toast.errorToast('Failed to change password');
      print('Exception changing password: $e');
      return false;
    }
  }
}
