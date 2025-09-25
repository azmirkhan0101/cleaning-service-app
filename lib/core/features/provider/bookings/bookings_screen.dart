import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_tab_selected/custom_tab_single_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/nav_bar/provider_nav_bar.dart';
import 'package:cleaning_service_app/core/features/provider/bookings/booking_controller.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {

  final bookingController = Get.find<BookingController>();

  String status="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _initializeData();
  }

  void _initializeData() async {

    final arguments = Get.arguments;

    if(arguments != null && arguments.isNotEmpty) {

      if (Get.arguments[0]["status"] != null) {
        status = Get.arguments[0]["status"];

        if(status=="Pending"){
          bookingController.selectedIndex(1);

        }if(status=="accept"){
          bookingController.selectedIndex(2);

        } if(status=="reject"){
          bookingController.selectedIndex(4);

        } if(status=="completed"){
          bookingController.selectedIndex(3);
        }

      }
    }
    

  }

  @override
  Widget build(BuildContext context) {


    // Create a List of Strings
    List<String> statusList = [
      'Pending',
      'Completed',
      'Ongoing',
      'Cancelled',
      'Completed',
      'Ongoing',
    ];

    return DefaultTabController(
      length: 4, // The number of tabs
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
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
                    fontSize: 14,
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

                  /// all list
                  if(bookingController.selectedIndex.value==0)
                    ListView.builder(
                        itemCount: 6,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context,index){

                          return  InkWell(
                            onTap: (){

                              Get.toNamed(AppRoutes.serviceDetailsScreen,
                                  arguments: [
                                    {
                                      "status":statusList[index].toLowerCase()
                                    }
                                  ]);
                            },
                            child: ServiceCard(
                              status: statusList[index],
                              imageUrl: AppImages.clean_image, // Replace with actual image URL
                              serviceDetails: 'Need deep cleaning for 2 bedrooms and 1 bathroom. Also, please bring cleaning supplies.',
                              price: 25.00,
                              duration: 2,
                            ),
                          );
                        }),

                  /// Pending list
                  if(bookingController.selectedIndex.value==1)
                  ListView.builder(
                      itemCount: 6,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context,index){

                     return  InkWell(
                       onTap: (){
                         Get.toNamed(AppRoutes.serviceDetailsScreen,
                             arguments: [
                               {
                                 "status":statusList[index].toLowerCase()
                               }
                             ]);
                       },
                       child: ServiceCard(
                        status: 'Pending',
                        imageUrl: AppImages.clean_image, // Replace with actual image URL
                        serviceDetails: 'Need deep cleaning for 2 bedrooms and 1 bathroom. Also, please bring cleaning supplies.',
                        price: 25.00,
                        duration: 2,
                                           ),
                     );
                  }),


                  /// ongoing list
                  if(bookingController.selectedIndex.value==2)
                    ListView.builder(
                        itemCount: 6,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context,index){

                          return  InkWell(
                            onTap: (){

                              Get.toNamed(AppRoutes.serviceDetailsScreen,
                                  arguments: [
                                    {
                                      "status":"ongoing"
                                    }
                                  ]);
                            },
                            child: ServiceCard(
                              status: 'Ongoing',
                              imageUrl: AppImages.clean_image, // Replace with actual image URL
                              serviceDetails: 'Need deep cleaning for 2 bedrooms and 1 bathroom. Also, please bring cleaning supplies.',
                              price: 25.00,
                              duration: 2,
                            ),
                          );
                        }),

                  /// completed list
                  if(bookingController.selectedIndex.value==3)
                    ListView.builder(
                        itemCount: 6,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context,index){

                          return  InkWell(
                            onTap: (){

                           Get.toNamed(AppRoutes.serviceDetailsScreen);

                            },
                            child: ServiceCard(
                              status: 'Completed',
                              imageUrl: AppImages.clean_image, // Replace with actual image URL
                              serviceDetails: 'Need deep cleaning for 2 bedrooms and 1 bathroom. Also, please bring cleaning supplies.',
                              price: 25.00,
                              duration: 2,
                            ),
                          );
                        }),

                  /// cancelled list
                  if(bookingController.selectedIndex.value==4)
                    ListView.builder(
                        itemCount: 6,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context,index){

                          return  InkWell(
                            onTap: (){

                              Get.toNamed(AppRoutes.serviceDetailsScreen,
                                  arguments: [
                                  {
                                  "status":"cancelled"
                                  }
                                  ]);

                            },
                            child: ServiceCard(
                              status: 'Cancelled',
                              imageUrl: AppImages.clean_image, // Replace with actual image URL
                              serviceDetails: 'Need deep cleaning for 2 bedrooms and 1 bathroom. Also, please bring cleaning supplies.',
                              price: 25.00,
                              duration: 2,
                            ),
                          );
                        }),
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
        elevation: 0.5,
        color: AppColors.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
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
               SizedBox(width: 16),
                Expanded( // Wrap this Column in an Expanded widget
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Cleaning Service',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color:status=="Pending"? AppColors.danger:status=="Completed"?AppColors.normal:status=="Ongoing"?AppColors.lightBlue:status=="Cancelled"?AppColors.cancle:AppColors.white_50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomText(
                                text: status,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      CustomText(
                        text: 'Location: Mohakhali, Aqua Tower 10th Floor',
                        color: AppColors.neutral03,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 8),
                      CustomText(
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

            CustomText(
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
                CustomText(
                  text: 'Price',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  color: AppColors.black,
                ),
                CustomText(
                  text: '€${price.toStringAsFixed(2)}hr',
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: 'Duration'),
                CustomText(text: '$duration hr'),
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text:
                  'Total',
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightBlue,
                ),
                CustomText(text:
                  '€${(price * duration).toStringAsFixed(2)}',
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