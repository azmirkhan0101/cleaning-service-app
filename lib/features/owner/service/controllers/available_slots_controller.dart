import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/owner/service/models/available_slots_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AvailableSlotsController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString providerId = ''.obs;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<AvailableSlotsModel?> availableSlots = Rx<AvailableSlotsModel?>(null);
  RxString selectedStartTime = ''.obs;

  /// Set the provider ID
  void setProviderId(String id) {
    providerId.value = id;
  }

  /// Select a date and fetch available slots
  Future<void> selectDate(DateTime date) async {
    selectedDate.value = date;
    selectedStartTime.value = '';
    await fetchAvailableSlots(date);
  }

  /// Select a single time slot as start time
  void selectStartTime(String time) {
    selectedStartTime.value = time;
  }

  /// Check if a time slot is selected
  bool isSlotSelected(String time) {
    return selectedStartTime.value == time;
  }

  /// Check if a time slot is available
  bool isSlotAvailable(String time) {
    final slot = availableSlots.value?.slots.firstWhere(
      (s) => s.time == time,
      orElse: () => TimeSlotModel(time: '', available: false),
    );
    return slot?.available ?? false;
  }

  /// Fetch available slots for a specific date
  Future<void> fetchAvailableSlots(DateTime date) async {
    if (providerId.value.isEmpty) {
      Toast.errorToast('Provider ID is required');
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    // Format date as YYYY-MM-DD
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final response = await Get.find<NetworkHelper>()
        .request<AvailableSlotsModel>(
          HttpRequestType.get.method,
          ApiUrl.getAvailableSlots(providerId.value, formattedDate),
          withAuth: true,
          parser: (data) => AvailableSlotsModel.fromJson(data['data']),
        );

    isLoading.value = false;

    response.fold(
      (error) {
        errorMessage.value = error.message ?? 'Failed to fetch available slots';
        Toast.errorToast(errorMessage.value);
        availableSlots.value = null;
      },
      (data) {
        availableSlots.value = data;
        if (!data.isAvailable) {
          Toast.errorToast('No slots available for this date');
        }
      },
    );
  }

  /// Check if a start time is selected
  bool isStartTimeSelected() {
    return selectedStartTime.value.isNotEmpty;
  }

  /// Clear selection
  void clearSelection() {
    selectedStartTime.value = '';
  }

  @override
  void onClose() {
    selectedStartTime.value = '';
    super.onClose();
  }
}
