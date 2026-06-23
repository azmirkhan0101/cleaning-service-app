import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/context_extension/context_extension.dart';
import 'package:cleaning_service_app/features/owner/service/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeServiceCategoryCard extends StatelessWidget {
  const HomeServiceCategoryCard({super.key, required this.service});

  final CategoryModel service;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        //Navigate to owner service  page
        Get.toNamed(
          AppRoutes.ownerCategoryByService,
          arguments: {'categoryId': service.id, 'categoryName': service.name},
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                service.image,
                width: 78.w,
                height: 66.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 78.w,
                    height: 66.h,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, color: Colors.grey[600]),
                  );
                },
              ),
            ),

            SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomText2(
                text: service.name,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
