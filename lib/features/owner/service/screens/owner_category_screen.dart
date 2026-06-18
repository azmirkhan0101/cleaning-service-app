import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OwnerCategoryScreen extends StatefulWidget {
  const OwnerCategoryScreen({super.key});

  @override
  State<OwnerCategoryScreen> createState() => _OwnerCategoryScreenState();
}

class _OwnerCategoryScreenState extends State<OwnerCategoryScreen> {
  final categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Category", backButton: false),
      body: Obx(() {
        if (categoryController.isLoading.value &&
            categoryController.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (categoryController.categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No categories available',
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
          onRefresh: categoryController.refreshCategories,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: categoryController.categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 16, // Space between columns
                mainAxisSpacing: 12, // Space between rows
                childAspectRatio: (() {
                  final mq = MediaQuery.of(context);
                  final screenWidth = mq.size.width;
                  final horizontalPadding =
                      16.0 * 2; // Padding from parent (left + right)
                  final crossAxisCount = 2;
                  final spacing = 16.0; // crossAxisSpacing
                  final itemWidth =
                      (screenWidth -
                          horizontalPadding -
                          (crossAxisCount - 1) * spacing) /
                      crossAxisCount;
                  final itemHeight =
                      mq.size.height *
                      0.23; // device-based item height (adjust fraction as needed)
                  return itemWidth / itemHeight;
                })(),
              ),
              itemBuilder: (context, index) {
                final category = categoryController.categories[index];
                return SizedBox(
                  height: 1000.h,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.ownerCategoryByService,
                        arguments: {
                          'categoryId': category.id,
                          'categoryName': category.name,
                        },
                      );
                    },
                    child: Card(
                      color: AppColors.white,
                      elevation: 2,
                      shadowColor: Colors.grey,
                      borderOnForeground: false,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          spacing: 8,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(category.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            CustomText(
                              text: category.name,
                              textAlign: TextAlign.center,
                              fontSize: 12,
                              fontFamily: FontFamily.lexend,
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ],
                        ),
                      ),
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
