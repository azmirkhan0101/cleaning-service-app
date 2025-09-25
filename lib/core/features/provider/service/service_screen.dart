import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/nav_bar/provider_nav_bar.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> services = [
      {
        'title': 'Cleaning Service',
        'price': '€25/hr',
        'rating': '4.8',
        'date': '12/07/2025',
        'bookings': '05',
        'image':"https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg", // You can replace with actual image asset or network URL
      },
      {
        'title': 'Laundry Service',
        'price': '€30/hr',
        'rating': '4.8',
        'date': '12/08/2025',
        'bookings': '03',
        'image': "https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg", // Replace with actual image asset or network URL
      },

      {
        'title': 'CleanWave',
        'price': '€25/hr',
        'rating': '4.8',
        'date': '12/07/2025',
        'bookings': '05',
        'image': "https://greenhorizon.ae/assets/general-cleaning.jpg", // You can replace with actual image asset or network URL
      },
      {
        'title': 'BrightNest',
        'price': '€30/hr',
        'rating': '4.8',
        'date': '12/08/2025',
        'bookings': '03',
        'image': "https://www.helpling.com.sg/wp-content/uploads/2023/06/general-cleaning-vs-specialised-cleaning-cover-image.jpg" // Replace with actual image asset or network URL
      },
    ];

    return Scaffold(
      appBar: CustomAppbar(titleName: "Service"),
      body: GridView.builder(
        //padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 8.0, // Space between columns
          mainAxisSpacing: 8.0, // Space between rows
          childAspectRatio: 0.70, // Aspect ratio of each item
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return InkWell(
            onTap: (){

              ///serviceDetails
              Get.toNamed(AppRoutes.serviceDetails);
            },
            child: Card(
              elevation: 0.5,
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      service['image']!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Wrap the content in an Expanded widget
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Title and Rating Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: service['title']!,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),

                              SizedBox(height: 4),

                              // rating
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.orange, size: 14),
                                  SizedBox(width: 4),
                                  CustomText(
                                    text: service['rating']!,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Additional Info
                          CustomText(
                            text: 'Current booking: ${service['bookings']}',
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),

                          CustomText(
                            text: 'Published: ${service['date']}',
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),

                          SizedBox(height: 8),

                          // Price
                          CustomText(
                            text: service['price']!,
                            fontSize: 12,
                            color: AppColors.lightBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action when button is pressed

          Get.toNamed(AppRoutes.serviceAddScreen);
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: NavBar(currentIndex: 2),
    );

  }
}



