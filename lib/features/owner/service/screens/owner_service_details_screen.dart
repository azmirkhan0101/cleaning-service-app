import 'package:cleaning_service_app/features/common/widgets/app_bar_tab_bar.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/owner_service_controller.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_details_controller.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/details_tab_view.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/overview_tab_view.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/reviews_tab_view.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/schedule_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerServiceDetailsScreen extends StatefulWidget {
  const OwnerServiceDetailsScreen({super.key});

  @override
  State<OwnerServiceDetailsScreen> createState() =>
      _OwnerServiceDetailsScreenState();
}

class _OwnerServiceDetailsScreenState extends State<OwnerServiceDetailsScreen> {
  final ownerController = Get.find<OwnerServiceController>();
  final serviceDetailsController = Get.put(ServiceDetailsController());

  String status = "";

  @override
  void initState() {
    super.initState();
    //Get the arguments passed through Get
    final arguments = Get.arguments;

    if (arguments != null) {
      //Handle old status argument format
      if (arguments is List && arguments.isNotEmpty) {
        status = arguments[0]["status"];
      }
      // Handle new serviceId argument format
      if (arguments is Map<String, dynamic> && arguments['serviceId'] != null) {
        serviceDetailsController.setServiceId(arguments['serviceId']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTabBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: "Service Details",
        tabTitles: ["Overview", "Details", "Reviews", "Schedule"],
        onTabSelected: (int index) {
          ownerController.selectedIndex.value = index;
          // Fetch data based on selected tab
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
                SizedBox(height: 16),

                /// service details show
                if (ownerController.selectedIndex.value == 0)
                  OverviewTabView(status: status),

                ///Profile section
                if (ownerController.selectedIndex.value == 1) DetailsTabView(),

                ///review section
                if (ownerController.selectedIndex.value == 2) ReviewsTabView(),

                ///Schedule section
                if (ownerController.selectedIndex.value == 3) ScheduleTabView(),
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
        // Overview tab - service details already fetched in setServiceId
        break;
      case 1:
        // Details tab - fetch provider details
        if (serviceDetailsController.providerDetails.value == null) {
          serviceDetailsController.fetchProviderDetails();
        }
        break;
      case 2:
        // Reviews tab - fetch reviews
        if (serviceDetailsController.reviews.isEmpty) {
          serviceDetailsController.fetchReviews();
        }
        break;
      case 3:
        // Schedule tab - fetch schedule
        if (serviceDetailsController.schedule.value == null) {
          serviceDetailsController.fetchSchedule();
        }
        break;
    }
  }

  ///Booking Cancelled showCustomDialog
  // void showCustomDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         insetPadding: EdgeInsets.all(8),
  //         contentPadding: EdgeInsets.all(8),
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             CustomText2(text: ""),
  //
  //             IconButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               icon: Icon(Icons.close, size: 32, color: Colors.black),
  //             ),
  //           ],
  //         ),
  //
  //         // Optional title if provided
  //         content: SizedBox(
  //           width: MediaQuery.sizeOf(context).width,
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 CustomImage(imageSrc: AppImages.cancelled_image),
  //
  //                 CustomText2(
  //                   text: "Booking Cancelled",
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.w600,
  //                   color: AppColors.black,
  //                 ),
  //
  //                 SizedBox(height: 8),
  //
  //                 CustomText2(
  //                   text: "Your booking has been Cancelled \n successfully.",
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w400,
  //                   color: AppColors.neutral03,
  //                 ),
  //
  //                 SizedBox(height: 8),
  //
  //                 CustomButton(
  //                   onTap: () {
  //                     Get.to(OwnerBookingScreen());
  //
  //                     // Navigator.of(context).pop();
  //                   },
  //                   title: "Ok",
  //                   fontSize: 16, // Bigger button text for tablets
  //                   width: double.infinity,
  //                   height: 50,
  //                   fillColor: AppColors.appColors,
  //                   borderRadius: 24,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
