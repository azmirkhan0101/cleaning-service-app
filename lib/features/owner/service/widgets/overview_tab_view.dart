import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/helper/extension/base_extensions.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/bookings/controllers/owner_booking_controller.dart';
import 'package:cleaning_service_app/features/owner/booking/owner_scanner_screen.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class OverviewTabView extends StatelessWidget {
  const OverviewTabView({super.key, this.status});
  final String? status;

  static const double _tileAspect = 140 / 90;
  static const _radius = 10.0;

  Future<void> _handleCancelBooking(BuildContext context) async {
    final serviceDetailsController = Get.find<ServiceDetailsController>();

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text(
            'Are you sure you want to cancel this booking? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final success = await serviceDetailsController.cancelBooking();

    if (success) {
      Fluttertoast.showToast(
        msg: "Booking cancelled successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Get the booking controller and refresh all bookings
      if (Get.isRegistered<OwnerBookingController>()) {
        final bookingController = Get.find<OwnerBookingController>();
        // Refresh all booking tabs to get updated data
        await bookingController.refreshAllBookings();
        // Navigate back first
        Get.back();
        // Then switch tab to Cancelled (index 4)
        bookingController.filterServices(4);
      } else {
        // If controller not registered, just go back
        Get.back();
      }
    } else {
      Fluttertoast.showToast(
        msg: serviceDetailsController.errorMessage.value.isNotEmpty
            ? serviceDetailsController.errorMessage.value
            : "Failed to cancel booking",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceDetailsController = Get.find<ServiceDetailsController>();

    return Obx(() {
      final serviceDetails = serviceDetailsController.serviceDetails.value;

      if (serviceDetailsController.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (serviceDetails == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Text('No service details available'),
          ),
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: serviceDetails.oneImage,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 140,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                height: 140,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported, size: 50),
              ),
            ),
          ),

          // Service info (name, price, rating)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText2(
                          text: 'Start from',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '€${serviceDetails.rateByHour}/hr',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.pickerMapScreen);
                      },
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText2(
                            text: 'Map View',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(height: 8),
                          CustomImage(imageSrc: AppImages.location),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 20),
                        Text(
                          serviceDetails.averageRatings.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    CustomText2(
                      text: '${serviceDetails.totalOrders} Orders',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle,
                size: 24,
                color: AppColors.lightBlue,
              ),
              const SizedBox(width: 8),
              CustomText2(
                text: serviceDetails.instantBooking
                    ? 'Instant Booking'
                    : 'Approval Required',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),

          const SizedBox(height: 16),
          const CustomText2(
            text: 'Description',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          Text(
            serviceDetails.description,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.justify,
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          const Text(
            'Photos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: _tileAspect,
            ),
            itemCount: serviceDetails.photos.length,
            itemBuilder: (context, index) {
              final imageUrl = serviceDetails.photos[index];
              return Card(
                elevation: 0.3,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_radius),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          if (status == "pending")
            Obx(
              () => ElevatedButton(
                onPressed: serviceDetailsController.isCancelling.value
                    ? null
                    : () => _handleCancelBooking(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appColors,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.9,
                    50,
                  ),
                ),
                child: serviceDetailsController.isCancelling.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : CustomText2(
                        text: 'Cancel',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
              ),
            ),

          if (status == "ongoing") //
            ElevatedButton(
              onPressed: () {
                // Get.toNamed(AppRoutes.ownerScannerScreen);
                Get.to(OwnerScannerScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColors,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.9,
                  50,
                ), // 90% of screen width
              ),
              child: CustomText2(
                text: 'Scan',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

          if (status == "completed") SizedBox(),

          if (status != "pending" &&
              status != "completed" &&
              status != "ongoing" &&
              status != "cancelled")
            ElevatedButton(
              onPressed: () {
                // Pass serviceId to booking screen
                Get.toNamed(
                  AppRoutes.serviceBooking,
                  arguments: {
                    'serviceId': serviceDetailsController.serviceId.value,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColors,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.9,
                  50,
                ), // 90% of screen width
              ),
              child: CustomText2(
                text: 'Book now',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          24.w.heightBox,
        ],
      );
    });
  }
}
