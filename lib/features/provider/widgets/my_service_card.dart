import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/components/custom_image/custom_image.dart';
import '../../../core/components/custom_text/custom_text.dart';
import '../../../core/components/custom_text/custom_text_2.dart';
import '../../../core/utils/app_colors/app_colors.dart';
import '../../../core/utils/app_images/app_images.dart'; // Required for .h height extension

class MyServiceCard extends StatelessWidget {
  final String name;
  final List<dynamic> coverImages; // Accept dynamic to support list mapping from API models safely
  final double ratingsAverage;
  final int totalOrders;
  final String formattedDate;
  final String rateByHour;
  final bool isTab;
  final VoidCallback onTap;

  const MyServiceCard({
    super.key,
    required this.name,
    required this.coverImages,
    required this.ratingsAverage,
    required this.totalOrders,
    required this.formattedDate,
    required this.rateByHour,
    required this.onTap,
    this.isTab = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = coverImages.isNotEmpty && coverImages.first.toString().isNotEmpty;

    return Card(
      elevation: 0.2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.zero, // Resets native card margin for precise grid/flex layouts
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10), // Constrains touch feedback to the card shape
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Header
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: !hasImage
                  ? _buildPlaceholderImage()
                  : Image.network(
                coverImages.first.toString(),
                height: 100.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholderImage(),
              ),
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Name & Star Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: name,
                            fontSize: isTab ? 12 : 16,
                            fontWeight: FontWeight.w600,
                            maxLines: 1,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: isTab ? 25 : 18,
                            ),
                            const SizedBox(width: 2),
                            CustomText2(
                              text: ratingsAverage.toStringAsFixed(1),
                              fontSize: isTab ? 14 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Total Bookings Row
                    Row(
                      children: [
                        const CustomText(
                          text: 'Bookings: ',
                          color: Color(0xFF4F4F59),
                          fontSize: 12,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                        CustomText(
                          text: totalOrders.toString(),
                          color: const Color(0xFF0F0B18),
                          fontSize: 12,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),

                    // Creation Date Row
                    CustomText(
                      text: 'Date: $formattedDate',
                      color: const Color(0xFF4F4F59),
                      fontSize: 12,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                    const Spacer(),

                    // Rate per Hour & Action Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: '€$rateByHour/hr',
                          fontSize: 12,
                          color: AppColors.lightBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        CustomImage(
                          imageSrc: AppImages.arrayicon,
                          height: isTab ? 25 : 20,
                          width: isTab ? 25 : 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Clean helper to build placeholder box
  Widget _buildPlaceholderImage() {
    return Container(
      height: 100.h,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Icon(
        Icons.image_not_supported,
        size: 40,
      ),
    );
  }
}