import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/owner/home/controllers/owner_controller.dart';
import 'package:cleaning_service_app/features/owner/service/screens/owner_service_details_screen.dart';
import 'package:cleaning_service_app/features/payment/controllers/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerSearchScreen extends StatefulWidget {
  const OwnerSearchScreen({super.key});

  @override
  State<OwnerSearchScreen> createState() => _OwnerSearchScreenState();
}

class _OwnerSearchScreenState extends State<OwnerSearchScreen> {
  final ownerController = Get.find<OwnerController>();

  // int? _selectedExperience;
  // bool? _instantBooking;
  // String? _selectedGender;

  final paymentController = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> services = [
      {
        'title': 'Cleaning Service',
        'price': '€25/hr',
        'rating': '4.8',
        'date': '12/07/2025',
        'bookings': '05',
        'image':
            "https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg", // You can replace with actual image asset or network URL
      },
      {
        'title': 'Laundry Service',
        'price': '€30/hr',
        'rating': '4.8',
        'date': '12/08/2025',
        'bookings': '03',
        'image':
            "https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg", // Replace with actual image asset or network URL
      },

      {
        'title': 'CleanWave',
        'price': '€25/hr',
        'rating': '4.8',
        'date': '12/07/2025',
        'bookings': '05',
        'image':
            "https://greenhorizon.ae/assets/general-cleaning.jpg", // You can replace with actual image asset or network URL
      },
      {
        'title': 'BrightNest',
        'price': '€30/hr',
        'rating': '4.8',
        'date': '12/08/2025',
        'bookings': '03',
        'image':
            "https://www.helpling.com.sg/wp-content/uploads/2023/06/general-cleaning-vs-specialised-cleaning-cover-image.jpg", // Replace with actual image asset or network URL
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(title: "Search", backButton: true),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),

                /// Search  Field
                CustomFormCard(
                  title: "Search",
                  hintText: "Search",
                  hasBackgroundColor: true,
                  prefixIcon: Icon(Icons.search),

                  ///  suffixIcon: Icon(Icons.content_paste_search,color: AppColors.black,),
                  controller: TextEditingController(),
                ),

                SizedBox(height: 12),

                ///================== Category show =============
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 110,
                        height: 45,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue, // Unselected color
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey, // Border color when unselected
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomImage(imageSrc: AppIcons.service_all),

                            SizedBox(width: 2),
                            CustomText2(
                              text: "All Service",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12),

                      Container(
                        width: 110,
                        height: 45,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.transparent, // Unselected color
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey, // Border color when unselected
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomImage(imageSrc: AppIcons.cleaning),

                            SizedBox(width: 2),

                            CustomText2(
                              text: "Cleaning",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12),

                      Container(
                        width: 110,
                        height: 45,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.transparent, // Unselected color
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey, // Border color when unselected
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomImage(imageSrc: AppIcons.working),

                            SizedBox(width: 2),

                            CustomText2(
                              text: "Laundry",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12),

                      Container(
                        width: 110,
                        height: 45,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.transparent, // Unselected color
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey, // Border color when unselected
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomImage(
                              imageSrc: AppIcons.working,
                              width: 16,
                              height: 16,
                            ),

                            SizedBox(width: 2),

                            Expanded(
                              child: CustomText2(
                                text: "Handyman",
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  // padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 6.0, // Space between columns
                    mainAxisSpacing: 8.0, // Space between rows
                    childAspectRatio: 0.57, // Aspect ratio of each item
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return InkWell(
                      onTap: () {
                        ///service Details screen owner
                        Get.to(
                          OwnerServiceDetailsScreen(),
                          arguments: {'serviceId': service['title']},
                        );
                      },
                      child: Card(
                        elevation: 0.2,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title and Rating Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText2(
                                        text: service['title']!,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),

                                      SizedBox(height: 4),

                                      // Rating
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 14,
                                          ),
                                          SizedBox(width: 4),
                                          CustomText2(
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
                                  CustomText2(
                                    text:
                                        'Current booking: ${service['bookings']}',
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),

                                  SizedBox(height: 4),

                                  ///Additional Info
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomNetworkImage(
                                        imageUrl: AppConstants.profileImage,
                                        height: 24,
                                        width: 24,
                                        boxShape: BoxShape.circle,
                                      ),

                                      SizedBox(width: 4),
                                      CustomText2(
                                        text: 'Jorge Bond',
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  CustomText2(
                                    text: 'Start from- Instant Booking',
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(height: 6),

                                  // Price
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText2(
                                        text: service['price']!,
                                        fontSize: 12,
                                        color: AppColors.lightBlue,
                                        fontWeight: FontWeight.w600,
                                      ),

                                      CustomImage(
                                        imageSrc: AppImages.arrayicon,
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
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
