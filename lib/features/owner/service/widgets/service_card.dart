import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/owner/service/models/service_model.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                (service.serviceImage.isEmpty ||
                    !service.serviceImage.startsWith('http'))
                ? Container(
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 40),
                  )
                : Image.network(
                    service.serviceImage,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 40),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 2.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText2(
                          text: service.serviceName,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          maxLines: 1
                        ),
                      ),
                      SizedBox(width: 4),
                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 13),
                          SizedBox(width: 2),
                          CustomText2(
                            text: service.averageRatings.toStringAsFixed(1),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  // Service provider info
                  Row(
                    children: [
                      CustomNetworkImage(
                        imageUrl: service.providerProfilePicture,
                        height: 20,
                        width: 20,
                        boxShape: BoxShape.circle,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: CustomText(
                          text: service.providerName,
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  CustomText2(
                    text: service.isApprovalRequired
                        ? 'Approval Required'
                        : 'Instant Booking',
                    fontSize: 9,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 4),
                  // Price and icon row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText2(
                        text: '€${service.price}/hr',
                        fontSize: 11,
                        color: AppColors.lightBlue,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomImage(imageSrc: AppImages.arrayicon),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
