import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/owner/service/models/service_model.dart';
import 'package:flutter/material.dart';

class NearbyServiceCard extends StatelessWidget {
  const NearbyServiceCard({super.key, required this.service, this.width});

  final ServiceModel service;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                service.serviceImage,
                // height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText2(
                          text: service.serviceName,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 4),
                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 14),
                          SizedBox(width: 2),
                          CustomText2(
                            text: service.averageRatings.toStringAsFixed(1),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Service provider info
                  Row(
                    children: [
                      CustomNetworkImage(
                        imageUrl: service.providerProfilePicture,
                        height: 24,
                        width: 24,
                        boxShape: BoxShape.circle,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: CustomText(
                          text: service.providerName,
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  CustomText2(
                    text: "Start from",
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 6),
                  // Price and icon row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText2(
                        text: '€${service.price}/hr',
                        fontSize: 12,
                        color: AppColors.lightBlue,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomImage(imageSrc: AppImages.arrayicon),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
// import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
// import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
// import 'package:cleaning_service_app/features/owner/service/models/service_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// class NearbyServiceCard extends StatelessWidget {
//   const NearbyServiceCard({super.key, required this.service});

//   final ServiceModel service;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0.5,
//       color: AppColors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: SizedBox(
//         width: 220,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//               child: CustomNetworkImage(
//                 imageUrl: service.serviceImage,
//                 height: 150,
//                 width: 220,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: CustomText2(
//                       text: service.serviceName,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.black,
//                       maxLines: 1,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       RatingBarIndicator(
//                         rating: service.averageRatings,
//                         itemBuilder: (context, _) =>
//                             const Icon(Icons.star, color: Colors.orange),
//                         itemSize: 12,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         service.averageRatings.toStringAsFixed(2),
//                         style: const TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 6),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 children: [
//                   CustomNetworkImage(
//                     imageUrl: service.providerProfilePicture,
//                     height: 22,
//                     width: 22,
//                     boxShape: BoxShape.circle,
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       service.providerName,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '€${service.price}',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: AppColors.lightBlue,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       const Icon(Icons.place, size: 14, color: Colors.grey),
//                       const SizedBox(width: 2),
//                       Text(
//                         '${service.distanceKm?.toStringAsFixed(1)} km',
//                         style: const TextStyle(
//                           fontSize: 11,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             if (service.isApprovalRequired) ...[
//               const SizedBox(height: 6),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFF3CD),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Text(
//                     'Approval required',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Color(0xFF856404),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
