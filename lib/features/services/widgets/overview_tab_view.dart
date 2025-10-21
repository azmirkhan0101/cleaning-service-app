import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/helper/extension/base_extensions.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/owner/service/service_book_second_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OverviewTabView extends StatelessWidget {
  const OverviewTabView({super.key, this.status});
  final String? status;

  static const double _tileAspect = 140 / 90; // 2.125
  static const _radius = 10.0;

  static final List<Map<String, String>> services = [
    {
      'image':
          'https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg',
    },
    {
      'image':
          'https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg',
    },
    {'image': 'https://greenhorizon.ae/assets/general-cleaning.jpg'},
    {
      'image':
          'https://www.helpling.com.sg/wp-content/uploads/2023/06/general-cleaning-vs-specialised-cleaning-cover-image.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CustomImage(
            imageSrc: AppImages.banner_im4,
            height: 140,
            fit: BoxFit.cover, // avoid distortion
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText2(
                        text: 'Start from',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),

                      SizedBox(height: 8),
                      Text(
                        '€25/hr',
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      ),
                    ],
                  ),

                  SizedBox(width: 16),

                  InkWell(
                    onTap: () {
                      ///service map view
                      Get.toNamed(AppRoutes.pickerMapScreen);
                    },
                    child: Column(
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

                      const Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const CustomText2(
                    text: '306 Orders',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightBlue,
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 12),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.check_circle, size: 24, color: AppColors.lightBlue),

            SizedBox(width: 8),

            CustomText2(
              text: 'Instant Booking',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),

        SizedBox(height: 16),

        const CustomText2(
          text: 'Description',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        const Text(
          'Our professional cleaning service is designed to keep your home and office spotless, hygienic, and fresh. From floor to ceiling, we handle dusting, mopping, bathroom cleaning, kitchen deep cleaning, and more. Flexible scheduling and trusted cleaners ensure you get the service you need at the time that suits you best.',
          style: TextStyle(fontSize: 14),
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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: _tileAspect, // <- 170/80
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final imageUrl = services[index]['image'] ?? '';
            return Card(
              elevation: 0.3,
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
              ),
              clipBehavior: Clip.antiAlias, // clip rounded corners
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover, // fill without stretching
                width: double.infinity,
                height: double.infinity, // let grid size it
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        if (status == "pending")
          ElevatedButton(
            onPressed: () {
              showCustomDialog(context);
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
              text: 'Cancel',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

        if (status == "ongoing") //
          ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.ownerScannerScreen);
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
              Get.toNamed(AppRoutes.serviceBooking); //ServiceBooking
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
  }
}
