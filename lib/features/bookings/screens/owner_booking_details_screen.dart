import 'package:cleaning_service_app/features/common/widgets/app_bar_tab_bar.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/owner_service_controller.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_details_controller.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/details_tab_view.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/overview_tab_view.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/reviews_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerBookingDetailsScreen extends StatefulWidget {
  const OwnerBookingDetailsScreen({super.key});

  @override
  State<OwnerBookingDetailsScreen> createState() =>
      _OwnerBookingDetailsScreenState();
}

class _OwnerBookingDetailsScreenState extends State<OwnerBookingDetailsScreen> {
  final ownerController = Get.put(OwnerServiceController());
  final serviceDetailsController = Get.put(ServiceDetailsController());

  String status = "";

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      final bookingId = args['bookingId'] as String?;
      status = args['status']?.toString() ?? '';
      if (bookingId != null && bookingId.isNotEmpty) {
        serviceDetailsController.setBookingId(bookingId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTabBar(
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: "Booking Details",
        tabTitles: const ["Overview", "Details", "Reviews"],
        onTabSelected: (int index) {
          ownerController.selectedIndex.value = index;
          _fetchDataForTab(index);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                if (ownerController.selectedIndex.value == 0)
                  OverviewTabView(status: status),
                if (ownerController.selectedIndex.value == 1)
                  const DetailsTabView(),
                if (ownerController.selectedIndex.value == 2)
                  const ReviewsTabView(),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _fetchDataForTab(int index) {
    switch (index) {
      case 0:
        // Overview - already loaded by booking details API
        break;
      case 1:
        // Details - provider details came with booking API; nothing extra required
        break;
      case 2:
        // Reviews - fetch via serviceId if available
        if (serviceDetailsController.reviews.isEmpty &&
            serviceDetailsController.serviceId.isNotEmpty) {
          serviceDetailsController.fetchReviews();
        }
        break;
    }
  }
}
