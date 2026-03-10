import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/category_controller.dart';
import 'package:cleaning_service_app/features/owner/service/models/search_filter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SearchController extends GetxController {

  //#######################
  //FOR DROPDOWN VISIBILITY
  RxBool showDropDownList = false.obs;
  //#######################

  //#######################
  //FOR SEARCH RESULT SCREEN FILTERING
  // Current filter states
  var sortByPrice = ''.obs;
  var sortByRating = ''.obs;

  void resetSortFilterValues() {
    sortByPrice.value = '';
    sortByRating.value = '';
  }

  void setPriceFilter(String value) {
    sortByPrice.value = value;
    late Map<String, String> filterParams;
    if( sortByRating.value.isNotEmpty ){
      filterParams = {
        'sortByPrice': value,
        'sortByRating': sortByRating.value
      };
    }else{
      filterParams = {
        'sortByPrice': value
      };
    }

    searchServices(filterParams: filterParams);
  }

  void setRatingFilter(String value) {
    sortByRating.value = value;
    late Map<String, String> filterParams;
    if( sortByPrice.value.isNotEmpty ){
      filterParams = {
        'sortByPrice': sortByPrice.value,
        'sortByRating': value
      };
    }else{
      filterParams = {
        'sortByRating': value
      };
    }
    searchServices(filterParams: filterParams);
  }
  //#######################

  final Rxn<AppliedFilters> appliedFilters = Rxn<AppliedFilters>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final LocationController locationController = Get.find<LocationController>();

  // Text controller for search input
  final TextEditingController searchTextController = TextEditingController();

  // Observable states for search results
  final RxBool isSearching = false.obs;
  final RxList<FilteredService> searchResults = <FilteredService>[].obs;
  final RxInt totalResults = 0.obs;
  final RxString errorMessage = ''.obs;

  // Observable states for category dropdown
  final RxBool showSuggestions = false.obs;
  final RxList<Map<String, dynamic>> filteredServices =
      <Map<String, dynamic>>[].obs;
  final RxString selectedService = ''.obs;
  final RxnString selectedCategoryId = RxnString(); // Nullable String

  // Filter states
  final RxnInt selectedExperience = RxnInt(); // 0, 1, 2 for experience options
  final RxnBool instantBooking = RxnBool(); // true, false, or null
  final RxnString selectedGender = RxnString(); // "Male", "Female", or null
  final Rxn<DateTime> selectedDate = Rxn<DateTime>(); // Nullable DateTime
  final RxDouble pricePerHour = 20.0.obs;
  final RxDouble minPrice = 5.0.obs; // Minimum price
  final RxDouble maxPrice = 100.0.obs; // Maximum price for range
  final RxString selectedLanguage = 'English'.obs;
  final Rxn<TimeOfDay> selectedTime = Rxn<TimeOfDay>();

  @override
  void onInit() {
    super.onInit();
    //Initialize with all services
    _updateFilteredServices('');
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  /// Get all service options (All Service + Categories)
  List<Map<String, dynamic>> get serviceOptions {
    return [
      {
        'id': null,
        'icon': AppIcons.service_all,
        'label': 'All Service',
        'isSvg': true,
      },
      ...categoryController.categories.map(
        (category) => {
          'id': category.id,
          'icon': category.image,
          'label': category.name,
          'isSvg': false,
        },
      ),
    ];
  }

  /// Handle search text change
  void onSearchCategoryChanged(String value) {
    _updateFilteredServices(value);
  }

  /// Update filtered services based on search query
  void _updateFilteredServices(String query) {
    if (query.isEmpty) {
      filteredServices.value = serviceOptions;
    } else {
      filteredServices.value = serviceOptions
          .where(
            (service) => service['label'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    }
    showSuggestions.value = true;
    debugPrint('Filtered Services: $filteredServices');
  }

  /// Handle service selection
  void selectService(Map<String, dynamic> service) {
    searchTextController.text = service['label'];
    selectedService.value = service['label'];
    selectedCategoryId.value = service['id'];
    showSuggestions.value = false;
    filteredServices.clear();
  }

  /// Show suggestions dropdown
  void openSuggestions() {
    showSuggestions.value = true;
    filteredServices.value = serviceOptions;
  }

  /// Hide suggestions dropdown
  void closeSuggestions() {
    showSuggestions.value = false;
    filteredServices.clear();
  }

  /// Set experience level (0, 1, 2)
  void setExperience(int? index) {
    selectedExperience.value = index;
  }

  /// Set instant booking preference
  void setInstantBooking(bool? value) {
    instantBooking.value = value;
  }

  /// Set gender preference
  void setGender(String? gender) {
    selectedGender.value = gender;
  }

  /// Set date
  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  /// Set time
  void setTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  /// Set price per hour
  void setPricePerHour(double price) {
    pricePerHour.value = price;
    maxPrice.value = price; // Update maxPrice for API call
  }

  /// Set language
  void setLanguage(String language) {
    selectedLanguage.value = language;
  }

  /// Clear all filters
  void clearAllFilters() {
    searchTextController.clear();
    selectedService.value = '';
    selectedCategoryId.value = null;
    selectedExperience.value = null;
    instantBooking.value = null;
    selectedGender.value = null;
    selectedDate.value = null;
    pricePerHour.value = 20.0;
    minPrice.value = 5.0;
    maxPrice.value = 100.0;
    selectedLanguage.value = 'English';
    selectedTime.value = null;
    showSuggestions.value = false;
    filteredServices.clear();
  }

  /// Get search parameters for API call
  Map<String, String> getSearchParams() {
    final params = <String, String>{};

    // Category - use 'all' if null
    params['categoryId'] = selectedCategoryId.value ?? 'all';

    // Date - format as YYYY-MM-DD (only if selected)
    if (selectedDate.value != null) {
      params['date'] = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
    }

    // Time - format as HH:mm
    if (selectedTime.value != null) {
      final hour = selectedTime.value!.hour.toString().padLeft(2, '0');
      final minute = selectedTime.value!.minute.toString().padLeft(2, '0');
      params['time'] = '$hour:$minute';
    }

    // Location (latitude & longitude)
    if (locationController.selectedLatitude.value != 0.0 &&
        locationController.selectedLongitude.value != 0.0) {
      params['latitude'] = locationController.selectedLatitude.value.toString();
      params['longitude'] = locationController.selectedLongitude.value
          .toString();
    }

    // Price range (only include if not default values)
    if (minPrice.value != 5.0 || maxPrice.value != 100.0) {
      params['minPrice'] = minPrice.value.toInt().toString();
      params['maxPrice'] = maxPrice.value.toInt().toString();
    }

    // Experience - convert index to API format
    if (selectedExperience.value != null) {
      final experienceMap = {
        0: '0-1', // 0-1 year maps to 0-2
        1: '1-5', // 1-5 years
        2: '5+', // 5+ years maps to 5+
      };
      params['experience'] = experienceMap[selectedExperience.value]!;
    }

    // Instant booking - convert bool to yes/no
    if (instantBooking.value != null) {
      params['instantBooking'] = instantBooking.value! ? 'yes' : 'no';
    }

    // Gender
    if (selectedGender.value != null) {
      params['gender'] = selectedGender.value!;
    }

    // Language
    if (selectedLanguage.value.isNotEmpty &&
        selectedLanguage.value != 'English') {
      params['language'] = selectedLanguage.value;
    }

    return params;
  }

  /// Build URL with query parameters
  String _buildUrlWithParams(String baseUrl, Map<String, String> params, {Map<String, String>? filterParams}) {
    if (params.isEmpty) return baseUrl;

    final Map<String, String> combinedParams = Map.from(params);
    if (filterParams != null && filterParams.isNotEmpty) {
      combinedParams.addAll(filterParams);
    }


    final uri = Uri.parse(baseUrl);
    final newUri = uri.replace(queryParameters: combinedParams);
    return newUri.toString();
  }

  /// Perform search with current filters
  Future<void> searchServices({Map<String, String>? filterParams}) async {
    if( isSearching.value ){
      return;
    }
    try {
      isSearching.value = true;
      errorMessage.value = '';

      final params = getSearchParams();
      final url = _buildUrlWithParams(ApiUrl.searchFilter, params, filterParams: filterParams);

      debugPrint('Search URL: $url');

      final response = await Get.find<NetworkHelper>().request(
        HttpRequestType.get.method,
        url,
        withAuth: true,
        parser: (data) => SearchFilterResponseModel.fromJson(data),
      );

      isSearching.value = false;

      response.fold(
        (error) {
          errorMessage.value = error.message ?? 'Failed to search services';
          Toast.errorToast(errorMessage.value);
          searchResults.clear();
          totalResults.value = 0;
          appliedFilters.value = null;
        },
        (data) {
          searchResults.value = data.data.services;
          totalResults.value = data.data.total;
          appliedFilters.value = data.data.filters;

          if (searchResults.isEmpty) {
            //Toast.errorToast('No services found matching your criteria');
          } else {
            Toast.successToast('${totalResults.value} service(s) found');
          }
        },
      );
    } catch (e) {
      isSearching.value = false;
      errorMessage.value = 'An error occurred while searching';
      Toast.errorToast(errorMessage.value);
    }
  }

  /// Check if any filter is applied
  bool get hasActiveFilters {
    return selectedCategoryId.value != null ||
        selectedExperience.value != null ||
        instantBooking.value != null ||
        selectedGender.value != null ||
        pricePerHour.value != 20.0 ||
        selectedLanguage.value != 'English' ||
        selectedTime.value != null;
  }

  /// Get experience label
  String? get experienceLabel {
    if (selectedExperience.value == null) return null;
    final labels = [
      "0-1 year of experience",
      "1-5 years of experience",
      "5+ years of experience",
    ];
    return labels[selectedExperience.value!];
  }
}
