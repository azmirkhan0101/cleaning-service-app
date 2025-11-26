import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/main-layout/controllers/main_layout_controller.dart';
import 'package:cleaning_service_app/features/profile/models/profile_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Observable profile data
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoadingStripeDashboard = false.obs;
  final RxBool isCreatingStripeOnboarding = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// Fetch user profile from API
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await Get.find<NetworkHelper>()
          .request<ProfileResponseModel>(
            HttpRequestType.get.method,
            ApiUrl.profile,
            withAuth: true,
            parser: (data) => ProfileResponseModel.fromJson(data),
          );

      isLoading.value = false;

      response.fold(
        (error) {
          // Handle error
          errorMessage.value = error.message ?? 'Failed to load profile';
          debugPrint('Error fetching profile: ${error.message}');
          Get.snackbar(
            'Error',
            error.message ?? 'Failed to load profile',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (data) {
          // Parse response
          profile.value = data.data;
        },
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load profile';
      debugPrint('Exception fetching profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  /// Update user location
  Future<bool> updateLocation({
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';

      final response = await Get.find<NetworkHelper>()
          .request<Map<String, dynamic>>(
            HttpRequestType.put.method,
            ApiUrl.updateLocation,
            body: {
              'address': address,
              'lattitude': latitude,
              'longitude': longitude,
            },
            withAuth: true,
            parser: (data) => data as Map<String, dynamic>,
          );

      isUpdating.value = false;

      return response.fold(
        (error) {
          errorMessage.value = error.message ?? 'Failed to update location';
          debugPrint('Error updating location: ${error.message}');
          Get.snackbar(
            'Error',
            error.message ?? 'Failed to update location',
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        },
        (data) {
          debugPrint('Location updated successfully: ${data['message']}');
          return true;
        },
      );
    } catch (e) {
      isUpdating.value = false;
      errorMessage.value = 'Failed to update location';
      debugPrint('Exception updating location: $e');
      Get.snackbar(
        'Error',
        'Failed to update location',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      // Call logout API
      final response = await Get.find<NetworkHelper>()
          .request<Map<String, dynamic>>(
            HttpRequestType.post.method,
            ApiUrl.logout,
            withAuth: true,
            parser: (data) => data as Map<String, dynamic>,
          );

      response.fold(
        (error) {
          // Even if API fails, clear local data and logout
          debugPrint('Logout API error: ${error.message}');
        },
        (data) {
          debugPrint('Logout success: ${data['message']}');
        },
      );
    } catch (e) {
      debugPrint('Exception during logout: $e');
    } finally {
      // Delete the permanent MainLayoutController to allow fresh creation on next login
      if (Get.isRegistered<MainLayoutController>()) {
        Get.delete<MainLayoutController>(force: true);
      }

      // Clear all stored data
      await AppStorageService.clearAll();

      // Navigate to login screen and clear navigation stack
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  /// Fetch Stripe Connect dashboard link
  Future<String?> fetchStripeDashboardUrl() async {
    try {
      isLoadingStripeDashboard.value = true;
      errorMessage.value = '';

      final response = await Get.find<NetworkHelper>()
          .request<Map<String, dynamic>>(
            HttpRequestType.get.method,
            ApiUrl.stripeConnectDashboard,
            withAuth: true,
            parser: (data) => data as Map<String, dynamic>,
          );
      isLoadingStripeDashboard.value = false;

      return response.fold(
        (error) {
          errorMessage.value = error.message ?? 'Failed to load dashboard link';
          debugPrint('Stripe dashboard error: ${error.message}');
          return null;
        },
        (data) {
          final url = (data['data']?['url'] ?? '').toString();
          return url.isEmpty ? null : url;
        },
      );
    } catch (e) {
      debugPrint('Exception fetching stripe dashboard link: $e');
      errorMessage.value = 'Failed to load dashboard link';
      return null;
    } finally {
      isLoadingStripeDashboard.value = false;
    }
  }

  /// Create or fetch Stripe Connect onboarding link (POST)
  Future<String?> createStripeOnboardingLink() async {
    try {
      isCreatingStripeOnboarding.value = true;
      errorMessage.value = '';

      final response = await Get.find<NetworkHelper>()
          .request<Map<String, dynamic>>(
            HttpRequestType.post.method,
            ApiUrl.stripeConnectOnboarding,
            withAuth: true,
            parser: (data) => data as Map<String, dynamic>,
          );

      return response.fold(
        (error) {
          errorMessage.value = error.message ?? 'Failed to start onboarding';
          debugPrint('Stripe onboarding error: ${error.message}');
          return null;
        },
        (data) {
          final url = (data['data']?['url'] ?? '').toString();
          return url.isEmpty ? null : url;
        },
      );
    } catch (e) {
      debugPrint('Exception creating stripe onboarding link: $e');
      errorMessage.value = 'Failed to start onboarding';
      return null;
    } finally {
      isCreatingStripeOnboarding.value = false;
    }
  }
}
