
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/nav_bar/owner_nav_bar.dart';
import 'package:cleaning_service_app/core/components/nav_bar/provider_nav_bar.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({super.key});

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {


  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> appointments = [
      {
        'name': 'John Doe',
        'time': '34m ago',
        'appointment': 'Sep 10, 2025 - 11:30 AM with John Doe (Cleaning)',
        'avatar': 'https://www.w3schools.com/w3images/avatar2.png'
      },
      {
        'name': 'Sarah Lee',
        'time': '40m ago',
        'appointment': 'Sep 10, 2025 - 11:30 AM with John Doe (Cleaning)',
        'avatar': 'https://www.w3schools.com/w3images/avatar3.png'
      },
      {
        'name': 'John Doe',
        'time': '50m ago',
        'appointment': 'Sep 10, 2025 - 11:30 AM with John Doe (Cleaning)',
        'avatar': 'https://www.w3schools.com/w3images/avatar1.png'
      },
      {
        'name': 'John Doe',
        'time': '55m ago',
        'appointment': 'Sep 10, 2025 - 11:30 AM with John Doe (Cleaning)',
        'avatar': 'https://www.w3schools.com/w3images/avatar4.png'
      },
      {
        'name': 'Hasan',
        'time': '55m ago',
        'appointment': 'Sep 10, 2025 - 11:30 AM with John Doe (Cleaning)',
        'avatar': 'https://www.w3schools.com/w3images/avatar4.png'
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
          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

             Row(
               children: [

                 Icon(Icons.location_pin,color: AppColors.lightBlue,),

                 SizedBox(
                   width: 6,
                 ),

                 Column(
                  children: [

                  Row(
                    children: [
                      CustomText(text:
                      'My Location',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color:AppColors.black,
                      ),

                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: (){
                          Get.toNamed(AppRoutes.locationScreen);
                        },
                          child: Icon(Icons.edit,size: 18,))
                    ],
                  ),

                    CustomText(text:
                    'Dhaka',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:AppColors.black,
                    ),
                  ],
                )

               ],
             ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [

                  Card(
                      elevation: 0.2,
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(AppImages.base),
                      )),

                  CustomText(text:
                  'Pro Badge',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color:AppColors.black,
                  ),

                  InkWell(
                    onTap: (){
                      Get.toNamed(AppRoutes.notificationScreen);
                    },
                      child: CustomImage(imageSrc: AppImages.notification,)),
                ],
              ),
            ],
            ),

            SizedBox(height: 16,),

             Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Get.toNamed(AppRoutes.bookingsScreen,arguments: [
                          {
                            "status":"accept"
                          }
                        ]);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 0.5,
                        color: AppColors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 CustomText(text:
                                 'Current Bookings',
                                   fontSize: 12.0,
                                   fontWeight: FontWeight.w500,
                                   color: Colors.black,
                                 ),

                                 CustomImage(imageSrc: AppIcons.current_icon)
                               ],
                             ),

                              SizedBox(height: 8.0),

                              CustomText(text:
                              '05',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),

                              SizedBox(height: 8.0),

                              CustomText(text:
                              'Current Bookings',
                                fontSize: 8.0,
                                fontWeight: FontWeight.w400,
                                color: AppColors.neutral03,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0.5,
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [

                                 CustomText(text:
                                 'Earnings',
                                   fontSize: 12.0,
                                   fontWeight: FontWeight.w500,
                                   color: Colors.black,
                                 ),

                                 CustomImage(imageSrc: AppIcons.earning_icon)
                               ],
                             ),

                            SizedBox(height: 8.0),

                            CustomText(text:
                            '€2,450',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),

                            SizedBox(height: 8.0),

                            CustomText(
                              text:
                              'This Month',
                              fontSize: 8.0,
                              fontWeight: FontWeight.w400,
                              color: AppColors.neutral03,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [


                  Expanded(
                      child: InkWell(
                        onTap: (){
                          Get.toNamed(AppRoutes.providerInboxScreen);
                        },
                        child: Card(
                          elevation: 0.5,
                          color: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    CustomText(text:
                                    'New Message',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),

                                    CustomImage(imageSrc: AppIcons.message)
                                  ],
                                ),

                                SizedBox(height: 8.0),

                                CustomText(text:
                                '03',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                                SizedBox(height: 8.0),

                                CustomText(text:
                                'Unread',
                                  fontSize: 8.0,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.neutral03,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),


                   Expanded(
                    child: InkWell(
                      onTap: (){
                        Get.toNamed(AppRoutes.proPlanSubscriptionScreen);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 0.5,
                        color: AppColors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  CustomText(text:
                                  'Current Plan',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),

                                  CustomImage(imageSrc: AppIcons.current_plan)
                                ],
                              ),
                              SizedBox(height: 8.0),

                              CustomText(text:
                              'Pro Plan',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),

                              SizedBox(height: 8.0),

                              Row(
                                children: [
                                  CustomText(
                                    text:
                                    'Expired date:',
                                    fontSize: 8.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.neutral03,
                                  ),

                                  CustomText(
                                    text:
                                    '10 October 2025',
                                    fontSize: 8.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.lightBlue,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16,),

             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [

                const CustomText(
                   text:
                   'Pending Bookings',
                   fontSize: 16,
                   fontWeight: FontWeight.w600,
                   color: AppColors.black,
                 ),

                 InkWell(
                   onTap: (){
                     Get.toNamed(AppRoutes.bookingsScreen,arguments: [
                       {
                         "status":"Pending"
                       }
                     ]);
                   },
                   child: Padding(
                     padding: const EdgeInsets.only(right: 8),
                     child: CustomText(
                       text:
                       'See all',
                       fontSize: 14,
                       fontWeight: FontWeight.w600,
                       color: AppColors.lightBlue,
                     ),
                   ),
                 ),

               ],
             ),

              const SizedBox(height: 12,),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  return AppointmentCard(
                    name: appointments[index]['name']!,
                    time: appointments[index]['time']!,
                    appointment: appointments[index]['appointment']!,
                    avatarUrl: appointments[index]['avatar']!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(currentIndex: 0),
    );
  }

}

class AppointmentCard extends StatelessWidget {
  final String name;
  final String time;
  final String appointment;
  final String avatarUrl;

  const AppointmentCard({
    required this.name,
    required this.time,
    required this.appointment,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.toNamed(AppRoutes.bookingsScreen,arguments: [
          {
            "status":"Pending"
          }
        ]);
      },
      child: Card(
        elevation: 0.5,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         CustomText(text:
                         name,
                           fontSize: 16.0,
                           fontWeight: FontWeight.w500,
                         ),

                         CustomText(text:
                          time,
                           fontSize: 12.0,
                           fontWeight: FontWeight.w400,
                           color: AppColors.neutral03,
                         ),
                       ],
                     ),

                   const SizedBox(height: 12.0),

                    CustomText(
                      text:
                      appointment,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.neutral03,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
