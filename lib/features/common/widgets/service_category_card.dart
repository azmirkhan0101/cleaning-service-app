import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceCategoryCard extends StatelessWidget {
  const ServiceCategoryCard({super.key, required this.service});

  final Map<String, String> service;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ///Navigate to owner service  page
        Get.toNamed(AppRoutes.ownerCategoryByService);
      },
      child: Card(
        elevation: 0.3,
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            CustomImage(
              imageSrc: AppImages.banner_im6,
              height: 80,
              width: 110,
              fit: BoxFit.fill,
            ),

            SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomText2(
                text: service['title']!,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
