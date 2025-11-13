import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart'
    show AppColors;
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/common/widgets/bulleted_list.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_booking_controller.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_details_controller.dart';
import 'package:cleaning_service_app/features/payment/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceBookingStepTwo extends StatelessWidget {
  ServiceBookingStepTwo({super.key});

  final paymentController = Get.find<PaymentController>();

  final bookingController = Get.find<ServiceBookingController>();
  final serviceDetailsController = Get.find<ServiceDetailsController>();

  String _weekdayName(DateTime date) {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[date.weekday - 1];
  }

  String _monthAbbrev(DateTime date) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[date.month - 1];
  }

  String _dayOfMonth(DateTime date) => '${date.day}';

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formattedTotal() {
    final duration =
        int.tryParse(bookingController.durationController.text) ?? 2;
    final pricePerHourStr =
        serviceDetailsController.serviceDetails.value?.rateByHour.toString() ??
        '0';
    final pricePerHour = double.tryParse(pricePerHourStr) ?? 0.0;
    final total = duration * pricePerHour;
    return '€${total.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          child: Card(
            elevation: 0.5,
            color: AppColors.neutral02.withValues(alpha: 0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Date and Day
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: [
                            CustomText2(
                              text: _dayOfMonth(
                                bookingController.selectedDate.value,
                              ),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            CustomText2(
                              text: _monthAbbrev(
                                bookingController.selectedDate.value,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText2(
                            text: _weekdayName(
                              bookingController.selectedDate.value,
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),

                          SizedBox(height: 8),
                          // Time and Buffer Time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText2(
                                text:
                                    "Time: ${_formatTime(bookingController.selectedTime.value)}",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                              SizedBox(width: 8),
                              CustomText2(
                                text: "Buffer Time: 30 minutes",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ],
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

        SizedBox(height: 8),

        /// Bill & Details
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText2(
                text: "Bill & Details",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neutral02,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const CustomText(
                      text: 'Total Bill: ',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    CustomText(
                      text: _formattedTotal(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12),

        /// service name
        BookingStepServiceCard(
          status: '',
          title:
              serviceDetailsController.serviceDetails.value?.serviceName ??
              'N/A',
          imageUrl:
              serviceDetailsController.serviceDetails.value?.coverImage ?? '',
          address: bookingController.addressController.text.isEmpty
              ? 'Set address'
              : bookingController.addressController.text,
          phone: bookingController.phoneNumberController.text.isEmpty
              ? '—'
              : bookingController.phoneNumberController.text,
          serviceDetails: bookingController.descriptionController.text.isEmpty
              ? 'No additional instructions.'
              : bookingController.descriptionController.text,
          price:
              double.tryParse(
                serviceDetailsController.serviceDetails.value?.rateByHour ??
                    '0',
              ) ??
              0.0,
          duration:
              int.tryParse(bookingController.durationController.text) ?? 2,
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Payment Method',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),

            const SizedBox(height: 8),

            // CustomImage(imageSrc: Assets.icons.badge.path),
            Assets.icons.stripe.svg(),

            const SizedBox(height: 16),

            /// Pay Button
            CustomText(
              text: 'Cancellation & Refund Policy',
              color: const Color(0xFF0F0B18),
              fontSize: 14,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),

            // SizedBox(height: 12),
            BulletedList(
              text: 'You can cancel your booking within 2 hours of placing it.',
            ),
            BulletedList(
              text: 'After 2 hours, cancellation will not be allowed.',
            ),
            BulletedList(
              text:
                  'If you cancel within the allowed time, the full amount will be refunded to your account.',
            ),
          ],
        ),

        SizedBox(height: 24),

        ElevatedButton(
          onPressed: () {
            ///Get.toNamed(AppRoutes.serviceBookSecondScreen);

            // showCustomDialog(context);
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
            text: 'Continue',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}

/// Booking confirmation dialog
void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(8),
        contentPadding: EdgeInsets.all(8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText2(text: ""),

            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close, size: 32, color: Colors.black),
            ),
          ],
        ),

        // Optional title if provided
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImage(imageSrc: AppImages.alertImage),

                const SizedBox(height: 8),
                const CustomText2(
                  text: "Booking Done",
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                const SizedBox(height: 8),
                const CustomText2(
                  text: "You have successfully made an order",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutral03,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onTap: () => Get.offNamed(AppRoutes.ownerHomeScreen),
                  title: "Back to Home",
                  fontSize: 16,
                  width: double.infinity,
                  height: 50,
                  fillColor: AppColors.appColors,
                  borderRadius: 24,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class BookingStepServiceCard extends StatelessWidget {
  final String status;
  final String title;
  final String imageUrl;
  final String address;
  final String phone;
  final String serviceDetails;
  final double price;
  final int duration;

  const BookingStepServiceCard({
    super.key,
    required this.status,
    required this.title,
    required this.imageUrl,
    required this.address,
    required this.phone,
    required this.serviceDetails,
    required this.price,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomNetworkImage(
                    imageUrl: imageUrl,
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText2(
                            text: title,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CustomText2(
                        text: 'Location: $address',
                        color: AppColors.neutral03,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: AppColors.lightBlue,
                          ),
                          const SizedBox(width: 4),
                          CustomText2(
                            text: phone,
                            color: AppColors.neutral03,
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CustomText2(
                        text: serviceDetails,
                        color: AppColors.neutral03,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const CustomText2(
              text: 'Price Details',
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText2(
                  text: 'Price',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.black,
                ),
                CustomText2(text: '€${price.toStringAsFixed(2)}hr'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText2(text: 'Duration'),
                CustomText2(text: '$duration hr'),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText2(
                  text: 'Total',
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightBlue,
                ),
                CustomText2(
                  text: '€${(price * duration).toStringAsFixed(2)}',
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
