import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/bookings/controllers/owner_booking_controller.dart';
import 'package:cleaning_service_app/features/bookings/controllers/provider_booking_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final controller = Get.put(ProviderBookingDetailsController());
  String status = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    final arguments = Get.arguments;

    if (arguments != null && arguments.isNotEmpty) {
      final firstArg = arguments[0] as Map<String, dynamic>;

      if (firstArg["status"] != null) {
        status = firstArg["status"];
      }

      if (firstArg["bookingId"] != null) {
        controller.setBookingId(firstArg["bookingId"]);
      }
    }
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  String _getDayOfWeek(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEEE').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  int _getDay(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 0;
    try {
      final date = DateTime.parse(dateStr);
      return date.day;
    } catch (e) {
      return 0;
    }
  }

  String _getMonth(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM').format(date).toUpperCase();
    } catch (e) {
      return 'N/A';
    }
  }

  Future<void> _handleAcceptBooking() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Booking'),
        content: const Text('Are you sure you want to accept this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.appColors,
            ),
            child: const Text('Accept'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await controller.acceptBooking();

    if (success) {
      Fluttertoast.showToast(
        msg: "Booking accepted successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Get the booking controller and refresh all bookings
      if (Get.isRegistered<BookingController>()) {
        final bookingController = Get.find<BookingController>();
        // Refresh all booking tabs to get updated data
        await bookingController.refreshAllBookings();
        // Navigate back and set tab to Ongoing (index 2)
        bookingController.selectedTabIndex.value = 2;
      }

      // Navigate back to bookings screen
      Get.back();
    } else {
      Fluttertoast.showToast(
        msg: controller.errorMessage.value.isNotEmpty
            ? controller.errorMessage.value
            : "Failed to accept booking",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _handleRejectBooking() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Booking'),
        content: const Text('Are you sure you want to reject this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await controller.rejectBooking();

    if (success) {
      Fluttertoast.showToast(
        msg: "Booking rejected successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Get the booking controller and refresh all bookings
      if (Get.isRegistered<BookingController>()) {
        final bookingController = Get.find<BookingController>();
        // Refresh all booking tabs to get updated data
        await bookingController.refreshAllBookings();
        // Navigate back and set tab to Cancelled (index 4)
        bookingController.selectedTabIndex.value = 4;
      }

      // Navigate back to bookings screen
      Get.back();
    } else {
      Fluttertoast.showToast(
        msg: controller.errorMessage.value.isNotEmpty
            ? controller.errorMessage.value
            : "Failed to reject booking",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("------> ${controller.bookingDetails.value?.id}");
    return Scaffold(
      appBar: CustomAppBar(title: "Booking Details", backButton: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refreshBookingDetails,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final bookingData = controller.bookingDetails.value;
        if (bookingData == null) {
          return const Center(child: Text('No booking data available'));
        }

        final booking = bookingData.booking;
        final customer = bookingData.customer;

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Date and Time Card
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                child: Card(
                  elevation: 0.5,
                  color: AppColors.neutral02.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  CustomText2(
                                    text: "${_getDay(booking.scheduledAt)}",
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  CustomText2(
                                    text: _getMonth(booking.scheduledAt),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText2(
                                  text: _getDayOfWeek(booking.scheduledAt),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                                const SizedBox(height: 8),
                                CustomText2(
                                  text:
                                      "Time: ${_formatTime(booking.scheduledAt)}",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Service Card
              ProviderServiceCard(
                status: booking.status,
                imageUrl: booking.oneImage,
                serviceName: booking.name,
                location: booking.address.city,
                serviceDetails: booking.description,
                price: booking.rateByHour,
                duration: booking.serviceDuration,
                totalAmount: booking.totalAmount,
              ),

              const SizedBox(height: 8),

              // Customer Details Card
              Card(
                elevation: 0.2,
                color: AppColors.white,
                margin: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText2(
                        text: 'Customer Details',
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        fontSize: 18,
                      ),
                      const SizedBox(height: 16),

                      CustomText2(
                        text: 'Name',
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 8),
                      CustomText2(
                        text: customer.name,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 12),

                      CustomText2(
                        text: 'Phone Number',
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 8),
                      CustomText2(
                        text: customer.phoneNumber,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 12),

                      CustomText2(
                        text: 'Email',
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 8),
                      CustomText2(
                        text: customer.email,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 12),

                      CustomText2(
                        text: 'Address',
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 8),
                      CustomText2(
                        text: customer.address,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                        fontSize: 14,
                      ),

                      if (customer.description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        CustomText2(
                          text: 'Description',
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                          fontSize: 14,
                        ),
                        const SizedBox(height: 8),
                        CustomText2(
                          text: customer.description,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14,
                          maxLines: 5,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Action Buttons based on status
              if (booking.status.toUpperCase() != "CANCELLED" &&
                  booking.status.toUpperCase() != "COMPLETED")
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (booking.status.toUpperCase() == "PENDING")
                        ElevatedButton(
                          onPressed: controller.isAccepting.value
                              ? null
                              : _handleAcceptBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appColors,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.4,
                              50,
                            ),
                          ),
                          child: controller.isAccepting.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : CustomText2(
                                  text: 'Accept',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                        ),

                      if (booking.status.toUpperCase() == "PENDING")
                        ElevatedButton(
                          onPressed: controller.isRejecting.value
                              ? null
                              : _handleRejectBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white_50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            elevation: 0,
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.4,
                              50,
                            ),
                          ),
                          child: controller.isRejecting.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                )
                              : CustomText2(
                                  text: 'Reject',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                    ],
                  ),
                ),

              if (booking.status.toUpperCase() == "ONGOING")
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.qrScannerScreen,
                        arguments: [
                          {"bookingId": controller.bookingId.value},
                        ],
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
                      ),
                    ),
                    child: CustomText2(
                      text: 'QR Code',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 8),
            ],
          ),
        );
      }),
    );
  }
}

class ProviderServiceCard extends StatelessWidget {
  final String status;
  final String imageUrl;
  final String serviceName;
  final String location;
  final String serviceDetails;
  final double price;
  final int duration;
  final double totalAmount;

  const ProviderServiceCard({
    super.key,
    required this.status,
    required this.imageUrl,
    required this.serviceName,
    required this.location,
    required this.serviceDetails,
    required this.price,
    required this.duration,
    required this.totalAmount,
  });

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppColors.danger;
      case 'COMPLETED':
        return AppColors.normal;
      case 'ONGOING':
        return AppColors.lightBlue;
      case 'CANCELLED':
        return AppColors.cancle;
      default:
        return AppColors.white_50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      imageUrl.isNotEmpty &&
                          (imageUrl.startsWith('http://') ||
                              imageUrl.startsWith('https://'))
                      ? Image.network(
                          imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              AppImages.clean_image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          AppImages.clean_image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomText2(
                              text: serviceName,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomText2(
                              text: status.toUpperCase(),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CustomText2(
                        text: 'Location: $location',
                        color: AppColors.neutral03,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 8),
                      CustomText2(
                        text: serviceDetails,
                        color: AppColors.neutral03,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomText2(
              text: 'Price Details',
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText2(
                  text: 'Price',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  color: AppColors.black,
                ),
                CustomText2(text: '€${price.toStringAsFixed(2)}/hr'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText2(text: 'Duration'),
                CustomText2(text: '$duration hr'),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText2(
                  text: 'Total',
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightBlue,
                ),
                CustomText2(
                  text: '€${totalAmount.toStringAsFixed(2)}',
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightBlue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
