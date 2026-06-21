import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/profile/controllers/policy_condition_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class PolicyConditionScreen extends StatefulWidget {
  const PolicyConditionScreen({super.key, this.title, this.content});

  final String? title;
  final String? content;

  @override
  State<PolicyConditionScreen> createState() => _PolicyConditionScreenState();
}

class _PolicyConditionScreenState extends State<PolicyConditionScreen> {
  final PolicyConditionController controller = Get.put(
    PolicyConditionController(),
  );

  @override
  void initState() {
    super.initState();
    // Fetch content based on title if content is not provided
    if (widget.content == null && widget.title != null) {
      _fetchContentByTitle(widget.title!);
    }
  }

  void _fetchContentByTitle(String title) {
    switch (title.toLowerCase()) {
      case 'about us':
        controller.fetchAboutUs();
        break;
      case 'privacy policy':
        controller.fetchPrivacyPolicy();
        break;
      case 'terms & conditions':
      case 'terms and conditions':
      case 'terms condition':
        controller.fetchTermsAndConditions();
        break;
      case 'affiliation condition':
      case 'affiliation program':
        controller.fetchAffiliationProgram();
        break;
    }
  }

  Widget _buildContent() {
    // If static content is provided, display it directly
    if (widget.content != null) {
      return HtmlWidget(
        widget.content!,
        textStyle: const TextStyle(
          color: Color(0xFF0F0B18),
          fontSize: 14,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      );
    }

    // Otherwise, use the controller to fetch and display dynamic content
    return Obx(() {
      // Determine which content to display based on title
      bool isLoading = false;
      String errorMessage = '';
      String? contentText;

      switch (widget.title?.toLowerCase() ?? '') {
        case 'about us':
          isLoading = controller.isLoadingAboutUs.value;
          errorMessage = controller.errorAboutUs.value;
          contentText = controller.aboutUs.value?.text;
          break;
        case 'privacy policy':
          isLoading = controller.isLoadingPrivacy.value;
          errorMessage = controller.errorPrivacy.value;
          contentText = controller.privacyPolicy.value?.text;
          break;
        case 'terms & conditions':
        case 'terms and conditions':
        case 'terms condition':
          isLoading = controller.isLoadingTerms.value;
          errorMessage = controller.errorTerms.value;
          contentText = controller.termsAndConditions.value?.text;
          break;
        case 'affiliation condition':
        case 'affiliation program':
          isLoading = controller.isLoadingAffiliation.value;
          errorMessage = controller.errorAffiliation.value;
          contentText = controller.affiliationProgram.value?.text;
          break;
      }

      // Loading state
      if (isLoading) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.lightBlue),
        );
      }

      // Error state
      if (errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
              SizedBox(height: 16),
              CustomText(
                text: errorMessage,
                fontSize: 16,
                color: Colors.red.shade700,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _fetchContentByTitle(widget.title ?? ''),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightBlue,
                ),
                child: Text('Retry', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );
      }

      // Content state
      if (contentText == null || contentText.isEmpty) {
        return Center(
          child: CustomText(
            text: 'No content available',
            fontSize: 16,
            color: const Color(0xFF0F0B18),
          ),
        );
      }

      return HtmlWidget(
        contentText,
        textStyle: const TextStyle(
          color: Color(0xFF0F0B18),
          fontSize: 14,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backButton: true, title: widget.title ?? ""),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: const Color(0xFFE9EBF3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: SingleChildScrollView(child: _buildContent()),
      ),
    );
  }
}
