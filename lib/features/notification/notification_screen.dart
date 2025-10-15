import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "Notification", leftIcon: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (BuildContext context, index) {
                  return _buildNotification(
                    index: index,
                    title: 'Booking Request',
                    subtitle: 'from Mia Carter for Dec 20, 2024.',
                    time: '34m ago',
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(height: 1, color: Color(0xFFF1F1F2));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotification({
    required int index,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return ListTile(
      // leading: Icon(icon, color: Colors.blue),
      leading: Assets.icons.bellRinging.svg(
        colorFilter: ColorFilter.mode(
          index == 0 ? AppColors.blue : AppColors.black,
          BlendMode.srcIn,
        ),
      ),
      title: CustomText(
        text: title,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        textAlign: TextAlign.start,
        fontFamily: FontFamily.lexend,
        color: index == 0 ? AppColors.blue : AppColors.black,
      ),
      subtitle: CustomText(
        text: subtitle,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        textAlign: TextAlign.start,
        fontFamily: FontFamily.lexend,
        color: index == 0 ? AppColors.blue : Color(0xFF4F4F59),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomText(
            text: time,
            fontWeight: FontWeight.w400,
            fontSize: 12,
            textAlign: TextAlign.start,
            fontFamily: FontFamily.lexend,
            color: index == 0 ? AppColors.blue : Color(0xFF4F4F59),
          ),
        ],
      ),
    );
  }
}
