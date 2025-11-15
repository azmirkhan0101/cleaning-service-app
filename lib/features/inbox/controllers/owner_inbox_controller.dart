import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/inbox/models/chat_user.dart';
import 'package:get/get.dart';

class OwnerInboxController extends GetxController {
  final _network = Get.find<NetworkHelper>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final users = <ChatUser>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _network.get<Map<String, dynamic>>(
      ApiUrl.messagesUsers,
      parser: (data) => data as Map<String, dynamic>,
    );

    result.match(
      (err) {
        errorMessage.value = err.message ?? 'Failed to load users';
        users.clear();
      },
      (res) {
        final list = (res['data'] as List<dynamic>? ?? [])
            .map((e) => ChatUser.fromJson(e as Map<String, dynamic>))
            .toList();
        users.assignAll(list);
      },
    );

    isLoading.value = false;
  }
}
