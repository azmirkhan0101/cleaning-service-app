import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EducationHomeScreen extends StatelessWidget {
  const EducationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> imagelist = [
      {'image': AppIcons.book},
      {'image': AppIcons.note},
      {'image': AppIcons.opport},
      {'image': AppIcons.opport},
    ];

    return Scaffold(
      appBar: CustomAppBar(titleName: "Knowledge Hub", leftIcon: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two cards per row
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.80, // To maintain square shape of cards
          ),
          itemCount: imagelist.length, // Number of items
          itemBuilder: (context, index) {
            final image = imagelist[index];
            return Card(
              elevation: 0.8,
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // Action on tap

                  if (index == 0) {
                    Get.toNamed(AppRoutes.educationTrainingScreen);
                  }
                  if (index == 1) {
                    Get.toNamed(AppRoutes.legalRegulatoryScreen);
                  }
                  if (index == 2) {
                    Get.toNamed(AppRoutes.industryTrendsScreen);
                  }
                  if (index == 3) {
                    Get.toNamed(AppRoutes.bribkOpportunitiesScreen);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImage(imageSrc: "${image['image']}"),

                    SizedBox(height: 10),

                    CustomText2(
                      text: _getCardTitle(index),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightBlue,
                    ),

                    SizedBox(height: 5),

                    Text(
                      _getCardDescription(index),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        // View button action
                      },
                      child: CustomText2(
                        text: 'View',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightBlue,
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
  }

  String _getCardTitle(int index) {
    switch (index) {
      case 0:
        return 'Education & Training';
      case 1:
        return 'Legal & Regulatory Updates';
      case 2:
        return 'Industry Trends';
      case 3:
        return 'Bribk Opportunities';
      default:
        return '';
    }
  }

  String _getCardDescription(int index) {
    switch (index) {
      case 0:
        return 'Practical guides on Property management and operation';
      case 1:
        return 'New laws short-changes, and compliance requirements';
      case 2:
        return 'Insights into real estate and custodiate factions';
      case 3:
        return 'New features-reals and programme from Bribk';
      default:
        return '';
    }
  }
}
