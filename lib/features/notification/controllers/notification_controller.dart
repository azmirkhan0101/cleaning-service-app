import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:cleaning_service_app/features/notification/models/notification_model.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await Get.find<NetworkHelper>()
        .request<NotificationResponseModel>(
          HttpMethod.get.method,
          ApiUrl.notifications,
          withAuth: true,
          parser: (data) => NotificationResponseModel.fromJson(data['data']),
        );

    isLoading.value = false;

    response.fold(
      (error) {
        errorMessage.value = error.message ?? 'Failed to fetch notifications';
        Toast.errorToast(errorMessage.value);
      },
      (data) {
        notifications.value = data.notifications;
        unreadCount.value = data.unreadCount;
      },
    );
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  /// Mark a single notification as read
  Future<bool> markAsRead(String notificationId) async {
    final response = await Get.find<NetworkHelper>().request(
      HttpMethod.patch.method,
      ApiUrl.markNotificationAsRead(notificationId),
      withAuth: true,
    );

    return response.fold(
      (error) {
        Toast.errorToast(
          error.message ?? 'Failed to mark notification as read',
        );
        return false;
      },
      (data) {
        // Update the notification in the local list
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notifications[index] = notifications[index].copyWith(isRead: true);
          notifications.refresh();
          if (unreadCount.value > 0) {
            unreadCount.value--;
          }
        }
        return true;
      },
    );
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    final response = await Get.find<NetworkHelper>().request(
      HttpMethod.patch.method,
      ApiUrl.markAllNotificationsAsRead,
      withAuth: true,
    );

    return response.fold(
      (error) {
        Toast.errorToast(
          error.message ?? 'Failed to mark all notifications as read',
        );
        return false;
      },
      (data) {
        // Update all notifications in the local list
        notifications.value = notifications.map((n) {
          return n.copyWith(isRead: true);
        }).toList();
        unreadCount.value = 0;
        Toast.successToast('All notifications marked as read');
        return true;
      },
    );
  }

  /// Delete a notification
  Future<bool> deleteNotification(String notificationId) async {
    final response = await Get.find<NetworkHelper>().request(
      HttpMethod.delete.method,
      ApiUrl.deleteNotification(notificationId),
      withAuth: true,
    );

    return response.fold(
      (error) {
        Toast.errorToast(error.message ?? 'Failed to delete notification');
        return false;
      },
      (data) {
        // Remove the notification from the local list
        final notificationToRemove = notifications.firstWhere(
          (n) => n.id == notificationId,
        );
        notifications.removeWhere((n) => n.id == notificationId);

        // Update unread count if the deleted notification was unread
        if (!notificationToRemove.isRead && unreadCount.value > 0) {
          unreadCount.value--;
        }

        Toast.successToast('Notification deleted');
        return true;
      },
    );
  }
}
