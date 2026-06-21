import 'package:flutter/material.dart';

import '../../../core/components/custom_image/custom_image.dart';
import '../../../core/components/custom_text/custom_text_2.dart';
import '../../../core/utils/app_colors/app_colors.dart';
import '../../../core/utils/context_extension/context_extension.dart';

class ProviderDashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String iconSrc;
  final VoidCallback onTap;
  final String? subtitle;
  final EdgeInsetsGeometry padding;

  const ProviderDashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.iconSrc,
    required this.onTap,
    this.subtitle,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.5,
      color: AppColors.white,
      margin: EdgeInsets.zero, // Prevents default card margin issues
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0), // Matches card shape
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText2(
                      text: title,
                      fontSize: isTab ? 14 : 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  CustomImage(
                    imageSrc: iconSrc,
                    height: isTab ? 40 : null,
                    width: isTab ? 40 : null,
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              CustomText2(
                text: value,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8.0),
                CustomText2(
                  text: subtitle!,
                  fontSize: isTab ? 12 : 8.0,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutral03,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}