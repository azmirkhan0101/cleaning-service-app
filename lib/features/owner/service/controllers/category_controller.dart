import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/owner/service/models/category_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await Get.find<NetworkHelper>()
        .request<CategoryResponseModel>(
          HttpMethod.get.method,
          ApiUrl.serviceCategories,
          withAuth: true,
          parser: (data) => CategoryResponseModel.fromJson(data),
        );

    isLoading.value = false;

    response.fold(
      (error) {
        errorMessage.value = error.message ?? 'Failed to fetch categories';
        Toast.errorToast(errorMessage.value);
      },
      (data) {
        categories.value = data.categories;
      },
    );
  }

  Future<void> refreshCategories() async {
    await fetchCategories();
  }
}
