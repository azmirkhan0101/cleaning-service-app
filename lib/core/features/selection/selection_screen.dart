

import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/features/auth/auth_controller.dart';
import 'package:cleaning_service_app/core/features/selection/selection_controller.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/core/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryDarkBlue = Color(0xFF13224B);
const Color primaryYellow = Color(0xFFFFC000);
const Color cardBorderBlue = Color(0xFF1E88E5);
const Color unselectedTextColor = Color(0xFF6A6A6A);

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {


  final  selectionController = Get.find<SelectionController>();

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomRoyelAppbar(leftIcon: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Container(
                          width: 70,
                          height: 6,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: index == selectionController.currentIndex.value
                                ? Color(0xFF1E88E5) // Active color (blue)
                                : Colors.grey, // Inactive color (grey)
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }),
                    ),
                  ),

                  SizedBox(
                    height: 22,
                  ),

              if(selectionController.currentIndex.value==0)
               Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   // Main Heading and Subheading
                   const CustomText(text:
                   'How will you use our app?',
                     fontSize: 24,
                     fontWeight: FontWeight.w600,
                     color: Colors.black,
                   ),

                   const SizedBox(height: 12),

                   const CustomText(text:
                   'Our app makes everyday tasks easier and faster, giving you the tools you need right at your fingertips.',
                     fontSize: 12,
                     color: unselectedTextColor,
                     fontWeight: FontWeight.w400,
                     maxLines: 3,
                     textAlign: TextAlign.start,
                   ),

                   const SizedBox(height: 16),

                   Row(
                     children: [
                       Radio<bool>(
                         value: false, // Value for "No"
                         fillColor: WidgetStateColor.resolveWith((states) => AppColors.lightBlue),
                         groupValue: selectionController.typeModeStatues.value,
                         onChanged: (bool? value) {
                           selectionController.typeModeStatues.value = value!;
                         },
                       ),
                       // Owner Card
                       Expanded(
                         child: Container(
                           padding: const EdgeInsets.all(24.0),
                           decoration: BoxDecoration(
                             border: Border.all(
                               color: selectionController.typeModeStatues.value==false
                                   ? Color(0xFF1E88E5) // The blue border for selected
                                   : Colors.white, // The white border for unselected
                               width: 2.0,
                             ),
                             borderRadius: BorderRadius.circular(12.0),
                             boxShadow: [
                               BoxShadow(
                                 color: AppColors.grey_3.withOpacity(0.3),
                                 spreadRadius: 2,
                                 blurRadius: 5,
                                 offset: const Offset(0, 3),
                               ),
                             ],
                           ),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 'Owner',
                                 style: TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                   color: Color(0xFF333333),
                                 ),
                               ),
                               SizedBox(height: 8.0),
                               Text(
                                 'As an Owner, you can easily book trusted services in just a few taps. Browse available providers, compare options, and schedule at your convenience. The app ensures a seamless experience, from booking to payment, so you can get the service you need without any hassle',
                                 style: TextStyle(
                                   fontSize: 14,
                                   color: Color(0xFF555555),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ],
                   ),

                   const SizedBox(height: 20.0), // Spacing between cards

                   Row(
                     children: [
                       Radio<bool>(
                         value: true, // Value for "Yes"
                         fillColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
                         groupValue: selectionController.typeModeStatues.value,
                         onChanged: (bool? value) {
                           selectionController.typeModeStatues.value = value!;
                         },
                       ),
                       // Service Provider Card
                       Expanded(
                         child: Container(
                           padding: const EdgeInsets.all(24.0),
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(12.0),
                             border: Border.all(
                               color: selectionController.typeModeStatues.value
                                   ? Color(0xFF1E88E5) // The blue border for selected
                                   : Colors.white, // The white border for unselected
                               width: 2.0,
                             ),
                             boxShadow: [
                               BoxShadow(
                                 color: AppColors.grey_3.withOpacity(0.3),
                                 spreadRadius: 2,
                                 blurRadius: 5,
                                 offset: const Offset(0, 3),
                               ),
                             ],
                           ),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: const [
                               Text(
                                 'Service Provider',
                                 style: TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                   color: Color(0xFF333333),
                                 ),
                               ),
                               SizedBox(height: 8.0),
                               Text(
                                 'As a Service provider, you get a powerful platform to showcase your skills and connect with new clients. Manage your availability, accept bookings, and grow your business with ease. Our app gives you the tools to build trust, increase visibility, and succeed in your profession.',
                                 style: TextStyle(
                                   fontSize: 14,
                                   color: Color(0xFF555555),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ],
                   ),

                 ],
               ),

              if(selectionController.currentIndex.value==1)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Main Heading and Subheading
                    const  CustomText(text:
                      AppStrings.setLocation,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),

                    const SizedBox(height: 12),

                    const CustomText(text:
                    AppStrings.locationTitle,
                      fontSize: 12,
                      color: unselectedTextColor,
                      fontWeight: FontWeight.w400,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                    ),

                    const SizedBox(height: 24),

                    /// email Field
                    CustomFormCard(
                        title: AppStrings.email,
                        hintText: AppStrings.enterYourEmail,
                        hasBackgroundColor: true,
                        controller: selectionController.loginEmailController.value
                    ),

                     SizedBox(
                       height: 16,
                     ),

                    ///============ Location ============
                    CustomFormCard(
                      title: AppStrings.location,
                      hintText: AppStrings.enterYourLocation,
                      hasBackgroundColor: true,
                      readOnly: true,
                      suffixIcon: Icon(Icons.location_pin),
                      controller: selectionController.locationController.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.fieldCantBeEmpty;
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: 16,
                    ),

                    if(selectionController.typeModeStatues.value==false)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const  CustomText(text:
                        "Show results within",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),

                        Slider(
                          value: 5.0,          // Initial value
                          min: 5.0,            // Minimum value
                          max: 100.0,          // Maximum value
                          // divisions: 95,       // Number of discrete steps
                          onChanged: (double value) {
                            // Handle the slider value change
                            print("Selected distance: $value miles");
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16,right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              CustomText(text: "5 miles",fontWeight: FontWeight.w600, color: AppColors.black_04,fontSize: 14,),

                              CustomText(text: "100 Miles",fontWeight: FontWeight.w600, color: AppColors.black_04,fontSize: 14,),

                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),

             if(selectionController.currentIndex.value==2)
               SizedBox(
                height: MediaQuery.of(context).size.height/2,
                 child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Main Heading and Subheading
                          const  CustomText(text:
                          AppStrings.uploadPhoto,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),

                          const SizedBox(height: 12),

                          const CustomText(text:
                          AppStrings.profileTitle,
                            fontSize: 12,
                            color: unselectedTextColor,
                            fontWeight: FontWeight.w400,
                            maxLines: 3,
                            textAlign: TextAlign.start,
                          ),

                          const SizedBox(height: 32),

                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5, // 50% of the screen width
                              height: MediaQuery.of(context).size.width * 0.5, // Maintain a square aspect ratio
                              child: CustomImage(imageSrc: AppIcons.profileIcons),
                            ),
                          )
                        ],
                      ),
               ),

             if(selectionController.currentIndex.value==3)
              Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Main Heading and Subheading
                        const  CustomText(text:
                        AppStrings.VerifyProfile,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),

                        const SizedBox(height: 12),

                        const CustomText(text:
                        AppStrings.VerifyProfileTitle,
                          fontSize: 12,
                          color: unselectedTextColor,
                          fontWeight: FontWeight.w400,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                        ),

                        const SizedBox(height: 24),

                        // Upload Front Side of ID
                        Container(
                         decoration: BoxDecoration(
                           border: Border.all(
                             color: AppColors.lightBlue.withOpacity(0.6), // The white border for unselected
                             width: 2.0,
                           ),
                           borderRadius: BorderRadius.circular(12.0),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.all(12.0),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               CustomText(
                                 text:"Upload the Front Side of Your ID",
                                 fontSize: 14,
                                 fontWeight: FontWeight.w600,
                               ),

                               SizedBox(height: 6),

                               CustomText(
                                 text:"Take a clear photo or upload the front side of your identity card. Make sure all details are visible.",
                                 fontSize: 12,
                                 fontWeight: FontWeight.w400,
                                 maxLines: 3,
                                 textAlign: TextAlign.start,
                               ),

                               SizedBox(height: 16),

                               ElevatedButton.icon(
                                 onPressed: () {
                                   // Handle the upload action
                                   print("Upload Front Side clicked");
                                 },
                                 icon: Icon(Icons.add,),
                                 label: CustomText(text:
                                 'Upload Front Side',
                                   color: Colors.blue,
                                   fontWeight: FontWeight.w600,
                                   fontSize: 14,
                                 ),
                                 style: ElevatedButton.styleFrom(
                                   side: BorderSide(color: Colors.blue),
                                   minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 45),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(12),
                                   ),
                                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                 ),
                               ),

                             ],
                           ),
                         ),
                       ),

                        SizedBox(height: 22),

                        // Upload Back Side of ID
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.lightBlue.withOpacity(0.6), // The white border for unselected
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text:"Upload the Back Side of Your ID",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),

                                SizedBox(height: 6),

                                CustomText(
                                  text:"Now, upload a clear photo of the back side of your identity card.",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  maxLines: 3,
                                  textAlign: TextAlign.start,
                                ),

                                SizedBox(height: 16),

                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Handle the upload action
                                    print("Upload Front Side clicked");
                                  },
                                  icon: Icon(Icons.add),
                                  label: CustomText(text:
                                    'Upload Back Side',
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(color: Colors.blue),
                                    minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 22),
                        // Upload Selfie with ID

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.lightBlue.withOpacity(0.6), // The white border for unselected
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text:"Upload a Selfie with Your ID",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),

                                SizedBox(height: 6),

                                CustomText(
                                  text:"Take a selfie while holding your identity card next to your face. Ensure everything clearly visible.",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  maxLines: 3,
                                  textAlign: TextAlign.start,
                                ),

                                SizedBox(height: 16),

                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Handle the upload action
                                    print("Upload Front Side clicked");
                                  },
                                  icon: Icon(Icons.add),
                                  label: CustomText(text:
                                    'Upload Selfie with ID',
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(color: Colors.blue),
                                    minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

              if(selectionController.currentIndex.value==4)
               Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Main Heading and Subheading
                        const  CustomText(text:
                        AppStrings.VerifyProfile,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),

                        const SizedBox(height: 12),

                        const CustomText(text:
                        AppStrings.VerifyProfileTitle,
                          fontSize: 12,
                          color: unselectedTextColor,
                          fontWeight: FontWeight.w400,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                        ),

                        const SizedBox(height: 24),


                      ],
                    ),


                  SizedBox(
                    height: 24,
                  ),

                  // Continue Button
                  CustomButton(
                    onTap: () {

                      if(selectionController.currentIndex.value<4){
                        selectionController.currentIndex.value = selectionController.currentIndex.value+1;


                      }else{
                     //   Get.offNamed(AppRoutes.onboardingFourScreen);
                      }
                    },
                    title: selectionController.currentIndex.value >= 4
                        ? 'Next'
                        : AppStrings.continuetext,
                    fontSize: 16, // Bigger button text for tablets
                    width: double.infinity,
                    height:  60,
                    fillColor: AppColors.appColors,
                    // Wider button on tablets
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  buildDot(int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Container(
        width: 70,
        margin: EdgeInsets.symmetric(horizontal: 6.0),
        height: 4.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selectionController.currentIndex.value== index ? AppColors.appColors : AppColors.grey_1,

        ),
      ),
    );
  }


}

