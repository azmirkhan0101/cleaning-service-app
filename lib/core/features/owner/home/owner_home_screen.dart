
import 'package:cleaning_service_app/core/components/custom_netwrok_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/nav_bar/owner_nav_bar.dart';
import 'package:cleaning_service_app/core/features/owner/home/owner_controller.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {

  final  ownerController = Get.find<OwnerController>();

  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> category = [
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(24), // Custom height
        child: AppBar(
          scrolledUnderElevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // My Location Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_pin, color: AppColors.lightBlue),
                      SizedBox(width: 6),
                      Column(
                        children: [
                          Row(
                            children: [
                              CustomText(
                                text: 'My Location',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                              SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(AppRoutes.locationScreen);
                                },
                                child: Icon(Icons.edit, size: 18),
                              ),
                            ],
                          ),
                          CustomText(
                            text: 'Dhaka',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                    ],
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        color: AppColors.white,
                        elevation: 0.1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Get.toNamed(AppRoutes.ownerSearchScreen);
                            },
                              child: Icon(Icons.search)),
                        ),
                      ),

                      SizedBox(
                        width: 9,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.notificationScreen);
                        },
                        child: CustomImage(imageSrc: AppImages.notification),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Carousel Slider with Expanded
              CarouselSlider.builder(
                options: CarouselOptions(
                  initialPage: ownerController.sliderCurrentIndex.value,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  height: MediaQuery.sizeOf(context).height / 5,  // Adjust as necessary
                  onPageChanged: (index, reason) {
                    ownerController.sliderCurrentIndex.value = index;
                  },
                ),
                itemCount: 5,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.9,  // Set a custom width for the carousel item
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Wrap text and button in Expanded or Flexible
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "30% Off \n Special Deals",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 8),
                              CustomText(
                                text: "Get discount for every Cleaning order",
                                fontSize: 12,
                                maxLines: 2,
                                color: AppColors.white,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 8),

                              // Using Flexible for the button to adapt its space
                              Flexible(
                                child: Card(
                                  color: AppColors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Order Now",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Use Flexible for the image to prevent overflow
                        Flexible(
                          child: CustomImage(imageSrc: AppImages.banner_im5, height: 140, width: 140),
                        ),
                      ],
                    ),
                  );
                },
              ),



              SizedBox(height: 16),

              // Dots for Carousel
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => buildDot(index, context)),
              ),

              const SizedBox(height: 16),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'Select Category',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),

                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.ownerCategoryScreen);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CustomText(
                        text: 'View all',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightBlue,
                      ),
                    ),
                  ),
                ],
              ),

              ///==================== Category show =====================
              SizedBox(
                height: 120,  // Adjust the height based on your layout
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: category.length,  // Set the itemCount to match the data length
                  itemBuilder: (BuildContext context, index) {
                    final service = category[index];

                    return InkWell(
                      onTap: () {

                        ///Navigate to owner service  page
                        Get.toNamed(AppRoutes.ownerCategoryByService);
                      },
                      child: Card(
                        elevation: 0.3,
                        color: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Service Image
                            CustomImage(
                            imageSrc: AppImages.banner_im6,
                            height: 80,
                            width: 110,
                            fit: BoxFit.fill,
                          ),

                            SizedBox(
                              height: 8,
                            ),

                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CustomText(
                                text: service['title']!,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Near for you
              const CustomText(
                text: 'Near for you',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),

              const SizedBox(height: 12),

              // service (Wrapped in SingleChildScrollView)
              SizedBox(
                height: 300,  // Adjust the height based on your layout
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: category.length,  // Set the itemCount to match the data length
                  itemBuilder: (BuildContext context, index) {
                    final service = category[index];

                    return InkWell(
                      onTap: () {
                        // Navigate to service details page
                        Get.toNamed(AppRoutes.ownerServiceDetailsScreen);
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
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                              child: Image.network(
                                service['image']!,
                                height: 180,
                                fit: BoxFit.fill,
                              ),
                            ),

                            SizedBox(height: 8),

                          Padding(
                            padding:   EdgeInsets.all(6.0),
                            child: Column(
                             // mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // Title and Rating Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomText(
                                      text: service['title']!,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(width: 16),

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
                                    CustomText(
                                      text: 'Jorge Bond',
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),

                                SizedBox(height: 8),

                                // Row with price and icon
                                Row(
                                  mainAxisSize: MainAxisSize.min,  // Only take up as much space as needed
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: service['price']!,
                                      fontSize: 12,
                                      color: AppColors.lightBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    // CustomImage(imageSrc: AppImages.arrayicon),
                                  ],
                                )

                              ],
                            ),
                          )

                          ],
                        ),
                      ),
                    );

                  },
                ),
              )

            ],
          ),
        ),
      ),
       bottomNavigationBar: OwnerNavBar(currentIndex: 0),
    );

  }

  Container buildDot(int index, BuildContext context) {

    
    return Container(
      height: 4,
      width: ownerController.sliderCurrentIndex.value == index ? 30 : 15,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ownerController.sliderCurrentIndex.value == index
            ? AppColors.lightRed
            : AppColors.grey_1,
      ),
    );
  }
}


