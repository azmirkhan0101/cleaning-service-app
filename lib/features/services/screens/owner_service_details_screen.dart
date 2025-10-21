import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_netwrok_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_tab_selected/custom_tab_single_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/helper/extension/base_extensions.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/features/bookings/screens/owner_booking_screen.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/owner_service_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OwnerServiceDetailsScreen extends StatefulWidget {
  const OwnerServiceDetailsScreen({super.key});

  @override
  State<OwnerServiceDetailsScreen> createState() =>
      _OwnerServiceDetailsScreenState();
}

class _OwnerServiceDetailsScreenState extends State<OwnerServiceDetailsScreen> {
  static const _tileAspect = 140 / 90; // 2.125
  static const _radius = 10.0;

  final ownerController = Get.find<OwnerServiceController>();

  String status = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initializeData();
  }

  void _initializeData() async {
    // Get the arguments passed through Get
    final arguments = Get.arguments;

    if (arguments != null && arguments.isNotEmpty) {
      status = arguments[0]["status"];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> services = [
      {
        'image':
            'https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg',
      },
      {
        'image':
            'https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg',
      },
      {'image': 'https://greenhorizon.ae/assets/general-cleaning.jpg'},
      {
        'image':
            'https://www.helpling.com.sg/wp-content/uploads/2023/06/general-cleaning-vs-specialised-cleaning-cover-image.jpg',
      },
    ];

    final List<Map<String, String>> schedule = [
      {
        'day': 'Monday',
        'startTime': '9:00',
        'endTime': '18:00',
        'bufferTime': '30 Min',
        'status': 'Available',
      },
      {
        'day': 'Tuesday',
        'startTime': '9:00',
        'endTime': '18:00',
        'bufferTime': '15 Min',
        'status': 'Available',
      },
      {
        'day': 'Wednesday',
        'startTime': '9:00',
        'endTime': '18:00',
        'bufferTime': '15 Min',
        'status': 'Available',
      },
      {
        'day': 'Thursday',
        'startTime': '9:00',
        'endTime': '18:00',
        'bufferTime': '15 Min',
        'status': 'Available',
      },
      {
        'day': 'Friday',
        'startTime': '9:00',
        'endTime': '18:00',
        'bufferTime': '15 Min',
        'status': 'Available',
      },
      {
        'day': 'Saturday',
        'startTime': '',
        'endTime': '',
        'bufferTime': '',
        'status': 'Not available',
      },
      {
        'day': 'Sunday',
        'startTime': '',
        'endTime': '',
        'bufferTime': '',
        'status': 'Not available',
      },
    ];

    return Scaffold(
      // appBar: AppBar(
      //   scrolledUnderElevation: 0,
      //   title: const CustomText2(
      //     text: "Service details",
      //     fontSize: 24,
      //     fontWeight: FontWeight.w500,
      //     color: AppColors.black,
      //   ),
      //   // Left icon (usually a menu or back button)
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_rounded, color: AppColors.black),
      //     onPressed: () {
      //       // Handle left icon press
      //       Get.back();
      //     },
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// Custom Tab Button Widget
                CustomTabSingleText(
                  tabs: ownerController.tabNameList,
                  selectedIndex: ownerController.selectedIndex.value,
                  onTabSelected: (value) {
                    ownerController.selectedIndex.value = value;
                  },
                  selectedColor: AppColors.lightBlue,
                  unselectedColor: AppColors.grey_1,
                ),

                SizedBox(height: 16),

                /// service details show
                if (ownerController.selectedIndex.value == 0)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CustomImage(
                          imageSrc: AppImages.banner_im4,
                          height: 140,
                          fit: BoxFit.cover, // avoid distortion
                        ),
                      ),

                      // Service info (name, price, rating)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText2(
                                      text: 'Start from',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),

                                    SizedBox(height: 8),
                                    Text(
                                      '€25/hr',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(width: 16),

                                InkWell(
                                  onTap: () {
                                    ///service map view
                                    Get.toNamed(AppRoutes.pickerMapScreen);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomText2(
                                        text: 'Map View',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),

                                      SizedBox(height: 8),
                                      CustomImage(imageSrc: AppImages.location),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,

                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),

                                    const Text(
                                      '4.8',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const CustomText2(
                                  text: '306 Orders',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.lightBlue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 24,
                            color: AppColors.lightBlue,
                          ),

                          SizedBox(width: 8),

                          CustomText2(
                            text: 'Instant Booking',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      const CustomText2(
                        text: 'Description',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Our professional cleaning service is designed to keep your home and office spotless, hygienic, and fresh. From floor to ceiling, we handle dusting, mopping, bathroom cleaning, kitchen deep cleaning, and more. Flexible scheduling and trusted cleaners ensure you get the service you need at the time that suits you best.',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.justify,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Photos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: _tileAspect, // <- 170/80
                            ),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final imageUrl = services[index]['image'] ?? '';
                          return Card(
                            elevation: 0.3,
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_radius),
                            ),
                            clipBehavior:
                                Clip.antiAlias, // clip rounded corners
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover, // fill without stretching
                              width: double.infinity,
                              height: double.infinity, // let grid size it
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      if (status == "pending")
                        ElevatedButton(
                          onPressed: () {
                            showCustomDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appColors,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.9,
                              50,
                            ), // 90% of screen width
                          ),
                          child: CustomText2(
                            text: 'Cancel',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                      if (status == "ongoing") //
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.ownerScannerScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appColors,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.9,
                              50,
                            ), // 90% of screen width
                          ),
                          child: CustomText2(
                            text: 'Scan',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                      if (status == "completed") SizedBox(),

                      if (status != "pending" &&
                          status != "completed" &&
                          status != "ongoing" &&
                          status != "cancelled")
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(
                              AppRoutes.serviceBooking,
                            ); //ServiceBooking
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appColors,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.9,
                              50,
                            ), // 90% of screen width
                          ),
                          child: CustomText2(
                            text: 'Book now',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      24.w.heightBox,
                    ],
                  ),

                ///Profile section
                if (ownerController.selectedIndex.value == 1)
                  Column(
                    children: [
                      ///Profile Image
                      CustomNetworkImage(
                        imageUrl: AppConstants.profileImage,
                        height: 120,
                        width: 120,
                        boxShape: BoxShape.circle,
                      ),

                      SizedBox(height: 24),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Name',
                              color: const Color(0xFF0F0B18),
                              fontSize: 14,
                              fontFamily: FontFamily.lexend,
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),

                            CustomText(
                              text: 'Jorge Bond',
                              color: const Color(0xFF4F4F59),
                              fontSize: 14,
                              fontFamily: FontFamily.lexend,
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Address',
                              color: const Color(0xFF0F0B18),
                              fontSize: 14,
                              fontFamily: FontFamily.lexend,
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),

                            CustomText(
                              text: 'Los Angeles, California',
                              color: const Color(0xFF4F4F59),
                              fontSize: 14,
                              fontFamily: FontFamily.lexend,
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Experience',
                              color: const Color(0xFF0F0B18),
                              fontSize: 14,
                              fontFamily: FontFamily.lexend,
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),

                            CustomText(
                              text: '2 Years',
                              color: const Color(0xFF4F4F59),
                              fontSize: 14,
                              fontFamily: FontFamily.lexend,
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'About me',
                              color: const Color(0xFF0F0B18),
                              fontSize: 14,
                              fontFamily: FontFamily.lexend,
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),

                            /* CustomText(text: 'Hello! I’m a dedicated cleaning service provider with a  passion for creating spotless,comfortable, and healthy spaces.',
                                fontSize: 14, color: AppColors.neutral03,maxLines: 2,textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
*/
                            SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                text:
                                    'Hello! I’m a dedicated cleaning service provider with a  passion for creating spotless,comfortable, and healthy spaces.',
                                style: TextStyle(
                                  color: const Color(0xFF4F4F59),
                                  fontSize: 14,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' Read More',
                                    style: TextStyle(
                                      color: const Color(0xFF4899D1),
                                      fontSize: 14,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w600,
                                      height: 1.50,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ///review section
                if (ownerController.selectedIndex.value == 2)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (BuildContext context, index) {
                      return _buildTestimonial(
                        name: 'Daniel Brown',
                        rating: 5,
                        testimonial:
                            'Excellent service! Professional, reliable, and exceeded my expectations. Highly recommended!',
                      );
                    },
                  ),

                ///Schedule section
                if (ownerController.selectedIndex.value == 3)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: schedule.length,
                    itemBuilder: (context, index) {
                      final daySchedule = schedule[index];

                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText2(
                                text: daySchedule['day']!,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),

                              Row(
                                children: [
                                  if (daySchedule['startTime']!.isNotEmpty)
                                    CustomText2(
                                      text:
                                          "${daySchedule['startTime']} — ${daySchedule['endTime']}",
                                      fontSize: 16,
                                    ),

                                  const SizedBox(width: 10),

                                  CustomText2(
                                    text: daySchedule['status']!,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: daySchedule['status'] == 'Available'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  ///Booking Cancelled showCustomDialog
  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(8),
          contentPadding: EdgeInsets.all(8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText2(text: ""),

              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close, size: 32, color: Colors.black),
              ),
            ],
          ),

          // Optional title if provided
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(imageSrc: AppImages.cancelled_image),

                  CustomText2(
                    text: "Booking Cancelled",
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),

                  SizedBox(height: 8),

                  CustomText2(
                    text: "Your booking has been Cancelled \n successfully.",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.neutral03,
                  ),

                  SizedBox(height: 8),

                  CustomButton(
                    onTap: () {
                      Get.to(OwnerBookingScreen());

                      // Navigator.of(context).pop();
                    },
                    title: "Ok",
                    fontSize: 16, // Bigger button text for tablets
                    width: double.infinity,
                    height: 50,
                    fillColor: AppColors.appColors,
                    borderRadius: 24,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestimonial({
    required String name,
    required int rating,
    required String testimonial,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl: AppConstants.profileImage,
            height: 50,
            width: 50,
            boxShape: BoxShape.circle,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText2(
                  text: name,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),

                SizedBox(width: 8),

                Row(
                  children: List.generate(
                    rating,
                    (index) =>
                        Icon(Icons.star, color: Colors.amber, size: 20.0),
                  ),
                ),
                SizedBox(height: 6),

                CustomText2(
                  text: testimonial,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  color: AppColors.grey_2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
