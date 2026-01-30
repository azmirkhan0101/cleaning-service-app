import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/inbox/controllers/inbox_controller.dart';
import 'package:cleaning_service_app/features/inbox/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late final OwnerInboxController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(OwnerInboxController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Inbox"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText2(
                    text: controller.errorMessage.value,
                    color: AppColors.red,
                    fontSize: 14,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.fetchUsers,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final List<ChatUser> users = controller.users;
          if (users.isEmpty) {
            // Allow pull-to-refresh even when empty
            return RefreshIndicator(
              onRefresh: controller.fetchUsers,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('No conversations yet')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchUsers,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFF2F4F7)),
              itemBuilder: (context, index) {
                final user = users[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: ListTile(
                    onTap: () {
                      // Optimistically clear unread badge locally
                      controller.markUserAsRead(user.id);
                      Get.toNamed(
                        AppRoutes.ownerMessageScreen,
                        arguments: {
                          'userId': user.id,
                          'userName': user.userName,
                          'avatar': user.profilePicture,
                        },
                      );
                    },
                    dense: true,
                    leading: user.profilePicture.isNotEmpty
                        ? CustomNetworkImage(
                            imageUrl: user.profilePicture,
                            height: 48,
                            width: 48,
                            boxShape: BoxShape.circle,
                          )
                        : CustomImage(
                            imageSrc: AppImages.user_image,
                            height: 48,
                            width: 48,
                          ),
                    title: Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            text: user.userName.isNotEmpty
                                ? user.userName
                                : user.email,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (user.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.appColors,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    //subtitle: Text(user.email),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                );
              },
            ),
          );
        }),
      ),
      // bottomNavigationBar: OwnerNavBar(currentIndex: 3),
    );
  }
}
