import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/bookings/controllers/owner_booking_controller.dart';
import 'package:cleaning_service_app/features/services/screens/owner_service_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OwnerMyBookingCard extends StatelessWidget {
  const OwnerMyBookingCard({
    super.key,
    required this.index,
    required this.controller,
  });
  final int index;
  final OwnerBookingController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          // AppRoutes.ownerServiceDetailsScreen,
          OwnerServiceDetailsScreen(),
          arguments: [
            {
              "status": controller.filteredServices[index]["status"]
                  .toLowerCase(),
            },
          ],
        );
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
                // image
                CustomImage(
                  imageSrc: controller.filteredServices[index]["imageUrl"],
                  width: 90.w,
                  height: 98.h,
                ),

                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// category
                          CustomText(
                            text:
                                controller.filteredServices[index]["category"],
                            color: const Color(0xFF0F0B18),
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),

                          /// status
                          _buildBookingStatus(
                            controller.filteredServices[index]["status"],
                          ),
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
                          CustomText(
                            text:
                                controller.filteredServices[index]["location"],
                            color: const Color(0xFF4F4F59),
                            fontSize: 10.sp,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
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
                            text: controller.filteredServices[index]["phone"],
                            color: const Color(0xFF4F4F59),
                            fontSize: 10.sp,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ],
                      ),

                      /// description
                      CustomText(
                        text: controller
                            .filteredServices[index]["serviceDetails"],
                        color: const Color(0xFF4F4F59),
                        fontSize: 10,
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
              fontSize: 18,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),

            /// Price
            _buildPriceDetailsRow(
              title: "Price",
              value: "${controller.filteredServices[index]["price"]}hr",
            ),

            /// Duration
            _buildPriceDetailsRow(
              title: "Duration",
              value: "${controller.filteredServices[index]["duration"]}hr",
            ),

            /// Total
            _buildPriceDetailsRow(
              title: "Total",
              value:
                  "${controller.filteredServices[index]["price"] * controller.filteredServices[index]["duration"]}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetailsRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 242,
      children: [
        CustomText(
          text: title,
          color: title == "Total"
              ? const Color(0xFF4899D1)
              : const Color(0xFF4F4F59),
          fontSize: title == "Total" ? 14.sp : 16.sp,
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

  Widget _buildBookingStatus(String status) {
    Color color = status == "Pending"
        ? const Color(0xFFDE5640)
        : status == "Ongoing"
        ? const Color(0xFF4899D1)
        : status == "Completed"
        ? const Color(0xFF1B2D51)
        : const Color(0xFFECCACA);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      child: CustomText(
        text: status,
        color: status == "Cancelled" ? Color(0xFFDE5640) : Colors.white,
        fontSize: 14,
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w600,
        height: 1.50,
      ),
    );
  }
}
