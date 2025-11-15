import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/main-layout/controllers/main_layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key, this.isOwner = false});
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    print('isOwner:---> $isOwner');
    final controller = Get.put(
      MainLayoutController(isOwner: isOwner),
      permanent: true,
    );

    return Scaffold(
      body: Obx(() => controller.selectedScreen.value),
      // body: GetBuilder<MainLayoutController>(
      //   builder: (ctrl) => ctrl.selectedScreen,
      // ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Color(0xFFF5F4FF)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(controller.bottomNavItems.length, (
                  index,
                ) {
                  final isSelected = controller.selectedIndex.value == index;
                  return _buildNavItem(controller, index, isSelected);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    MainLayoutController controller,
    int index,
    bool isSelected,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.changeTab(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    isSelected
                        ? controller.bottomNavItems[index].selectedIconPath
                        : controller.bottomNavItems[index].unselectedIconPath,
                    height: 34,
                    width: 34,

                    colorFilter: ColorFilter.mode(
                      isSelected ? AppColors.blue : AppColors.grey_1,
                      BlendMode.srcIn,
                    ),
                  ),
                  if ((isOwner && index == 2) || (!isOwner && index == 1))
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFDE5640),
                          shape: OvalBorder(),
                        ),
                        child: Center(
                          child: Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (index == 3 && controller.unreadMessagesCount.value > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        width: controller.unreadMessagesCount.value > 99
                            ? 22
                            : 16,
                        height: 16,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFDE5640),
                          shape: OvalBorder(),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Center(
                          child: Text(
                            controller.unreadMessagesCount.value > 0
                                ? (controller.unreadMessagesCount.value > 99
                                      ? '99+'
                                      : controller.unreadMessagesCount.value
                                            .toString())
                                : '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                controller.bottomNavItems[index].label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.blue : AppColors.grey_1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
