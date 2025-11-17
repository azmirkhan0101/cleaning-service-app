import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/provider/service/controllers/provider_service_controller.dart';
import 'package:cleaning_service_app/features/provider/service/screens/provider_service_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final serviceController = Get.put(ProviderServiceController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final categoryName = args?['categoryName'] ?? 'My Services';

    return Scaffold(
      appBar: CustomAppBar(title: categoryName, backButton: true),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: serviceController.refreshServices,
          child:
              serviceController.isLoading.value &&
                  serviceController.services.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                )
              : serviceController.services.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 80),
                    Icon(
                      Icons.cleaning_services_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No services available',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (serviceController.loadError.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        serviceController.loadError.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.red[400]),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: serviceController.fetchServices,
                          child: const Text('Retry'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 300),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    controller: serviceController.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.80,
                        ),
                    itemCount:
                        serviceController.services.length +
                        (serviceController.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == serviceController.services.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final service = serviceController.services[index];
                      return InkWell(
                        onTap: () {
                          Get.to(
                            ProviderServiceDetailsScreen(),
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  service.coverImages.isNotEmpty
                                      ? service.coverImages.first
                                      : 'https://via.placeholder.com/150',
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: const Icon(
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            text: service.name,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.orange,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 2),
                                            CustomText2(
                                              text: service.ratingsAverage
                                                  .toStringAsFixed(1),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const CustomText(
                                          text: 'Current booking: ',
                                          color: Color(0xFF4F4F59),
                                          fontSize: 10,
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                        CustomText(
                                          text: service.totalOrders.toString(),
                                          color: const Color(0xFF0F0B18),
                                          fontSize: 10,
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      text:
                                          'Published date: ${_formatDate(service.createdAt)}',
                                      color: const Color(0xFF4F4F59),
                                      fontSize: 10,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          text: '€${service.rateByHour}/hr',
                                          fontSize: 12,
                                          color: AppColors.lightBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CustomImage(
                                          imageSrc: AppImages.arrayicon,
                                        ),
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.serviceAddScreen);
        },
        backgroundColor: Color(0xFFF7A51D),
        foregroundColor: Colors.white,
        child: Icon(Icons.add, size: 38),
      ),
    );
  }

  /// Format date to dd/MM/yyyy
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
