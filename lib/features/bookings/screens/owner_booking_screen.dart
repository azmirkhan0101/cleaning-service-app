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
  final ownerBookingController = Get.find<OwnerBookingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTabBar(
        title: "My Booking",
        tabTitles: ownerBookingController.tabTitles,
        onTabSelected: ownerBookingController.filterServices,
      ),
      body: Obx(() {
        if (ownerBookingController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ownerBookingController.filteredBookings.isEmpty) {
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
              itemBuilder: (context, index) {
                return OwnerMyBookingCard(
                  booking: ownerBookingController.filteredBookings[index],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
              itemCount: ownerBookingController.filteredBookings.length,
            ),
          ),
        );
      }),
    );
  }
}
