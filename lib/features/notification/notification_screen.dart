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
      appBar: CustomAppbar(titleName: "Notification",leftIcon: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (BuildContext context,index){
          
                return  _buildNotification(
                  icon: Icons.notification_important,
                  title: 'Booking Request',
                  subtitle: 'from Mia Carter for Dec 20, 2024.',
                  time: '34m ago',
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotification({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Card(
      color:AppColors.white,
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: CustomText(text: title, fontWeight: FontWeight.w600,fontSize: 14,textAlign: TextAlign.start,),
        subtitle: Text(subtitle),
        trailing: Text(time, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
