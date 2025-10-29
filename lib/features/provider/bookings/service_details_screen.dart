import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  String status = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initializeData();
  }

  void _initializeData() async {
    final arguments = Get.arguments;

    if (arguments != null && arguments.isNotEmpty) {
      if (arguments[0]["status"] != null) {
        status = Get.arguments[0]["status"];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleName: "Cleaning Service", leftIcon: true),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              child: Card(
                elevation: 0.5,

                color: AppColors.neutral02.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date and Day
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                CustomText2(
                                  text: "7",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                CustomText2(
                                  text: "AUG",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText2(
                                text: "Tuesday",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),

                              SizedBox(height: 8),
                              // Time and Buffer Time
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText2(
                                    text: "Time: 07:00 PM",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                  CustomText2(
                                    text: "Buffer Time: 30 minutes",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Pending list
            ServiceCard(
              status: 'Pending',
              imageUrl: AppImages.clean_image, // Replace with actual image URL
              serviceDetails:
                  'Need deep cleaning for 2 bedrooms and 1 bathroom. Also, please bring cleaning supplies.',
              price: 25.00,
              duration: 2,
            ),

            SizedBox(height: 8),

            Card(
              elevation: 0.2,
              color: AppColors.white,
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImage(
                          imageSrc: AppImages.user_image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    CustomText2(
                      text: 'Total',
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                    SizedBox(height: 8),
                    CustomText2(
                      text: 'Daniel Brown',
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                    SizedBox(height: 12),
                    CustomText2(
                      text: 'Phone Number',
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                    SizedBox(height: 8),
                    CustomText2(
                      text: '01840-560684',
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                    SizedBox(height: 12),
                    CustomText2(
                      text: 'Email',
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                    SizedBox(height: 8),
                    CustomText2(
                      text: 'brown@gmail.com',
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                    SizedBox(height: 12),
                    CustomText2(
                      text: 'Address',
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                    SizedBox(height: 8),
                    CustomText2(
                      text: 'Los Angeles, California',
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                    SizedBox(height: 12),
                    CustomText2(
                      text: 'Description',
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          // Changed to Flexible
                          child: SingleChildScrollView(
                            scrollDirection:
                                Axis.horizontal, // Horizontal scrolling
                            child: CustomText2(
                              text:
                                  'Hello! I’m a dedicated cleaning service provider with a passion for creating spotless, comfortable, and healthy spaces',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14,
                              maxLines: 3,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        CustomText2(
                          text: 'Read More',
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightBlue,
                          fontSize: 14,
                        ),
                      ],
                    ),

                    SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.providerInboxScreen);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImage(
                            imageSrc: AppImages.chart,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// cancelled status active and reject
            if (status != "cancelled")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (status == "pending")
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.bookingsScreen,
                          arguments: [
                            {"status": "accept"},
                          ],
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appColors,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.4,
                          50,
                        ), // 90% of screen width
                      ),
                      child: CustomText2(
                        text: 'Accept',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  if (status == "pending")
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.bookingsScreen,
                          arguments: [
                            {"status": "reject"},
                          ],
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white_50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50), // pill shape
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ), // border
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        elevation: 0, // flat style, remove shadow

                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.4,
                          50,
                        ), // 90% of screen width
                      ),
                      child: CustomText2(
                        text: 'Reject',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),

            if (status == "ongoing")
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.qrScannerScreen);
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
                  text: 'QR Code',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

            SizedBox(height: 8),
          ],
        ),
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
      elevation: 0.2,
      color: AppColors.white,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImage(
                    imageSrc: imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),

                Flexible(
                  // Changed to Flexible instead of Expanded
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText2(
                        text: 'Cleaning Service',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 8),
                      CustomText2(
                        text: 'Location: Mohakhali, Aqua Tower 10th Floor',
                        color: AppColors.neutral03,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 8),
                      CustomText2(
                        text: serviceDetails,
                        color: AppColors.neutral03,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            CustomText2(
              text: 'Price Details',
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText2(
                  text: 'Price',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  color: AppColors.black,
                ),
                CustomText2(text: '€${price.toStringAsFixed(2)}hr'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText2(text: 'Duration'),
                CustomText2(text: '$duration hr'),
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText2(
                  text: 'Total',
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightBlue,
                ),
                CustomText2(
                  text: '€${(price * duration).toStringAsFixed(2)}',
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightBlue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
