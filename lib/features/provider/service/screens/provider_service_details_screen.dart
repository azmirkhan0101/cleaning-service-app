import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/provider/service/controllers/provider_service_controller.dart';
import 'package:cleaning_service_app/features/provider/service/controllers/provider_service_details_controller.dart';
import 'package:cleaning_service_app/features/provider/service/controllers/service_create_controller.dart';
import 'package:cleaning_service_app/features/provider/service/screens/service_create_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderServiceDetailsScreen extends StatefulWidget {
  const ProviderServiceDetailsScreen({super.key});

  @override
  State<ProviderServiceDetailsScreen> createState() =>
      _ProviderServiceDetailsScreenState();
}

class _ProviderServiceDetailsScreenState
    extends State<ProviderServiceDetailsScreen> {
  static const _tileAspect = 140 / 90;
  static const _radius = 10.0;
  final controller = Get.put(ProviderServiceDetailsController());

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args['serviceId'] != null) {
      controller.setServiceId(args['serviceId']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final service = controller.serviceDetails.value;

      return Scaffold(
        appBar: CustomAppBar(
          title: service?.categoryId.name ?? "Service Details",
          backButton: true,
          actions: [
            /// Edit Button
            Obx((){
              if( controller.isLoading.value ){
                return SizedBox.shrink();
              }
              return IconButton(
                onPressed: () {
                  if (service != null) {
                    // Initialize or get existing create controller
                    ServiceCreateController createController;
                    if (Get.isRegistered<ServiceCreateController>()) {
                      createController = Get.find<ServiceCreateController>();
                    } else {
                      createController = Get.put(ServiceCreateController());
                    }

                    // Load service data into create controller for editing
                    createController.loadServiceForEdit(service);

                    // Navigate to edit screen with service model
                    Get.to(() => ServiceCreateEditScreen(serviceModel: service));
                  } else {
                    Toast.errorToast('Service data not available');
                  }
                },
                icon: const Icon(Icons.edit_square),
              );
            }),
            IconButton(
              onPressed: () => _showDeleteDialog(),
              icon: const Icon(Icons.delete_forever, color: Colors.red),
            ),
          ],
        ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : service == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage.value.isEmpty
                          ? 'No service details available'
                          : controller.errorMessage.value,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.refreshServiceDetails,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: controller.refreshServiceDetails,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            service.coverImages.isNotEmpty
                                ? service.coverImages.first
                                : 'https://via.placeholder.com/150',
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 140,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 140,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Service info (name, price, rating)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText2(
                                    text: service.name,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '€${service.rateByHour}/hr',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                    Text(
                                      service.ratingsAverage.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(AppRoutes.reviewScreen, arguments: service.id);
                                      },
                                      child: const CustomText2(
                                        text: 'View',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.lightBlue,
                                      ),
                                    ),
                                  ],
                                ),
                                CustomText2(
                                  text: '${service.totalOrders} Orders',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.lightBlue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service.description,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Photos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Grid
                      if (service.coverImages.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: _tileAspect,
                              ),
                          itemCount: service.coverImages.length,
                          itemBuilder: (context, index) {
                            final imageUrl = service.coverImages[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_radius),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 30,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
      );
    });
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const CustomText2(
          text: 'Delete Service',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: const CustomText2(
          text: 'Are you sure you want to delete this service?',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.grey_2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CustomText2(
              text: 'Cancel',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.grey_2,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await controller.deleteService();
              if (success) {
                // Refresh the services list if controller exists
                try {
                  final providerServiceController =
                      Get.find<ProviderServiceController>();
                  await providerServiceController.refreshServices();
                } catch (e) {
                  // Controller not found, just navigate back
                }
                // Small delay to allow toast to complete before navigation
                await Future.delayed(const Duration(milliseconds: 100));
                if (context.mounted) {
                  Get.back(); // Go back to services list
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const CustomText2(
              text: 'Delete',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
