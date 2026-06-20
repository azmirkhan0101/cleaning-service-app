import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/context_extension/context_extension.dart';

class ReviewsTabView extends StatelessWidget {
  const ReviewsTabView({super.key});

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    final serviceDetailsController = Get.find<ServiceDetailsController>();

    return Obx(() {
      if (serviceDetailsController.isReviewsLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (serviceDetailsController.reviews.isEmpty) {
        return RefreshIndicator(
          onRefresh: () => serviceDetailsController.fetchReviews(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(40.0),
              constraints: const BoxConstraints(minHeight: 400),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.rate_review_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text('No reviews yet', style: TextStyle(fontSize: isTab ? 12.sp : null),),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => serviceDetailsController.fetchReviews(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: serviceDetailsController.reviews.length,
          itemBuilder: (BuildContext context, index) {
            final review = serviceDetailsController.reviews[index];
            return _buildTestimonial(
              name: review.ownerName,
              rating: review.rating,
              testimonial: review.review,
              imageUrl: review.ownerProfilePicture,
              isTab: isTab
            );
          },
        ),
      );
    });
  }

  Widget _buildTestimonial({
    required String name,
    required double rating,
    required String testimonial,
    required String imageUrl,
    required bool isTab
  }) {


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl: imageUrl,
            height: 50,
            width: 50,
            boxShape: BoxShape.circle,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText2(
                  text: name,
                  fontWeight: FontWeight.w600,
                  fontSize: isTab ? 10.sp : 16.0,
                ),

                const SizedBox(width: 8),

                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color: index < rating ? Colors.amber : Colors.grey[300],
                      size: isTab ? 30 : 20.0,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                CustomText2(
                  text: testimonial,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  color: AppColors.grey_2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
