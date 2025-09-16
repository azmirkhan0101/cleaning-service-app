import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/nav_bar/nav_bar.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';



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
        'image': AppImages.clean_image, // You can replace with actual image asset or network URL
      },
      {
        'title': 'Laundry Service',
        'price': '€30/hr',
        'rating': '4.8',
        'date': '12/08/2025',
        'bookings': '03',
        'image': AppImages.clean_image, // Replace with actual image asset or network URL
      },
    ];

    return Scaffold(
      appBar: CustomAppbar(titleName: "Service",),
        body: GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 8.0, // Space between columns
            mainAxisSpacing: 8.0, // Space between rows
            childAspectRatio: 0.75, // Aspect ratio of each item
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      service['image']!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Title
                        Text(
                          service['title']!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        // Rating
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 14),
                            SizedBox(width: 4),
                            Text(service['rating']!),
                          ],
                        ),
                        SizedBox(height: 4),
                        // Price
                        Text(service['price']!),
                        SizedBox(height: 8),

                        // Additional Info (Current bookings, Date)
                        Text(
                          'Bookings: ${service['bookings']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),

                        Text(
                          'Published: ${service['date']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action when button is pressed
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      bottomNavigationBar: NavBar(currentIndex: 2),
    );
  }
}



