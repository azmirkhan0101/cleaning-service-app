import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/profile/models/knowledge_hub_detail_model.dart';
import 'package:get/get.dart';

class KnowledgeHubDetailController extends GetxController {
  final NetworkHelper _networkHelper = Get.find<NetworkHelper>();

  Rx<KnowledgeHubDetailModel?> article = Rx<KnowledgeHubDetailModel?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  String? _currentArticleId;

  /// Fetch Knowledge Hub article detail by ID
  Future<void> fetchArticleDetail(String articleId) async {
    _currentArticleId = articleId;
    isLoading.value = true;
    errorMessage.value = '';
    article.value = null;

    final result = await _networkHelper.get<Map<String, dynamic>>(
      ApiUrl.getKnowledgeHubDetail(articleId),
      parser: (data) => data as Map<String, dynamic>,
    );

    result.fold(
      (error) {
        errorMessage.value = error.message ?? 'Failed to load article details';
        isLoading.value = false;
      },
      (data) {
        try {
          article.value = KnowledgeHubDetailModel.fromJson(data['data']);
        } catch (e) {
          errorMessage.value = 'Failed to parse article details';
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  /// Retry fetching article detail
  void retry() {
    if (_currentArticleId != null) {
      fetchArticleDetail(_currentArticleId!);
    }
  }

  @override
  void onClose() {
    article.value = null;
    super.onClose();
  }
}
