import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_tab_selected/custom_tab_single_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/nav_bar/nav_bar.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cleaning_service_app/core/features/bookings/booking_controller.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {

  final bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // The number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(text: 'My Booking',
           fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // Height of the tab bar
            child: Obx(()=> Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// Custom Tab Button Widget
                  CustomTabSingleText(
                    tabs: bookingController.tabNameList,
                    selectedIndex: bookingController.selectedIndex.value,
                    onTabSelected: (value) {
                      bookingController.selectedIndex.value = value;
                    },
                    selectedColor: AppColors.lightBlue,
                    unselectedColor: AppColors.grey_1,
                  ),

                 ///_buildTab('All', 0),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Obx(
            () {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  if(bookingController.selectedIndex.value==1)
                  ListView.builder(
                      itemCount: 8,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context,index){

                     return  ServiceCard(
                      status: 'Pending',
                      imageUrl: AppImages.clean_image, // Replace with actual image URL
                      serviceDetails: 'Need deep cleaning for 2 bedrooms and 1 bathroom. Also, please bring cleaning supplies.',
                      price: 25.00,
                      duration: 2,
                    );
                  })
                ],
              );
            }
          ),
        ),
        bottomNavigationBar: NavBar(currentIndex: 1),
      ),
    );
  }


}


class ServiceCard extends StatelessWidget {
  final String status;
  final String imageUrl;
  final String serviceDetails;
  final double price;
  final int duration;

  ServiceCard({
    required this.status,
    required this.imageUrl,
    required this.serviceDetails,
    required this.price,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImage(imageSrc:
                imageUrl,
               // width: 100,
               // height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cleaning Service',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: status == 'Pending' ? Colors.orange : Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Location: Mohakhali, Aqua Tower 10th Floor',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(serviceDetails),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price Details'),
                      Text('€${price.toStringAsFixed(2)}hr'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Duration'),
                      Text('$duration hr'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '€${(price * duration).toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}