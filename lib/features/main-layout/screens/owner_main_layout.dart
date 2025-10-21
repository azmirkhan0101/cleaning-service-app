import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/main-layout/controllers/owner_main_layout_controller.dart';
import 'package:cleaning_service_app/features/bookings/screens/owner_booking_screen.dart';
import 'package:cleaning_service_app/features/owner/home/owner_home_screen.dart';
import 'package:cleaning_service_app/features/owner/inbox/owner_inbox_screen.dart';
import 'package:cleaning_service_app/features/owner/profile/profile_screen.dart';
import 'package:cleaning_service_app/features/owner/service/screens/owner_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OwnerMainLayout extends StatelessWidget {
  const OwnerMainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OwnerMainLayoutController());

    final List<String> selectedNavIcons = [
      Assets.icons.homeFilled.path,
      Assets.icons.servicesFilled.path,
      Assets.icons.bookingsFilled.path,
      Assets.icons.inboxFilled.path,
      Assets.icons.profileFilled.path,
    ];

    final List<String> unselectedNavIcons = [
      Assets.icons.homeOutline.path,
      Assets.icons.serviceOutline.path,
      Assets.icons.bookingsOutline.path,
      Assets.icons.inboxOutline.path,
      Assets.icons.profileOutliine.path,
    ];

    final List<String> navbarLabels = [
      'Home',
      'Services',
      'Bookings',
      'Inbox',
      'Profile',
    ];

    final List<Widget> screens = [
      const OwnerHomeScreen(),
      const OwnerCategoryScreen(),
      const OwnerBookingScreen(),
      const OwnerInboxScreen(),
      const OwnerProfileScreen(),
    ];

    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Color(0xFFF5F4FF)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  final isSelected = controller.selectedIndex.value == index;
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
                                      ? selectedNavIcons[index]
                                      : unselectedNavIcons[index],
                                  height: 34,
                                  width: 34,

                                  colorFilter: ColorFilter.mode(
                                    isSelected
                                        ? AppColors.blue
                                        : AppColors.grey_1,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                if (index == 2)
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
                                if (index == 3)
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
                                          '3',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
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
                              navbarLabels[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppColors.blue
                                    : AppColors.grey_1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
