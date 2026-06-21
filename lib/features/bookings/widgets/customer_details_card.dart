import 'package:flutter/material.dart';

import '../../../core/components/custom_text/custom_text_2.dart';
import '../../../core/utils/app_colors/app_colors.dart';

class CustomerDetailsCard extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final String address;
  final String? description;
  final String title;

  const CustomerDetailsCard({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
    this.description,
    this.title = 'Customer Details',
  });

  @override
  Widget build(BuildContext context) {
    final hasDescription = description != null && description!.isNotEmpty;

    return Card(
      elevation: 0.2,
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText2(
              text: title,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontSize: 18,
            ),
            const SizedBox(height: 16),

            _DetailItem(label: 'Name', value: name),
            const SizedBox(height: 12),

            _DetailItem(label: 'Phone Number', value: phoneNumber),
            const SizedBox(height: 12),

            _DetailItem(label: 'Email', value: email),
            const SizedBox(height: 12),

            _DetailItem(label: 'Address', value: address),

            if (hasDescription) ...[
              const SizedBox(height: 12),
              _DetailItem(
                label: 'Description',
                value: description!,
                maxLines: 5,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Private helper widget to avoid duplicating field configurations
class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final int? maxLines;

  const _DetailItem({
    required this.label,
    required this.value,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText2(
          text: label,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
          fontSize: 14,
        ),
        const SizedBox(height: 8),
        CustomText2(
          text: value,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
          fontSize: 14,
          maxLines: maxLines,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}