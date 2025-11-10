import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/provider/service/models/service_category_model.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  final network = Get.find<NetworkHelper>();

  /// Can owner book directly without approval?
  RxBool typeModeStatues = false.obs;

  RxBool genderType = false.obs;

  RxBool setBufferTimeType = false.obs;

  // Define an observable variable to store the selected category ID
  RxString selectedCategoryId = ''.obs;

  // Define an observable variable to store the selected category name
  RxString selectedCategoryName = ''.obs;

  // Define an observable variable to store the selected country/language (deprecated)
  RxString selectedCountry = ''.obs;

  // Observable list for multiple selected languages
  final RxList<String> selectedLanguages = <String>[].obs;

  // Available languages
  final List<String> availableLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Chinese',
    'Japanese',
    'Arabic',
    'Hindi',
  ];

  // Observable list of categories
  final RxList<ServiceCategoryModel> categories = <ServiceCategoryModel>[].obs;
  final RxBool isLoadingCategories = false.obs;
  final RxString categoriesError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Toggle language selection
  void toggleLanguage(String language) {
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
    } else {
      selectedLanguages.add(language);
    }
  }

  /// Check if a language is selected
  bool isLanguageSelected(String language) {
    return selectedLanguages.contains(language);
  }

  /// Fetch service categories from API
  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;
    categoriesError.value = '';

    final result = await network.request<List<ServiceCategoryModel>>(
      'GET',
      ApiUrl.serviceCategories,
      parser: (data) {
        final categoryList =
            (data['data'] as List?)
                ?.map((item) => ServiceCategoryModel.fromJson(item))
                .toList() ??
            [];
        return categoryList;
      },
    );

    result.fold(
      (error) {
        categoriesError.value = error.message ?? 'Failed to load categories';
        isLoadingCategories.value = false;
      },
      (categoryList) {
        categories.value = categoryList;
        isLoadingCategories.value = false;
      },
    );
  }
}
