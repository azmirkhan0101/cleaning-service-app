import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerServicesByCategoryScreen extends StatefulWidget {
  const OwnerServicesByCategoryScreen({super.key});

  @override
  State<OwnerServicesByCategoryScreen> createState() =>
      _OwnerServicesByCategoryScreenState();
}

class _OwnerServicesByCategoryScreenState
    extends State<OwnerServicesByCategoryScreen> {
  final serviceController = Get.put(OwnerServiceListController());

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['categoryId'] != null) {
      serviceController.setCategoryId(args['categoryId']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final categoryName = args?['categoryName'] ?? 'Service';

    return Scaffold(
      appBar: CustomAppBar(title: categoryName, backButton: true),
      body: Obx(() {
        if (serviceController.isLoading.value &&
            serviceController.services.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (serviceController.services.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cleaning_services_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No services available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: serviceController.refreshServices,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.80,
              ),
              itemCount: serviceController.services.length,
              itemBuilder: (context, index) {
                final service = serviceController.services[index];
                return InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.ownerServiceDetailsScreen,
                      arguments: {'serviceId': service.id},
                    );
                  },
                  child: Card(
                    elevation: 0.2,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            service.serviceImage,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 120,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 14,
                                      ),
                                      SizedBox(width: 2),
                                      CustomText2(
                                        text: service.averageRatings
                                            .toStringAsFixed(1),
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
                                text: service.isApprovalRequired
                                    ? 'Approval Required'
                                    : 'Instant Booking',
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(height: 6),
                              // Price and icon row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
              },
            ),
          ),
        );
      }),
    );
  }
}
