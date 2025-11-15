import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/profile/models/knowledge_hub_model.dart';
import 'package:get/get.dart';

class KnowledgeHubController extends GetxController {
  final NetworkHelper _networkHelper = Get.find<NetworkHelper>();

  RxList<KnowledgeHubModel> articles = <KnowledgeHubModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKnowledgeHub();
  }

  /// Fetch Knowledge Hub articles
  Future<void> fetchKnowledgeHub() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _networkHelper.get<Map<String, dynamic>>(
      ApiUrl.getKnowledgeHub,
      parser: (data) => data as Map<String, dynamic>,
    );

    result.fold(
      (error) {
        errorMessage.value =
            error.message ?? 'Failed to load Knowledge Hub articles';
        articles.clear();
        isLoading.value = false;
      },
      (data) {
        try {
          final list = (data['data'] as List<dynamic>)
              .map((e) => KnowledgeHubModel.fromJson(e as Map<String, dynamic>))
              .toList();
          articles.assignAll(list);
        } catch (e) {
          errorMessage.value = 'Failed to parse Knowledge Hub articles';
          articles.clear();
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  /// Retry fetching articles
  void retry() {
    fetchKnowledgeHub();
  }
}
