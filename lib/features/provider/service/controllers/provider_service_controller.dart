import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/provider/service/models/provider_service_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderServiceController extends GetxController {
  final network = Get.find<NetworkHelper>();

  // Observables
  final RxList<ProviderServiceModel> services = <ProviderServiceModel>[].obs;
  final Rxn<PaginationMeta> meta = Rxn<PaginationMeta>();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString loadError = ''.obs;

  // Pagination state
  int currentPage = 1;
  final int pageLimit = 20;
  bool hasMorePages = true;

  // ScrollController for pagination
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchServices();
    _setupScrollListener();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Setup scroll listener for pagination
  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.8 &&
          !isLoadingMore.value &&
          hasMorePages) {
        loadMoreServices();
      }
    });
  }

  /// Fetch services from API (first page)
  Future<void> fetchServices({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMorePages = true;
      services.clear();
    }

    isLoading.value = true;
    loadError.value = '';

    final result = await network.request<List<ProviderServiceModel>>(
      'GET',
      ApiUrl.myServices(page: currentPage, limit: pageLimit),
      parser: (data) {
        // Parse pagination meta
        if (data['meta'] != null) {
          meta.value = PaginationMeta.fromJson(data['meta']);
          hasMorePages = currentPage < (meta.value?.totalPages ?? 1);
        }

        // Parse services list
        final servicesList =
            (data['data'] as List?)
                ?.map((item) => ProviderServiceModel.fromJson(item))
                .toList() ??
            [];
        return servicesList;
      },
    );

    result.fold(
      (error) {
        loadError.value = error.message ?? 'Failed to load services';
        isLoading.value = false;
      },
      (servicesList) {
        services.value = servicesList;
        isLoading.value = false;
      },
    );
  }

  /// Load more services (pagination)
  Future<void> loadMoreServices() async {
    if (isLoadingMore.value || !hasMorePages) return;

    isLoadingMore.value = true;
    currentPage++;

    final result = await network.request<List<ProviderServiceModel>>(
      'GET',
      ApiUrl.myServices(page: currentPage, limit: pageLimit),
      parser: (data) {
        // Update pagination meta
        if (data['meta'] != null) {
          meta.value = PaginationMeta.fromJson(data['meta']);
          hasMorePages = currentPage < (meta.value?.totalPages ?? 1);
        }

        // Parse services list
        final servicesList =
            (data['data'] as List?)
                ?.map((item) => ProviderServiceModel.fromJson(item))
                .toList() ??
            [];
        return servicesList;
      },
    );

    result.fold(
      (error) {
        currentPage--; // Revert page on error
        isLoadingMore.value = false;
      },
      (servicesList) {
        services.addAll(servicesList);
        isLoadingMore.value = false;
      },
    );
  }

  /// Refresh services (pull to refresh)
  Future<void> refreshServices() async {
    await fetchServices(refresh: true);
  }
}
