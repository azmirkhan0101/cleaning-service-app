import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerCategoryScreen extends StatefulWidget {
  const OwnerCategoryScreen({super.key});

  @override
  State<OwnerCategoryScreen> createState() => _OwnerCategoryScreenState();
}

class _OwnerCategoryScreenState extends State<OwnerCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> services = [
      {
        'title': 'Cleaning',
        'price': '€25/hr',
        'rating': '4.8',
        'date': '12/07/2025',
        'bookings': '05',
        'image':
            "https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg", // You can replace with actual image asset or network URL
      },
      {
        'title': 'Laundry',
        'price': '€30/hr',
        'rating': '4.8',
        'date': '12/08/2025',
        'bookings': '03',
        'image':
            "https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg", // Replace with actual image asset or network URL
      },

      {
        'title': 'Handyman',
        'price': '€25/hr',
        'rating': '4.8',
        'date': '12/07/2025',
        'bookings': '05',
        'image':
            "https://greenhorizon.ae/assets/general-cleaning.jpg", // You can replace with actual image asset or network URL
      },
      {
        'title': 'Electrical',
        'price': '€30/hr',
        'rating': '4.8',
        'date': '12/08/2025',
        'bookings': '03',
        'image':
            "https://www.helpling.com.sg/wp-content/uploads/2023/06/general-cleaning-vs-specialised-cleaning-cover-image.jpg", // Replace with actual image asset or network URL
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(titleName: "Category", leftIcon: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // child: Column(
        //   children: [
        child: GridView.builder(
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 16, // Space between columns
            mainAxisSpacing: 12, // Space between rows
            childAspectRatio: 1.18,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.ownerCategoryByService);
              },
              child: Card(
                color: AppColors.white,
                elevation: 2,
                shadowColor: Colors.grey,
                borderOnForeground: false,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    spacing: 8,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(services[index]['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      CustomText(
                        text: services[index]['title']!,
                        textAlign: TextAlign.center,
                        fontSize: 12,
                        fontFamily: FontFamily.lexend,
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
