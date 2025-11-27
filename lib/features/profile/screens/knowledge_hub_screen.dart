import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/features/profile/controllers/knowledge_hub_controller.dart';
import 'package:cleaning_service_app/features/profile/screens/knowledge_hub_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class KnowledgeHubScreen extends StatefulWidget {
  const KnowledgeHubScreen({super.key});

  @override
  State<KnowledgeHubScreen> createState() => _KnowledgeHubScreenState();
}

class _KnowledgeHubScreenState extends State<KnowledgeHubScreen> {
  final KnowledgeHubController controller = Get.put(KnowledgeHubController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Knowledge Hub", backButton: true),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.lightBlue),
          );
        }

        // Error state
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: CustomText2(
                    text: controller.errorMessage.value,
                    fontSize: 16,
                    color: Colors.red.shade700,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.retry(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBlue,
                  ),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (controller.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16),
                CustomText2(
                  text: 'No articles available',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          );
        }

        // Content state
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two cards per row
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.80, // To maintain square shape of cards
            ),
            itemCount: controller.articles.length,
            itemBuilder: (context, index) {
              final article = controller.articles[index];

              return Card(
                elevation: 0.8,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // Navigate to article detail screen with article ID
                    Get.to(
                      () => KnowledgeHubDetailScreen(
                        articleId: article.id,
                        title: article.title,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomImage(imageSrc: AppIcons.book),
                        SizedBox(height: 10),
                        CustomText2(
                          text: article.title,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightBlue,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        SizedBox(height: 5),
                        Expanded(
                          child: HtmlWidget(
                            article.description,
                            textStyle: const TextStyle(fontSize: 11),
                            renderMode: RenderMode.column,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              () => KnowledgeHubDetailScreen(
                                articleId: article.id,
                                title: article.title,
                              ),
                            );
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
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
