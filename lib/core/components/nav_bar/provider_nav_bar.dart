// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/features/bookings/bookings_screen.dart';
import 'package:cleaning_service_app/core/features/bookings/service_details_screen.dart';
import 'package:cleaning_service_app/core/features/owner/inbox/owner_inbox_screen.dart';
import 'package:cleaning_service_app/core/features/provider/profile/profile_screen.dart';
import 'package:cleaning_service_app/core/features/provider/provider_home.dart';
import 'package:cleaning_service_app/core/features/service/service_screen.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';




class NavBar extends StatefulWidget {
  final int currentIndex;
  const NavBar({required this.currentIndex, super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int bottomNavIndex;

  final List<String> selectedIcon = [
    AppIcons.home,
    AppIcons.booking,
    AppIcons.service,
    AppIcons.inbox,
    AppIcons.profile,

  ];


  final List<String> unselectedIcon = [
    AppIcons.home,
    AppIcons.booking,
    AppIcons.service,
    AppIcons.inbox,
    AppIcons.profile,
  ];

  final List<String> userNavText = [
    AppStrings.home,
    AppStrings.bookings,
    AppStrings.service,
    AppStrings.inbox,
    AppStrings.profile,
  ];

  @override
  void initState() {
    bottomNavIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        final isTablet = constraints.maxWidth > 600;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            color: AppColors.grey_3.withOpacity(0.5),
            borderRadius: BorderRadius.only(
                topLeft:Radius.circular(50),
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)
            ),
          ),
          height: 80.h, // Adjust height for tablets
          width: constraints.maxWidth,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Equal spacing
            children: List.generate(
              selectedIcon.length,
                  (index) => Expanded( // Ensures even distribution
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (index == bottomNavIndex)
                        _buildSelectedNavItem(index, isTablet)
                      else
                        _buildUnselectedNavItem(index, isTablet),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// **Selected Navigation Item (Highlighted Button)**
  Widget _buildSelectedNavItem(int index, bool isTablet) {
    return Card(
      elevation: 70,
      shadowColor: AppColors.lightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft:Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12)
        ),
      ),
      color: Colors.transparent,
      child: Container(
        height: 70.h,
        width:  70.w,
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius:  BorderRadius.only(
              topLeft:Radius.circular(50),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12)
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              selectedIcon[index],
              height:24.h,
              width: 24.w,
              color: AppColors.white_50,
            ),

            SizedBox(height: 6),
            CustomText(
              text: userNavText[index],
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 6.sp : 12.w,
            ),
          ],
        ),
      ),
    );
  }

  /// **Unselected Navigation Item**
  Widget _buildUnselectedNavItem(int index, bool isTablet) {
    return Column(
      children: [
        SvgPicture.asset(
          unselectedIcon[index],
          height: 24.h,
          width: 24.w,
          color: AppColors.grey_1,
        ),
        SizedBox(height: 4),
        CustomText(
          text: userNavText[index],
          color: AppColors.grey_1,
          fontWeight: FontWeight.w600,
          fontSize: isTablet ? 6.sp : 12.sp,
        ),
      ],
    );
  }

  /// **Navigation Tap Logic**
  void onTap(int index) {
    if (index != bottomNavIndex) {
      switch (index) {
        case 0:
         Get.offAll(() => ProviderHome());
          break;
        case 1:
           Get.offAll(() => BookingsScreen());
          break;
        case 2:
            Get.offAll(() => ServiceScreen());

          break;
        case 3:
          Get.offAll(() => OwnerInboxScreen());
          break;

        case 4:
          Get.offAll(() => ProfileScreen());
          break;
      }
    }
  }
}
