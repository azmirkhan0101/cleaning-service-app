// Dynamic Owner Message Screen for chat conversation
// ignore_for_file: unused_local_variable

import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/components/custom_text_field/custom_text_field.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/inbox/controllers/chat_conversation_controller.dart';
import 'package:cleaning_service_app/features/main-layout/controllers/main_layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/context_extension/context_extension.dart';

class ConversationScreen extends StatelessWidget {
  ConversationScreen({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  ChatConversationController _initController() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final userId = args['userId']?.toString() ?? '';
    // Use unique tag to ensure fresh controller per user
    return Get.put(
      ChatConversationController(
        userId: userId,
        userName: args['userName']?.toString() ?? 'User',
        avatar: args['avatar']?.toString() ?? '',
      ),
      tag: 'chat_$userId',
    );
  }

  @override
  Widget build(BuildContext context) {

    final isTab = context.isTab;

    final controller = _initController();

    return WillPopScope(
      onWillPop: () async {
        _refreshUnreadBadge();
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          toolbarHeight: Get.width > 600 ? 100 : 80,
          elevation: 1,
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
            onPressed: () {
              _refreshUnreadBadge();
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0,
          title: Obx(
            () => Row(
              children: [
                Stack(
                  children: [
                    if (controller.avatar.isNotEmpty)
                      CustomNetworkImage(
                        imageUrl: controller.avatar,
                        height: isTab ? 50 : 48.w,
                        width: isTab ? 50 : 48.w,
                        boxShape: BoxShape.circle,
                      )
                    else
                      Container(
                        height: 48.w,
                        width: 48.w,
                        decoration: const BoxDecoration(
                          color: AppColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: CustomText2(
                          text: controller.userName.isNotEmpty
                              ? controller.userName[0].toUpperCase()
                              : 'U',
                          color: AppColors.white,
                          fontSize: isTab ? 12 : 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          color: controller.isPeerOnline
                              ? AppColors.green
                              : AppColors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText2(
                      text: controller.userName,
                      color: AppColors.black,
                      fontSize: isTab ? 16 : 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText2(
                      text: controller.isPeerOnline ? 'Online' : 'Offline',
                      color: controller.isPeerOnline
                          ? AppColors.green
                          : AppColors.red,
                      fontSize: isTab ? 12 : 12.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.isNotEmpty &&
                    controller.messages.isEmpty) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                final msgs = controller.messages;
                if (msgs.isEmpty) {
                  return Center(child: Text('No messages yet', style: TextStyle(fontSize: isTab ? 10.sp : null),));
                }
                // Auto-scroll to bottom (latest message) after frame builds
                if (msgs.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(
                        _scrollController.position.maxScrollExtent,
                      );
                    }
                  });
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.w,
                  ),
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final m = msgs[index];
                    final mine = controller.isMine(m);
                    return Align(
                      alignment: mine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: isTab ? 12 : 14.w,
                            vertical: isTab ? 5 : 10.w,
                          ),
                          decoration: BoxDecoration(
                            color: mine ? AppColors.lightBlue : AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(mine ? 16 : 4),
                              bottomRight: Radius.circular(mine ? 4 : 16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: mine
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              CustomText2(
                                text: m.text,
                                color: mine ? AppColors.white : AppColors.black,
                                fontSize: isTab ? 18 : 14.sp,
                                maxLines: 100,
                              ),
                              if (m.images.isNotEmpty)
                                ...m.images.map(
                                  (img) => Padding(
                                    padding: EdgeInsets.only(top: 6.h),
                                    child: CustomNetworkImage(
                                      imageUrl: img,
                                      height: 140.w,
                                      width: 140.w,
                                      boxShape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              SizedBox(height: 6.h),
                              CustomText2(
                                text: _formatTime(m.timestamp.toLocal()),
                                fontSize: isTab ? 14 : 10.sp,
                                color: mine
                                    ? Colors.white70
                                    : Colors.black.withValues(alpha: .6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => controller.selectedImages.isNotEmpty
                        ? Container(
                            height: 100.h,
                            margin: EdgeInsets.only(bottom: 8.h),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.selectedImages.length,
                              separatorBuilder: (_, __) => SizedBox(width: 8.w),
                              itemBuilder: (ctx, idx) {
                                final file = controller.selectedImages[idx];
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        file,
                                        height: 100.h,
                                        width: 100.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.removeImage(idx),
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          textEditingController: controller.inputController,
                          fillColor: Colors.grey.withValues(alpha: .1),
                          hintText: 'Write your message',
                          fieldBorderColor: Colors.grey,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.image),
                            onPressed: controller.pickImages,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Obx(
                        () => GestureDetector(
                          onTap: controller.isSending.value
                              ? null
                              : () async {
                                  await controller.sendMessage();
                                  // Scroll to bottom after sending
                                  Future.delayed(
                                    const Duration(milliseconds: 80),
                                    () {
                                      if (_scrollController.hasClients) {
                                        _scrollController.animateTo(
                                          _scrollController
                                              .position
                                              .maxScrollExtent,
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          curve: Curves.easeOut,
                                        );
                                      }
                                    },
                                  );
                                },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: controller.isSending.value
                                  ? AppColors.lightBlue.withValues(alpha: .5)
                                  : AppColors.lightBlue,
                              borderRadius: BorderRadius.circular(70),
                            ),
                            child: controller.isSending.value
                                ? const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        AppColors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.send,
                                    color: AppColors.white,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _refreshUnreadBadge() {
    try {
      if (Get.isRegistered<MainLayoutController>()) {
        final main = Get.find<MainLayoutController>();
        main.fetchUnreadMessagesCount();
      }
    } catch (_) {}
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}
