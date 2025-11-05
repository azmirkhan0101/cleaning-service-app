import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewsTabView extends StatelessWidget {
  const ReviewsTabView({super.key});

  @override
  Widget build(BuildContext context) {
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
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Column(
              children: [
                Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No reviews yet'),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: serviceDetailsController.reviews.length,
        itemBuilder: (BuildContext context, index) {
          final review = serviceDetailsController.reviews[index];
          return _buildTestimonial(
            name: review.ownerName,
            rating: review.rating,
            testimonial: review.review,
            imageUrl: review.ownerProfilePicture,
          );
        },
      );
    });
  }

  Widget _buildTestimonial({
    required String name,
    required int rating,
    required String testimonial,
    required String imageUrl,
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
                  fontSize: 16.0,
                ),

                const SizedBox(width: 8),

                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color: index < rating ? Colors.amber : Colors.grey[300],
                      size: 20.0,
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
