import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/bookings/controllers/cancelled_bookings_controller.dart';
import 'package:cleaning_service_app/features/bookings/controllers/completed_bookings_controller.dart';
import 'package:cleaning_service_app/features/bookings/controllers/ongoing_bookings_controller.dart';
import 'package:cleaning_service_app/features/bookings/controllers/pending_bookings_controller.dart';
import 'package:cleaning_service_app/features/bookings/models/booking_model.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerBookingController extends GetxController {
  RxInt selectedTabIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxList<BookingModel> allBookings = <BookingModel>[].obs;
  Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);

  // Pagination state for "All" tab only
  RxInt currentPage = 1.obs;
  RxBool hasMore = true.obs;

  final ScrollController scrollController = ScrollController();

  // Separate controllers for each status
  late PendingBookingsController pendingController;
  late OngoingBookingsController ongoingController;
  late CompletedBookingsController completedController;
  late CancelledBookingsController cancelledController;

  final List<String> tabTitles = [
    "All",
    "PENDING",
    "ONGOING",
    "COMPLETED",
    "CANCELLED",
  ];

  // Get user role
  String get userRole => AppStorageService.getUserRole() ?? 'OWNER';
  bool get isProvider => userRole.toUpperCase() == 'PROVIDER';

  @override
  void onInit() {
    super.onInit();
    // Initialize separate controllers
    pendingController = Get.put(PendingBookingsController());
    ongoingController = Get.put(OngoingBookingsController());
    completedController = Get.put(CompletedBookingsController());
    cancelledController = Get.put(CancelledBookingsController());

    fetchAllBookings();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    // Only enable pagination for "All" tab
    if (selectedTabIndex.value != 0) return;

    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore.value &&
        hasMore.value) {
      loadMoreBookings();
    }
  }

  /// Get the appropriate "All bookings" endpoint based on role
  String get _allBookingsEndpoint {
    return isProvider ? ApiUrl.providerMyBookings : ApiUrl.ownerMyBookings;
  }

  /// Fetch all bookings with pagination (for "All" tab)
  Future<void> fetchAllBookings({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
        hasMore.value = true;
      }

      isLoading.value = true;

      final response = await Get.find<NetworkHelper>()
          .request<BookingsResponseModel>(
            HttpMethod.get.method,
            '$_allBookingsEndpoint?page=${currentPage.value}&limit=10',
            withAuth: true,
            parser: (data) => BookingsResponseModel.fromJson(data),
          );

      isLoading.value = false;

      response.fold(
        (error) {
          Toast.errorToast(error.message ?? 'Failed to fetch bookings');
        },
        (data) {
          if (isRefresh || currentPage.value == 1) {
            allBookings.value = data.data.bookings;
          } else {
            allBookings.addAll(data.data.bookings);
          }

          pagination.value = data.data.pagination;
          hasMore.value =
              currentPage.value < (pagination.value?.totalPages ?? 0);
        },
      );
    } catch (e) {
      isLoading.value = false;
      Toast.errorToast('Failed to fetch bookings');
      print('Exception fetching bookings: $e');
    }
  }

  /// Load more bookings (pagination for "All" tab only)
  Future<void> loadMoreBookings() async {
    if (selectedTabIndex.value != 0 || !hasMore.value || isLoadingMore.value) {
      return;
    }

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final response = await Get.find<NetworkHelper>()
          .request<BookingsResponseModel>(
            HttpMethod.get.method,
            '$_allBookingsEndpoint?page=${currentPage.value}&limit=10',
            withAuth: true,
            parser: (data) => BookingsResponseModel.fromJson(data),
          );

      isLoadingMore.value = false;

      response.fold(
        (error) {
          currentPage.value--; // Revert page increment on error
          Toast.errorToast(error.message ?? 'Failed to load more bookings');
        },
        (data) {
          allBookings.addAll(data.data.bookings);
          pagination.value = data.data.pagination;
          hasMore.value =
              currentPage.value < (pagination.value?.totalPages ?? 0);
        },
      );
    } catch (e) {
      isLoadingMore.value = false;
      currentPage.value--; // Revert page increment on error
      Toast.errorToast('Failed to load more bookings');
      print('Exception loading more bookings: $e');
    }
  }

  /// Get current bookings based on selected tab
  RxList<BookingModel> get currentBookings {
    switch (selectedTabIndex.value) {
      case 0:
        return allBookings;
      case 1:
        return pendingController.bookings;
      case 2:
        return ongoingController.bookings;
      case 3:
        return completedController.bookings;
      case 4:
        return cancelledController.bookings;
      default:
        return allBookings;
    }
  }

  /// Get current loading state based on selected tab
  bool get isCurrentlyLoading {
    switch (selectedTabIndex.value) {
      case 0:
        return isLoading.value;
      case 1:
        return pendingController.isLoading.value;
      case 2:
        return ongoingController.isLoading.value;
      case 3:
        return completedController.isLoading.value;
      case 4:
        return cancelledController.isLoading.value;
      default:
        return isLoading.value;
    }
  }

  /// Refresh bookings based on selected tab
  Future<void> refreshBookings() async {
    switch (selectedTabIndex.value) {
      case 0:
        await fetchAllBookings(isRefresh: true);
        break;
      case 1:
        await pendingController.refreshBookings();
        break;
      case 2:
        await ongoingController.refreshBookings();
        break;
      case 3:
        await completedController.refreshBookings();
        break;
      case 4:
        await cancelledController.refreshBookings();
        break;
    }
  }

  /// Switch tabs
  void filterServices(int index) {
    selectedTabIndex.value = index;

    // Reset pagination state when switching to "All" tab
    if (index == 0) {
      currentPage.value = 1;
      hasMore.value = true;
      if (allBookings.isEmpty) {
        fetchAllBookings();
      }
    }
  }
}
