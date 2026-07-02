import 'dart:convert';

import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/service/subscription_service.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/main-layout/controllers/main_layout_controller.dart';
import 'package:cleaning_service_app/features/profile/models/profile_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  // Observable profile data
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoadingStripeDashboard = false.obs;
  final RxBool isCreatingStripeOnboarding = false.obs;


  //LOADER CONTROL FOR DELETE ACCOUNT
  RxBool isDeleting = false.obs;

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

          Toast.errorToast(error.message ?? 'Failed to load profile');
        },
        (data) {
          // Parse response
          profile.value = data.data;
          String? providerId = profile.value?.id;
          if( providerId != null ){
            SubscriptionService.to.loginUser(providerId);
          }
        },
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load profile';
      debugPrint('Exception fetching profile: $e');
      Toast.errorToast('Failed to load profile');
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
    // try {
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

        Toast.errorToast(error.message ?? 'Failed to update location');
        return false;
      },
      (data) {
        debugPrint('Location updated successfully: ${data['message']}');
        return true;
      },
    );
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
            shouldPrint: true,
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
            shouldPrint: true,
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

  /// Complete Stripe Connect onboarding - forces fresh Stripe status check
  /// Must be called immediately after user returns from Stripe onboarding
  Future<bool> completeStripeConnectOnboarding(String url) async {
    try {
      final response = await Get.find<NetworkHelper>()
          .request<Map<String, dynamic>>(
            HttpRequestType.get.method,
            url,
            withAuth: true,
            parser: (data) => data as Map<String, dynamic>,
            shouldPrint: true,
          );

      return response.fold(
        (error) {
          //debugPrint('Stripe completion callback error: ${error.message}');
          return false;
        },
        (data) {
          // Refresh profile to update Stripe status
          refreshProfile();
          return true;
        },
      );
    } catch (e) {
      //debugPrint('Exception calling stripe completion callback: $e');
      return false;
    }
  }

  /// Disconnect Stripe Connect account
  Future<bool> disconnectStripeAccount() async {
    try {
      final response = await Get.find<NetworkHelper>()
          .request<Map<String, dynamic>>(
            HttpRequestType.delete.method,
            ApiUrl.stripeConnectDisconnect,
            withAuth: true,
            parser: (data) => data as Map<String, dynamic>,
          );

      return response.fold(
        (error) {
          debugPrint('Stripe disconnect error: ${error.message}');

          Toast.errorToast(
            error.message ?? 'Failed to disconnect Stripe account',
          );
          return false;
        },
        (data) {
          debugPrint('Stripe account disconnected successfully');
          // Refresh profile to update Stripe status
          refreshProfile();
          Toast.successToast('Stripe account disconnected successfully');
          return true;
        },
      );
    } catch (e) {
      debugPrint('Exception disconnecting stripe account: $e');
      Toast.errorToast('Failed to disconnect Stripe account');
      return false;
    }
  }

  //UPLOAD COUNTRY TO SERVER
  Future<bool> uploadCountry({required String country}) async {

    try{
      final token = await AppStorageService.getAuthToken();
      final finalHeaders = {
        "Content-Type": "application/json",
        "Cookie": "token=$token",
      };
      final uri = Uri.parse(ApiUrl.uploadCountry);
      final payLoad = {"country": country};
      final response = await http
          .put(uri, headers: finalHeaders, body: jsonEncode(payLoad))
          .timeout(Duration(seconds: 10));

      if( response.statusCode == 200 || response.statusCode == 201 ){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }
}
