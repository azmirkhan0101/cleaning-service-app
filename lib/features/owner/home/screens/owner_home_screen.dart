import 'package:carousel_slider/carousel_slider.dart';
import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/components/icon_white_circle_background.dart';
import 'package:cleaning_service_app/core/helper/extension/base_extensions.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/notification/controllers/notification_controller.dart';
import 'package:cleaning_service_app/features/owner/home/controllers/nearby_services_controller.dart';
import 'package:cleaning_service_app/features/owner/home/controllers/owner_controller.dart';
import 'package:cleaning_service_app/features/owner/home/screens/owner_home_search_screen.dart';
import 'package:cleaning_service_app/features/owner/home/widgets/home_service_category_card.dart';
import 'package:cleaning_service_app/features/owner/home/widgets/nearby_service_card.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/category_controller.dart';
import 'package:cleaning_service_app/features/owner/service/models/category_model.dart';
import 'package:cleaning_service_app/features/owner/service/screens/owner_service_details_screen.dart';
import 'package:cleaning_service_app/features/payment/controllers/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();

}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {

  @override
  void initState() {

    nearbyController.autoRefreshServices();
    super.initState();
  }

  final ownerController = Get.find<OwnerController>();
  final nearbyController = Get.find<NearbyServicesController>();

  final paymentController = Get.find<PaymentController>();

  final notificationController = Get.put(NotificationController());

  final CategoryController categoryController = Get.put(CategoryController());

  double ratingValue = 0.0;
  final TextEditingController ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Nearby services section below uses live data; removed static demo list

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1EFFF), Color(0xFFFDFDFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.h.heightBox,
                  /// My Location Row
                  _buildHeader(),
                  SizedBox(height: 16),
                  // Carousel Slider with Expanded
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      initialPage: ownerController.sliderCurrentIndex.value,
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      height:
                          MediaQuery.sizeOf(context).height /
                          5, // Adjust as necessary
                      onPageChanged: (index, reason) {
                        ownerController.sliderCurrentIndex.value = index;
                      },
                    ),
                    itemCount: 5,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        width:
                            MediaQuery.of(context).size.width *
                            0.9, // Set a custom width for the carousel item
                        decoration: ShapeDecoration(
                          color: const Color(0xFF4899D1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        padding: EdgeInsets.all(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Wrap text and button in Expanded or Flexible
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText2(
                                    text: "30% Off \n Special Deals",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 8),
                                  CustomText2(
                                    text:
                                        "Get discount for every Cleaning order",
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
                                        padding: const EdgeInsets.all(7.0),
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
                              child: CustomImage(
                                imageSrc: AppImages.banner_im5,
                                height: 140,
                                width: 140,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  // Dots for Carousel
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 4.w,
                      children: List.generate(
                        5,
                        (index) => buildDot(index, context, ownerController),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText2(
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
                          child: CustomText2(
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
                  Obx(() {
                    return SizedBox(
                      height: 120, // Adjust the height based on your layout
                      child: Skeletonizer(
                        enabled: categoryController.isLoading.value,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryController.categories.length,
                          // itemCount: category
                          //     .length, // Set the itemCount to match the data length
                          itemBuilder: (BuildContext context, index) {
                            final CategoryModel service =
                                categoryController.categories[index];

                            return HomeServiceCategoryCard(service: service);
                          },
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  // Nearby services
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText2(
                        text: 'Near for you',
                        // text:
                        //     'Near for you within ${nearbyController.currentRadiusKm} km',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      InkWell(
                        onTap: () => nearbyController.fetchNearby(),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CustomText2(
                            text: 'Refresh',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (nearbyController.error.isNotEmpty) {
                      return Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText2(
                                text: 'Could not load nearby services',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                nearbyController.error.value,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () =>
                                      nearbyController.fetchNearby(),
                                  child: const Text('Retry'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final items = nearbyController.services;
                    if (items.isEmpty) {
                      return SizedBox(
                        height: 220,
                        child: Center(
                          child: CustomText2(
                            text: 'No nearby services found',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black_04,
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Skeletonizer(
                        enabled: nearbyController.isLoading.value,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final service = items[index];
                            return InkWell(
                              onTap: () => Get.to(
                                OwnerServiceDetailsScreen(),
                                arguments: {'serviceId': service.id},
                              ),
                              // child: NearbyServiceCard(service: service),
                              child: NearbyServiceCard(
                                service: service,
                                width: 220,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: OwnerNavBar(currentIndex: 0),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 12.w,
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            onTap: () {
              Get.to(OwnerHomeSearchScreen());
            },
            decoration: InputDecoration(
              hintText: "Find Your Service",
              hintStyle: TextStyle(
                color: const Color(0xFF4F4F59),
                fontSize: 12,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Assets.icons.search.svg(),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        IconWhiteCircleBackground(
          icon: Obx(() {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Assets.icons.notificationBell.svg(
                    width: 24,
                    height: 24,
                  ),
                ),
                if (notificationController.unreadCount.value > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF00B046) /* green */,
                        shape: OvalBorder(),
                      ),
                      child: Center(
                        child: Text(
                          '${notificationController.unreadCount.value}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          onTap: () {
            // showCustomDialog(context);
            Get.toNamed(AppRoutes.notificationScreen);
          },
        ),
      ],
    );
  }

  Container buildDot(
    int index,
    BuildContext context,
    OwnerController controller,
  ) {
    return Container(
      width: 8,
      height: 8,
      decoration: ShapeDecoration(
        color: controller.sliderCurrentIndex.value == index
            ? const Color(0xFF4899D1)
            : const Color(0xFFDDE1ED),
        shape: OvalBorder(),
      ),
    );
  }

  ///filter service data
  // void showCustomDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         insetPadding: EdgeInsets.all(8),
  //         contentPadding: EdgeInsets.all(8),
  //         scrollable: true,
  //         // Optional title if provided
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(""),

  //             IconButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               icon: Icon(Icons.close, size: 32),
  //             ),
  //           ],
  //         ),
  //         content: SizedBox(
  //           width: MediaQuery.sizeOf(context).width,
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 ///================== Category show =============
  //                 Row(
  //                   mainAxisSize: MainAxisSize
  //                       .min, // Ensure Row size is as small as needed
  //                   children: [
  //                     // First item
  //                     Container(
  //                       width: 110,
  //                       height: 45,
  //                       padding: EdgeInsets.symmetric(
  //                         vertical: 8,
  //                         horizontal: 8,
  //                       ),
  //                       margin: EdgeInsets.only(bottom: 5),
  //                       decoration: BoxDecoration(
  //                         color: Colors.blue,
  //                         borderRadius: BorderRadius.circular(10),
  //                         border: Border.all(color: Colors.grey),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           CustomImage(imageSrc: AppIcons.service_all),
  //                           SizedBox(width: 2),
  //                           CustomText2(
  //                             text: "All Service",
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w500,
  //                             color: AppColors.white,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     SizedBox(width: 12),
  //                     // Second item
  //                     Container(
  //                       width: 110,
  //                       height: 45,
  //                       padding: EdgeInsets.symmetric(
  //                         vertical: 8,
  //                         horizontal: 8,
  //                       ),
  //                       margin: EdgeInsets.only(bottom: 5),
  //                       decoration: BoxDecoration(
  //                         color: Colors.transparent,
  //                         borderRadius: BorderRadius.circular(10),
  //                         border: Border.all(color: Colors.grey),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           CustomImage(imageSrc: AppIcons.cleaning),
  //                           SizedBox(width: 2),
  //                           CustomText2(
  //                             text: "Cleaning",
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w500,
  //                             color: AppColors.black,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     SizedBox(width: 12),

  //                     // Add more items as needed
  //                     Container(
  //                       width: 110,
  //                       height: 45,
  //                       padding: EdgeInsets.symmetric(
  //                         vertical: 8,
  //                         horizontal: 8,
  //                       ),
  //                       margin: EdgeInsets.only(bottom: 5),
  //                       decoration: BoxDecoration(
  //                         color: Colors.transparent,
  //                         borderRadius: BorderRadius.circular(10),
  //                         border: Border.all(color: Colors.grey),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           CustomImage(imageSrc: AppIcons.laundry),
  //                           SizedBox(width: 2),
  //                           CustomText2(
  //                             text: "Laundry",
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w500,
  //                             color: AppColors.black,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),

  //                 SizedBox(height: 16),

  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Get.toNamed(AppRoutes.pickerMapScreen);
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: AppColors.white_50,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(50), // pill shape
  //                       side: const BorderSide(
  //                         color: Colors.lightBlue,
  //                         width: 1,
  //                       ), // border
  //                     ),
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 32,
  //                       vertical: 14,
  //                     ),
  //                     elevation: 0, // flat style, remove shadow
  //                     // minimumSize: Size(50, 50),  // 90% of screen width
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       CustomImage(imageSrc: AppIcons.send_icon),

  //                       SizedBox(width: 8),

  //                       CustomText2(
  //                         text: 'Use my current location',
  //                         color: Colors.black,
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ],
  //                   ),
  //                 ),

  //                 SizedBox(height: 8),

  //                 const CustomText2(
  //                   text: "Price/hour ",
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.black,
  //                 ),

  //                 Slider(
  //                   value: 5.0, // Initial value
  //                   min: 5.0, // Minimum value
  //                   max: 100.0, // Maximum value
  //                   // divisions: 95,       // Number of discrete steps
  //                   activeColor: AppColors.lightBlue,
  //                   onChanged: (double value) {
  //                     // Handle the slider value change
  //                     print("Selected distance: $value miles");
  //                   },
  //                 ),

  //                 SizedBox(height: 12),

  //                 CustomText2(
  //                   text: "Select Rating",
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w400,
  //                   color: AppColors.black,
  //                 ),

  //                 SizedBox(height: 10),

  //                 RatingBar.builder(
  //                   initialRating: 5,
  //                   minRating: 1,
  //                   itemSize: 40,
  //                   itemCount: 5,
  //                   itemPadding: EdgeInsets.symmetric(horizontal: 2),
  //                   itemBuilder: (context, _) =>
  //                       Icon(Icons.star, color: Colors.orange),
  //                   onRatingUpdate: (rating) {
  //                     print('Rating: $rating');
  //                   },
  //                 ),

  //                 SizedBox(width: 12),

  //                 ///Professional's Experience Section
  //                 _buildSectionHeader("Professional's experience"),
  //                 const SizedBox(height: 16),
  //                 _buildExperienceOptions(),
  //                 const SizedBox(height: 16),

  //                 ///Instant Booking Section
  //                 _buildSectionHeader("Instant Booking"),
  //                 const SizedBox(height: 16),
  //                 _buildInstantBookingOptions(),
  //                 const SizedBox(height: 16),

  //                 ///Gender Section
  //                 _buildSectionHeader("Gender"),
  //                 const SizedBox(height: 16),
  //                 _buildGenderOptions(),

  //                 const SizedBox(height: 16),

  //                 CustomText2(
  //                   text: "Spoken Language",
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w400,
  //                   color: AppColors.black,
  //                 ),

  //                 Obx(() {
  //                   return SizedBox(
  //                     height: 60,
  //                     child: Card(
  //                       color: AppColors.white,
  //                       elevation: 0.2,
  //                       child: DropdownButton<String>(
  //                         value: paymentController.selectedCountry.value.isEmpty
  //                             ? null
  //                             : paymentController
  //                                   .selectedCountry
  //                                   .value, // Bind to the GetX value
  //                         onChanged: (String? newValue) {
  //                           paymentController.selectedCountry.value = newValue!;
  //                         },
  //                         items: <String>['USA', 'Canada', 'India', 'Australia']
  //                             .map<DropdownMenuItem<String>>((String value) {
  //                               return DropdownMenuItem<String>(
  //                                 value: value,
  //                                 enabled: true,
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text(value),
  //                                 ),
  //                               );
  //                             })
  //                             .toList(),
  //                         icon: Icon(
  //                           Icons.arrow_drop_down,
  //                         ), // Adding the dropdown icon
  //                         iconSize: 24, // Adjust the icon size if needed
  //                         isExpanded:
  //                             true, // Makes the DropdownButton take up all available space
  //                       ),
  //                     ),
  //                   );
  //                 }),

  //                 const SizedBox(height: 16),

  //                 CustomButton(
  //                   onTap: () {
  //                     Navigator.of(context).pop();
  //                     Get.toNamed(AppRoutes.ownerSearchScreen);
  //                   },
  //                   title: "Apply",
  //                   fontSize: 16, // Bigger button text for tablets
  //                   width: double.infinity,
  //                   height: 50,
  //                   fillColor: AppColors.appColors,
  //                   borderRadius: 24,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildSectionHeader(String title) {
  //   return Text(
  //     title,
  //     style: const TextStyle(
  //       fontSize: 18,
  //       fontWeight: FontWeight.w600,
  //       color: Colors.black87,
  //     ),
  //   );
  // }

  // Widget _buildExperienceOptions() {
  //   final options = [
  //     "0-2 years of experience",
  //     "2-5 years of experience",
  //     "6-10 years of experience",
  //     "11-20 years of experience",
  //     "+20 years of experience",
  //   ];

  //   return Column(
  //     children: List.generate(options.length, (index) {
  //       return Padding(
  //         padding: const EdgeInsets.only(bottom: 12.0),
  //         child: Row(
  //           children: [
  //             Checkbox(
  //               value: _selectedExperience == index,
  //               onChanged: (bool? value) {
  //                 setState(() {
  //                   _selectedExperience = value == true ? index : null;
  //                 });
  //               },
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(4),
  //               ),
  //             ),

  //             const SizedBox(width: 8),

  //             CustomText2(
  //               text: options[index],
  //               fontSize: 16,
  //               color: Colors.black87,
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ],
  //         ),
  //       );
  //     }),
  //   );
  // }

  // Widget _buildInstantBookingOptions() {
  //   return Row(
  //     children: [
  //       Row(
  //         children: [
  //           Checkbox(
  //             value: _instantBooking == true,
  //             onChanged: (bool? value) {
  //               setState(() {
  //                 _instantBooking = value == true ? true : null;
  //               });
  //             },
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(4),
  //             ),
  //           ),
  //           const SizedBox(width: 8),
  //           const Text(
  //             "Yes",
  //             style: TextStyle(fontSize: 16, color: Colors.black87),
  //           ),
  //         ],
  //       ),

  //       const SizedBox(width: 16),

  //       Row(
  //         children: [
  //           Checkbox(
  //             value: _instantBooking == false,
  //             onChanged: (bool? value) {
  //               setState(() {
  //                 _instantBooking = value == true ? false : null;
  //               });
  //             },
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(4),
  //             ),
  //           ),

  //           const SizedBox(width: 8),
  //           const Text(
  //             "No",
  //             style: TextStyle(fontSize: 16, color: Colors.black87),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildGenderOptions() {
  //   return Row(
  //     children: [
  //       Row(
  //         children: [
  //           Checkbox(
  //             value: _selectedGender == "Male",
  //             onChanged: (bool? value) {
  //               setState(() {
  //                 _selectedGender = value == true ? "Male" : null;
  //               });
  //             },
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(4),
  //             ),
  //           ),
  //           const SizedBox(width: 8),
  //           const Text(
  //             "Male",
  //             style: TextStyle(fontSize: 16, color: Colors.black87),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(width: 32),
  //       Row(
  //         children: [
  //           Checkbox(
  //             value: _selectedGender == "Female",
  //             onChanged: (bool? value) {
  //               setState(() {
  //                 _selectedGender = value == true ? "Female" : null;
  //               });
  //             },
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(4),
  //             ),
  //           ),
  //           const SizedBox(width: 8),
  //           const Text(
  //             "Female",
  //             style: TextStyle(fontSize: 16, color: Colors.black87),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
}
