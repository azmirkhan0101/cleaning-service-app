import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/components/app_routes/app_routes.dart';
import '../../../core/components/custom_text/custom_text.dart';
import '../../../core/utils/app_colors/app_colors.dart';

class AppointmentCard extends StatelessWidget {
  final String name;
  final String time;
  final String appointment;
  final String avatarUrl;

  const AppointmentCard({
    super.key,
    required this.name,
    required this.time,
    required this.appointment,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: (){
      //   Get.find<MainLayoutController>().changeTab(3);
      // },
      onTap: () {
        Get.toNamed(
          AppRoutes.bookingsScreen,
          arguments: [
            {"status": "Pending"},
          ],
        );
      },
      child: Card(
        elevation: 0.5,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with safe fallback when URL is empty/invalid
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.grey.shade300,
                backgroundImage:
                (avatarUrl.isNotEmpty &&
                    (avatarUrl.startsWith('http://') ||
                        avatarUrl.startsWith('https://')))
                    ? NetworkImage(avatarUrl)
                    : null,
                child:
                (avatarUrl.isNotEmpty &&
                    (avatarUrl.startsWith('http://') ||
                        avatarUrl.startsWith('https://')))
                    ? null
                    : Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: name,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),

                        CustomText(
                          text: time,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.neutral03,
                        ),
                      ],
                    ),

                    // const SizedBox(height: 12.0),
                    CustomText(
                      text: appointment,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.neutral03,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}