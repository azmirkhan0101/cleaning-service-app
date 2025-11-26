import 'package:cleaning_service_app/features/bookings/controllers/owner_booking_controller.dart';
import 'package:cleaning_service_app/features/bookings/widgets/owner_my_booking_card.dart';
import 'package:cleaning_service_app/features/common/widgets/app_bar_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerBookingScreen extends StatefulWidget {
  const OwnerBookingScreen({super.key});

  @override
  State<OwnerBookingScreen> createState() => _OwnerBookingScreenState();
}

class _OwnerBookingScreenState extends State<OwnerBookingScreen> {
  final ownerBookingController = Get.find<BookingController>();

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
          // Keep pull-to-refresh active even when empty
          return RefreshIndicator(
            onRefresh: ownerBookingController.refreshBookings,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
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
                    ),
                  ),
                );
              },
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: ownerBookingController.refreshBookings,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
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
