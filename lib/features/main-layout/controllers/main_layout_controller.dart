import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/bookings/screens/owner_booking_screen.dart';
import 'package:cleaning_service_app/features/bookings/screens/provider_bookings_screen.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:cleaning_service_app/features/inbox/screens/inbox_screen.dart';
import 'package:cleaning_service_app/features/main-layout/models/bottom_nav_model.dart';
import 'package:cleaning_service_app/features/owner/home/screens/owner_home_screen.dart';
import 'package:cleaning_service_app/features/owner/service/screens/owner_category_screen.dart';
import 'package:cleaning_service_app/features/profile/screens/profile_screen.dart';
import 'package:cleaning_service_app/features/provider/home/screens/provider_home_screen.dart';
import 'package:cleaning_service_app/features/provider/service/screens/provider_services_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainLayoutController extends GetxController {
  MainLayoutController({required this.isOwner});
  final bool isOwner;
  List<BottomNavModel> bottomNavItems = [];
  // Observable for current selected index
  final RxInt selectedIndex = 0.obs;
  final Rx<String?> userRole = AppStorageService.getUserRole().obs;
  Rx<Widget> selectedScreen =
      AppStorageService.getUserRole() == Role.owner.value
      ? Rx<Widget>(const OwnerHomeScreen())
      : Rx<Widget>(ProviderHome());
  final unreadMessagesCount = 0.obs;
  late final NetworkHelper _networkHelper;

  @override
  void onInit() {
    // initialize bottom nav items and the initial selected screen based on role
    organizeBottomNavItems(isOwner);
    selectedScreen = Rx<Widget>(
      isOwner ? const OwnerHomeScreen() : ProviderHome(),
    );
    _networkHelper = Get.find<NetworkHelper>();
    fetchUnreadMessagesCount();
    super.onInit();
  }

  // Method to change the tab
  void changeTab(int index) {
    selectedIndex.value = index;
    selectedScreen.value = isOwner
        ? bottomNavItems[index].ownerScreen!
        : bottomNavItems[index].providerScreen!;
    // Refresh unread count when navigating to inbox (index 3 for both roles after filtering)
    if (index == 3) {
      fetchUnreadMessagesCount();
    }
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
      ownerScreen: const InboxUsersScreen(),
      providerScreen: const InboxUsersScreen(),
      // providerScreen: const ProviderInboxScreen(),
    ),
    BottomNavModel(
      label: 'Profile',
      selectedIconPath: Assets.icons.profileFilled.path,
      unselectedIconPath: Assets.icons.profileOutliine.path,
      ownerScreen: const ProfileScreen(),
      providerScreen: const ProfileScreen(),
    ),
  ];

  Future<void> fetchUnreadMessagesCount() async {
    final result = await _networkHelper.get<Map<String, dynamic>>(
      ApiUrl.messagesUnreadCount,
      parser: (data) => data as Map<String, dynamic>,
    );

    result.match((err) {}, (res) {
      final count = res['data']?['unreadCount'];
      if (count is int) {
        unreadMessagesCount.value = count;
      } else {
        unreadMessagesCount.value = int.tryParse(count?.toString() ?? '0') ?? 0;
      }
    });
  }
}
