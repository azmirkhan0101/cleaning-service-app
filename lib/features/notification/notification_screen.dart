import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/notification/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notification",
        backButton: true,
        actions: [
          Tooltip(
            message: 'Mark all as read',
            child: IconButton(
              onPressed: () {
                controller.markAllAsRead();
              },
              icon: Icon(Icons.check_rounded, color: AppColors.black),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                CustomText(
                  text: 'No notifications yet',
                  fontSize: 16,
                  color: Colors.grey[600]!,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
              itemCount: controller.notifications.length,
              itemBuilder: (BuildContext context, index) {
                final notification = controller.notifications[index];
                return Dismissible(
                  key: Key(notification.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    controller.deleteNotification(notification.id);
                  },
                  child: _buildNotification(
                    index: index,
                    notificationId: notification.id,
                    title: notification.title,
                    subtitle: notification.message,
                    time: notification.getTimeAgo(),
                    isRead: notification.isRead,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 1, color: Color(0xFFF1F1F2));
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNotification({
    required int index,
    required String notificationId,
    required String title,
    required String subtitle,
    required String time,
    required bool isRead,
  }) {
    return ListTile(
      onTap: () {
        if (!isRead) {
          controller.markAsRead(notificationId);
        }
      },
      // leading: Icon(icon, color: Colors.blue),
      leading: Assets.icons.bellRinging.svg(
        colorFilter: ColorFilter.mode(
          !isRead ? AppColors.blue : AppColors.black,
          BlendMode.srcIn,
        ),
      ),
      title: CustomText(
        text: title,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        textAlign: TextAlign.start,
        fontFamily: FontFamily.lexend,
        color: !isRead ? AppColors.blue : AppColors.black,
      ),
      subtitle: CustomText(
        text: subtitle,
        fontWeight: FontWeight.w400,
        fontSize: 13,
        textAlign: TextAlign.start,
        fontFamily: FontFamily.lexend,
        color: !isRead ? AppColors.blue : Color(0xFF4F4F59),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomText(
            text: time,
            fontWeight: FontWeight.w400,
            fontSize: 12,
            textAlign: TextAlign.start,
            fontFamily: FontFamily.lexend,
            color: !isRead ? AppColors.blue : Color(0xFF4F4F59),
          ),
        ],
      ),
    );
  }
}
