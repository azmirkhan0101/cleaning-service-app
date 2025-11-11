import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/profile/controllers/knowledge_hub_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KnowledgeHubDetailScreen extends StatefulWidget {
  final String articleId;
  final String title;

  const KnowledgeHubDetailScreen({
    super.key,
    required this.articleId,
    required this.title,
  });

  @override
  State<KnowledgeHubDetailScreen> createState() =>
      _KnowledgeHubDetailScreenState();
}

class _KnowledgeHubDetailScreenState extends State<KnowledgeHubDetailScreen> {
  final KnowledgeHubDetailController controller = Get.put(
    KnowledgeHubDetailController(),
  );

  @override
  void initState() {
    super.initState();
    controller.fetchArticleDetail(widget.articleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backButton: true, title: widget.title),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
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
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red.shade300,
                  ),
                  SizedBox(height: 16),
                  CustomText(
                    text: controller.errorMessage.value,
                    fontSize: 16,
                    color: Colors.red.shade700,
                    textAlign: TextAlign.center,
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

          // Content state
          final article = controller.article.value;
          if (article == null || article.description.isEmpty) {
            return Center(
              child: CustomText(
                text: 'No content available',
                fontSize: 16,
                color: const Color(0xFF0F0B18),
              ),
            );
          }

          return SingleChildScrollView(
            child: CustomText(
              text: article.description,
              color: const Color(0xFF4F4F59),
              fontSize: 14,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w400,
              height: 1.75,
            ),
          );
        }),
      ),
    );
  }
}
