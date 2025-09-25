

import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_netwrok_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/features/owner/home/owner_controller.dart';
import 'package:cleaning_service_app/core/features/payment/payment_controller.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OwnerSearchScreen extends StatefulWidget {
  const OwnerSearchScreen({super.key});

  @override
  State<OwnerSearchScreen> createState() => _OwnerSearchScreenState();
}

class _OwnerSearchScreenState extends State<OwnerSearchScreen> {

  final  ownerController = Get.find<OwnerController>();

  int? _selectedExperience;
  bool? _instantBooking;
  String? _selectedGender;

  final  paymentController = Get.find<PaymentController>();

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
      appBar: CustomAppbar(titleName: "Search",leftIcon: true,),
      body: ListView(
       children: [
         Padding(
           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [

               SizedBox(
                 height: 8,
               ),

               /// Search  Field
               CustomFormCard(
                   title: "Search",
                   hintText: "Search",
                   hasBackgroundColor: true,
                   prefixIcon: Icon(Icons.search),
                   suffixIcon: InkWell(child: Icon(Icons.content_paste_search,color: AppColors.black,),
                   onTap: (){
                     showCustomDialog(context);
                   },
                   ),
                   controller: TextEditingController()

               ),

               SizedBox(
                 height: 12,
               ),

               ///================== Category show =============
               SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [

                     Container(
                       width: 110,
                       height: 45,
                       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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

                           CustomImage(imageSrc: AppIcons.service_all,),

                           SizedBox(
                             width: 2,
                           ),
                           CustomText(text: "All Service",fontSize: 12,fontWeight: FontWeight.w500,
                             color: AppColors.white,)
                         ],
                       ),
                     ),

                     SizedBox(
                       width: 12,
                     ),

                     Container(
                       width: 110,
                       height: 45,
                       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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

                           SizedBox(
                             width: 2,
                           ),

                           CustomText(text: "Cleaning",fontSize: 12,fontWeight: FontWeight.w500,
                             color: AppColors.black,)
                         ],
                       ),
                     ),

                     SizedBox(
                       width: 12,
                     ),

                     Container(
                       width: 110,
                       height: 45,
                       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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

                           SizedBox(
                             width: 2,
                           ),

                           CustomText(text: "Laundry",fontSize: 12,fontWeight: FontWeight.w500,
                             color: AppColors.black,)
                         ],
                       ),
                     ),

                     SizedBox(
                       width: 12,
                     ),

                     Container(
                       width: 110,
                       height: 45,
                       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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

                           CustomImage(imageSrc: AppIcons.working,width: 16,height: 16,),

                           SizedBox(
                             width: 2,
                           ),

                           Expanded(
                             child: CustomText(text: "Handyman",fontSize: 10,fontWeight: FontWeight.w500,
                               color: AppColors.black,),
                           )
                         ],
                       ),
                     ),
                   ],
                 ),
               ),

               SizedBox(
                   height: 12
               ),

               GridView.builder(
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                // padding: EdgeInsets.all(8),
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2, // Number of columns
                   crossAxisSpacing: 6.0, // Space between columns
                   mainAxisSpacing: 8.0, // Space between rows
                   childAspectRatio: 0.55, // Aspect ratio of each item
                 ),
                 itemCount: services.length,
                 itemBuilder: (context, index) {
                   final service = services[index];
                   return InkWell(
                     onTap: (){

                       ///service Details screen owner
                       Get.toNamed(AppRoutes.ownerServiceDetailsScreen);
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
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     CustomText(
                                       text: service['title']!,
                                       fontSize: 12,
                                       fontWeight: FontWeight.w600,
                                     ),

                                     SizedBox(height: 4),

                                     // Rating
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

                                     SizedBox(
                                       width: 4,
                                     ),
                                     CustomText(
                                       text: 'Jorge Bond',
                                       fontSize: 12,
                                       color: Colors.black,
                                       fontWeight: FontWeight.w400,
                                     ),
                                   ],
                                 ),
                                 SizedBox(height: 8),

                                 CustomText(
                                   text: 'Start from- Instant Booking',
                                   fontSize: 10,
                                   color: Colors.grey,
                                   fontWeight: FontWeight.w400,
                                 ),
                                 SizedBox(height: 6),

                                 // Price
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     CustomText(
                                       text: service['price']!,
                                       fontSize: 12,
                                       color: AppColors.lightBlue,
                                       fontWeight: FontWeight.w600,
                                     ),

                                     CustomImage(imageSrc: AppImages.arrayicon)
                                   ],
                                 )
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                   );
                 },
               )
             ],
           ),
         )
       ],
      ),

    );
  }


  ///filter service data
  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(8),
          contentPadding: EdgeInsets.all(8),
          scrollable: true,
          // Optional title if provided
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(""),

              IconButton(onPressed: (){

                Navigator.of(context).pop();
              }, icon: Icon(Icons.close,size: 32,))
            ],
          ),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ///================== Category show =============
               /*   Row(
                    mainAxisSize: MainAxisSize.min,  // Ensure Row size is as small as needed
                    children: [
                      // First item
                      Container(
                        width: 110,
                        height: 45,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomImage(imageSrc: AppIcons.service_all),
                            SizedBox(width: 2),
                            CustomText(
                              text: "All Service",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      // Second item
                      Container(
                        width: 110,
                        height: 45,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomImage(imageSrc: AppIcons.cleaning),
                            SizedBox(width: 2),
                            CustomText(
                              text: "Cleaning",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      // Add more items as needed

                      Container(
                        width: 110,
                        height: 45,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomImage(imageSrc: AppIcons.laundry),
                            SizedBox(width: 2),
                            CustomText(
                              text: "Laundry",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),*/


                  ElevatedButton(
                    onPressed: () {

                      Get.toNamed(AppRoutes.pickerMapScreen);

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white_50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // pill shape
                        side: const BorderSide(color: Colors.lightBlue, width: 1), // border
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      elevation: 0, // flat style, remove shadow

                    // minimumSize: Size(50, 50),  // 90% of screen width
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        CustomImage(imageSrc: AppIcons.send_icon),

                        SizedBox(
                          width: 8,
                        ),

                        CustomText(
                          text: 'Use my current location',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),

                      ],
                    ),
                  ),


                  SizedBox(
                    height: 8,
                  ),

                  const  CustomText(text:
                  "Price/hour ",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),

                  Slider(
                    value: 5.0,          // Initial value
                    min: 5.0,            // Minimum value
                    max: 100.0,          // Maximum value
                    // divisions: 95,       // Number of discrete steps
                    activeColor: AppColors.lightBlue,
                    onChanged: (double value) {
                      // Handle the slider value change
                      print("Selected distance: $value miles");
                    },
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  CustomText(text: "Select Rating",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color:AppColors.black,
                  ),

                  SizedBox(height: 10),

                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    itemSize: 40,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.orange,
                    ),
                    onRatingUpdate: (rating) {
                      print('Rating: $rating');
                    },
                  ),

                  SizedBox(
                    width: 12,
                  ),

                  ///Professional's Experience Section
                  _buildSectionHeader("Professional's experience"),
                  const SizedBox(height: 16),
                  _buildExperienceOptions(),
                  const SizedBox(height: 16),

                  ///Instant Booking Section
                  _buildSectionHeader("Instant Booking"),
                  const SizedBox(height: 16),
                  _buildInstantBookingOptions(),
                  const SizedBox(height: 16),

                  ///Gender Section
                  _buildSectionHeader("Gender"),
                  const SizedBox(height: 16),
                  _buildGenderOptions(),

                  const SizedBox(height: 16),

                  CustomText(text: "Spoken Language",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color:AppColors.black,
                  ),

                  Obx(() {
                    return SizedBox(
                      height: 60,
                      child: Card(
                        color: AppColors.white,
                        elevation: 0.2,
                        child: DropdownButton<String>(
                          value: paymentController.selectedCountry.value.isEmpty
                              ? null
                              : paymentController.selectedCountry.value,  // Bind to the GetX value
                          onChanged: (String? newValue) {
                            paymentController.selectedCountry.value = newValue!;
                          },
                          items: <String>['USA', 'Canada', 'India', 'Australia']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              enabled: true,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0,),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                          icon: Icon(Icons.arrow_drop_down),  // Adding the dropdown icon
                          iconSize: 24,  // Adjust the icon size if needed
                          isExpanded: true,  // Makes the DropdownButton take up all available space
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                CustomButton(onTap: (){
                   Navigator.of(context).pop();
                  },
                    title: "show",
                    fontSize: 16, // Bigger button text for tablets
                    width: double.infinity,
                    height:  50,
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


  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildExperienceOptions() {
    final options = [
      "0-2 years of experience",
      "2-5 years of experience",
      "6-10 years of experience",
      "11-20 years of experience",
      "+20 years of experience",
    ];

    return Column(
      children: List.generate(options.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Checkbox(
                value: _selectedExperience == index,
                onChanged: (bool? value) {
                  setState(() {
                    _selectedExperience = value == true ? index : null;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              const SizedBox(width: 8),

              CustomText(text:
                options[index],
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInstantBookingOptions() {
    return Row(
      children: [

        Row(
          children: [
            Checkbox(
              value: _instantBooking == true,
              onChanged: (bool? value) {
                setState(() {
                  _instantBooking = value == true ? true : null;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Yes",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const SizedBox(width: 16),

        Row(
          children: [

            Checkbox(
              value: _instantBooking == false,
              onChanged: (bool? value) {
                setState(() {
                  _instantBooking = value == true ? false : null;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(width: 8),
            const Text(
              "No",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOptions() {
    return Row(
      children: [
        Row(
          children: [
            Checkbox(
              value: _selectedGender == "Male",
              onChanged: (bool? value) {
                setState(() {
                  _selectedGender = value == true ? "Male" : null;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Male",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(width: 32),
        Row(
          children: [
            Checkbox(
              value: _selectedGender == "Female",
              onChanged: (bool? value) {
                setState(() {
                  _selectedGender = value == true ? "Female" : null;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Female",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}


