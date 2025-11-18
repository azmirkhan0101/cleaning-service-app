import 'package:cleaning_service_app/features/bookings/controllers/owner_booking_controller.dart';
import 'package:cleaning_service_app/features/bookings/widgets/owner_my_booking_card.dart';
import 'package:cleaning_service_app/features/common/widgets/app_bar_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderBookingsScreen extends StatefulWidget {
  const ProviderBookingsScreen({super.key});

  @override
  State<ProviderBookingsScreen> createState() => _ProviderBookingsScreenState();
}

class _ProviderBookingsScreenState extends State<ProviderBookingsScreen> {
  final ownerBookingController = Get.find<BookingController>();
  final appBarTabController = Get.put(
    AppBarTabBarController(),
    permanent: false,
  );

  @override
  void initState() {
    super.initState();
    // Sync initial tab selection from navigation args or existing controller state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int index = ownerBookingController.selectedTabIndex.value;
      final args = Get.arguments;
      if (args is List && args.isNotEmpty && args.first is Map) {
        final status = (args.first as Map)["status"]?.toString().toUpperCase();
        if (status != null) {
          switch (status) {
            case 'ALL':
              index = 0;
              break;
            case 'PENDING':
            case 'ACCEPT':
              index = 1;
              break;
            case 'ONGOING':
              index = 2;
              break;
            case 'COMPLETED':
              index = 3;
              break;
            case 'CANCELLED':
            case 'CANCELED':
              index = 4;
              break;
          }
          ownerBookingController.filterServices(index);
        }
      }
      // Ensure AppBarTabBar highlights the same tab as the bookings controller
      appBarTabController.selectTab(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTabBar(
        title: "My Booking",
        tabTitles: ownerBookingController.tabTitles,
        onTabSelected: ownerBookingController.filterServices,
      ),
      body: Obx(() {
        if (ownerBookingController.isCurrentlyLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentBookings = ownerBookingController.currentBookings;

        if (currentBookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No bookings found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ownerBookingController.selectedTabIndex.value == 0
                      ? 'You don\'t have any bookings yet'
                      : 'No ${ownerBookingController.tabTitles[ownerBookingController.selectedTabIndex.value].toLowerCase()} bookings',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: ownerBookingController.refreshBookings,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
              controller: ownerBookingController.scrollController,
              itemBuilder: (context, index) {
                // Show loading indicator at bottom for "All" tab pagination
                if (index == currentBookings.length) {
                  return Obx(() {
                    if (ownerBookingController.isLoadingMore.value) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const SizedBox.shrink();
                  });
                }

                return OwnerMyBookingCard(booking: currentBookings[index]);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
              itemCount:
                  currentBookings.length +
                  (ownerBookingController.selectedTabIndex.value == 0 &&
                          ownerBookingController.hasMore.value
                      ? 1
                      : 0),
            ),
          ),
        );
      }),
    );
  }
}
