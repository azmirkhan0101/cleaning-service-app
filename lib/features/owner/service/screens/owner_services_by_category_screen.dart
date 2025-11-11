import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_controller.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/service_card.dart';
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
                childAspectRatio: 0.72,
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
                  child: ServiceCard(service: service),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
