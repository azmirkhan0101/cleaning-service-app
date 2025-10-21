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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<OwnerBookingController>(
          builder: (controller) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return OwnerMyBookingCard(index: index, controller: controller);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
              itemCount: controller.filteredServices.length,
            );
          },
        ),
      ),
    );
  }
}
