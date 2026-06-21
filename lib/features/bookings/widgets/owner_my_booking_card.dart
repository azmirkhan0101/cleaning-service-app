import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/bookings/models/booking_model.dart';
import 'package:cleaning_service_app/features/bookings/screens/owner_booking_details_screen.dart';
import 'package:cleaning_service_app/features/bookings/screens/provider_booking_service_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utils/context_extension/context_extension.dart';

class OwnerMyBookingCard extends StatelessWidget {
  const OwnerMyBookingCard({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    final isProvider = AppStorageService.getUserRole() == "PROVIDER";

    return InkWell(
      onTap: () {
        if (isProvider) {
          // Navigate to provider booking details screen
          Get.to(
            () => const ServiceDetailsScreen(),
            arguments: [
              {'bookingId': booking.id, 'status': booking.status.toLowerCase()},
            ],
          );
        } else {
          // Navigate to owner booking details screen
          Get.to(
            () => const OwnerBookingDetailsScreen(),
            arguments: {
              'bookingId': booking.id,
              'status': booking.status.toLowerCase(),
            },
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF4899D1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // row of image, category, status, address, phone, description
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10.w,
              children: [
                // image - placeholder since API doesn't return image
                // CustomImage(
                //   imageSrc: Assets.images.cleanImage.path,
                //   width: 90.w,
                //   height: 98.h,
                // ),
                CustomNetworkImage(
                  imageUrl: booking.oneImage,
                  height: 98.h,
                  width: 90.w,
                ),

                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Service name
                          Expanded(
                            child: CustomText(
                              text: booking.serviceName,
                              color: const Color(0xFF0F0B18),
                              fontSize: isTab ? 12 : 16,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),

                          /// status
                          _buildBookingStatus(booking.status, isTab),
                        ],
                      ),

                      /// location
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 4.w,
                        children: [
                          Assets.icons.locationMarker.svg(
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              const Color(0xFF1B2D51),
                              BlendMode.srcIn,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              text: booking.ownerAddress.city,
                              color: const Color(0xFF4F4F59),
                              fontSize: isTab ? 10 :  10.sp,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),

                      /// phone
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 4.w,
                        children: [
                          Assets.icons.phone.svg(width: 16, height: 16),
                          CustomText(
                            text: booking.ownerPhoneNumber,
                            color: const Color(0xFF4F4F59),
                            fontSize: isTab ? 10 : 10.sp,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ],
                      ),

                      /// description
                      CustomText(
                        text: booking.description,
                        color: const Color(0xFF4F4F59),
                        fontSize: isTab ? 11 : 10.sp,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Price Details title
            CustomText(
              text: "Price Details",
              color: const Color(0xFF0F0B18),
              fontSize: isTab ? 12: 18,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),

            /// Price
            _buildPriceDetailsRow(
              title: "Price",
              value: "${booking.priceByHour}/hr",
              isTab : isTab
            ),

            /// Duration
            _buildPriceDetailsRow(
              title: "Duration",
              value: "${booking.serviceDuration}hr",
              isTab : isTab
            ),

            /// Total
            _buildPriceDetailsRow(
              title: "Total",
              value: booking.totalAmount.toStringAsFixed(2),
              isTab : isTab
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetailsRow({required String title, required String value, required bool isTab}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: title,
          color: title == "Total"
              ? const Color(0xFF4899D1)
              : const Color(0xFF4F4F59),
          fontSize: title == "Total" ? isTab ? 12 :  14.sp : isTab ? 12 : 16.sp,
          fontFamily: 'Lexend',
          fontWeight: title == "Total" ? FontWeight.w600 : FontWeight.w400,
          height: 1.50,
        ),
        Text.rich(
          TextSpan(
            children: [
              if (title != "Duration")
                TextSpan(
                  text: '€',
                  style: TextStyle(
                    color: title == "Total"
                        ? const Color(0xFF4899D1)
                        : const Color(0xFF4F4F59),
                    fontSize: title == "Total" ? 16.sp : 14.sp,
                    fontFamily: 'Lexend',
                    fontWeight: title == "Total"
                        ? FontWeight.w600
                        : FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              TextSpan(
                text: value,
                style: TextStyle(
                  color: title == "Total"
                      ? const Color(0xFF4899D1)
                      : const Color(0xFF4F4F59),
                  fontSize: title == "Total" ? 16.sp : 14.sp,
                  fontFamily: 'Lexend',
                  fontWeight: title == "Total"
                      ? FontWeight.w600
                      : FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingStatus(String status,bool isTab) {
    final String displayStatus = status.toUpperCase();
    Color color;
    Color textColor = Colors.white;

    switch (displayStatus) {
      case 'PENDING':
        color = const Color(0xFFDE5640);
        break;
      case 'ONGOING':
        color = const Color(0xFF4899D1);
        break;
      case 'COMPLETED':
        color = const Color(0xFF1B2D51);
        break;
      case 'CANCELLED':
        color = const Color(0xFFECCACA);
        textColor = const Color(0xFFDE5640);
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      child: CustomText(
        text: displayStatus[0] + displayStatus.substring(1).toLowerCase(),
        color: textColor,
        fontSize: isTab ? 10 : 14,
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w600,
        height: 1.50,
      ),
    );
  }
}
