import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class BulletedList extends StatelessWidget {
  const BulletedList({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Icon(Icons.circle, size: 4, color: Colors.black),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomText(
            text: text,
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.neutral03,
            maxLines: 4,
          ),
        ),
      ],
    );
  }
}
