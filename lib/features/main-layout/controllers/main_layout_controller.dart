import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/features/bookings/screens/owner_booking_screen.dart';
import 'package:cleaning_service_app/features/bookings/screens/provider_bookings_screen.dart';
import 'package:cleaning_service_app/features/main-layout/models/bottom_nav_model.dart';
import 'package:cleaning_service_app/features/owner/home/screens/owner_home_screen.dart';
import 'package:cleaning_service_app/features/owner/inbox/owner_inbox_screen.dart';
import 'package:cleaning_service_app/features/owner/service/screens/owner_category_screen.dart';
import 'package:cleaning_service_app/features/profile/screens/profile_screen.dart';
import 'package:cleaning_service_app/features/provider/home/screens/provider_home_screen.dart';
import 'package:cleaning_service_app/features/provider/inbox/inbox_screen.dart';
import 'package:cleaning_service_app/features/provider/service/screens/provider_services_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainLayoutController extends GetxController {
  MainLayoutController({required this.isOwner});
  final bool isOwner;
  List<BottomNavModel> bottomNavItems = [];
  // Observable for current selected index
  final RxInt selectedIndex = 0.obs;
  late Widget selectedScreen;

  @override
  void onInit() {
    // initialize bottom nav items and the initial selected screen based on role
    organizeBottomNavItems(isOwner);
    selectedScreen = isOwner ? const OwnerHomeScreen() : ProviderHome();
    super.onInit();
  }

  // Method to change the tab
  void changeTab(int index) {
    selectedIndex.value = index;
    selectedScreen = isOwner
        ? bottomNavItems[index].ownerScreen!
        : bottomNavItems[index].providerScreen!;
    update();
  }

  void organizeBottomNavItems(bool isOwner) {
    bottomNavItems.clear();
    for (int i = 0; i < bottomNavList.length; i++) {
      if (isOwner && i == 3) continue;
      if (!isOwner && i == 1) continue;
      bottomNavItems.add(
        BottomNavModel(
          label: bottomNavList[i].label,
          selectedIconPath: bottomNavList[i].selectedIconPath,
          unselectedIconPath: bottomNavList[i].unselectedIconPath,
          ownerScreen: bottomNavList[i].ownerScreen,
          providerScreen: bottomNavList[i].providerScreen,
        ),
      );
    }
    update();
  }

  final List<BottomNavModel> bottomNavList = [
    BottomNavModel(
      label: 'Home',
      selectedIconPath: Assets.icons.homeFilled.path,
      unselectedIconPath: Assets.icons.homeOutline.path,
      ownerScreen: const OwnerHomeScreen(),
      providerScreen: ProviderHome(),
    ),
    BottomNavModel(
      label: 'Services',
      selectedIconPath: Assets.icons.servicesFilled.path,
      unselectedIconPath: Assets.icons.serviceOutline.path,
      ownerScreen: const OwnerCategoryScreen(),
      providerScreen: ServiceScreen(),
    ),
    BottomNavModel(
      label: 'Bookings',
      selectedIconPath: Assets.icons.bookingsFilled.path,
      unselectedIconPath: Assets.icons.bookingsOutline.path,
      ownerScreen: const OwnerBookingScreen(),
      providerScreen: ProviderBookingsScreen(),
    ),
    BottomNavModel(
      label: 'Services',
      selectedIconPath: Assets.icons.serviceOutlineProvider.path,
      unselectedIconPath: Assets.icons.serviceOutlineProvider.path,
      ownerScreen: const OwnerCategoryScreen(),
      providerScreen: ServiceScreen(),
    ),
    BottomNavModel(
      label: 'Inbox',
      selectedIconPath: Assets.icons.inboxFilled.path,
      unselectedIconPath: Assets.icons.inboxOutline.path,
      ownerScreen: const OwnerInboxScreen(),
      providerScreen: const ProviderInboxScreen(),
    ),
    BottomNavModel(
      label: 'Profile',
      selectedIconPath: Assets.icons.profileFilled.path,
      unselectedIconPath: Assets.icons.profileOutliine.path,
      ownerScreen: const ProfileScreen(),
      providerScreen: const ProfileScreen(),
    ),
  ];
}
