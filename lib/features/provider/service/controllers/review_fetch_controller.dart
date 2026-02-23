import 'package:get/get.dart';

import '../../../../core/service/api_url.dart';
import '../../../../core/service/app_storage_service.dart';
import '../../../../core/service/network_helper.dart';
import '../../../common/types/http_method.dart';
import '../../../owner/service/models/review_model.dart';

class ReviewFetchController extends GetxController{

  final network = Get.find<NetworkHelper>();

  late String serviceID;
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  @override
  void onInit() {

    serviceID = Get.arguments as String? ?? "";
    fetchReviews(serviceID: serviceID);

    super.onInit();
  }

  //FETCH REVIEWS
fetchReviews({required String serviceID}) async{

    try{
      isLoading.value = true;
      final result = await network.request<List<ReviewModel>>(
        HttpRequestType.get.method,
        ApiUrl.reviews(serviceId: serviceID),
        withAuth: true,
        parser: (data) {
          // Parse pagination meta
          // if (data['meta'] != null) {
          //   meta.value = PaginationMeta.fromJson(data['meta']);
          //   hasMorePages = currentPage < (meta.value?.totalPages ?? 1);
          // }
          final fetchedReviews =
              (data['data'] as List?)
                  ?.map((item) => ReviewModel.fromJson(item))
                  .toList() ??
                  [];
          return fetchedReviews;
        },
      );

      result.fold(
            (error) {
          errorMessage.value = error.message ?? 'Failed to load services';
          isLoading.value = false;
        },
            (fetchedReviews) {
          reviews.value = fetchedReviews;
          isLoading.value = false;
        },
      );

    }catch(e){
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
}
}