import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text_field/custom_text_field.dart';
import 'package:cleaning_service_app/features/payment/payment_controller.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart' show AppColors;
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceBookSecondScreen extends StatefulWidget {
  const ServiceBookSecondScreen({super.key});

  @override
  State<ServiceBookSecondScreen> createState() => _ServiceBookSecondScreenState();
}

class _ServiceBookSecondScreenState extends State<ServiceBookSecondScreen> {

  final  paymentController = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "Book Details",leftIcon: true,),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        StepCircle(isActive: true, isCompleted: true),
                        CustomText(text: "Step 1",color: AppColors.black,fontSize: 12,fontWeight: FontWeight.w400,)
                      ],
                    ),
                    SizedBox(width: 20),
                    CustomText(text: "-------------",color: AppColors.black,fontSize: 24,),
                    SizedBox(width: 20),

                    Column(
                      children: [
                        ///StepCircle(isActive: false, isCompleted: false),

                        StepCircle(isActive: true, isCompleted: true),
                        CustomText(text: "Step 2",color: AppColors.black,fontSize: 12,fontWeight: FontWeight.w400,),

                      ],
                    )
                  ],
                ),

                SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 6),
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

                          ///Date and Day
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  children: [
                                    CustomText(text:
                                    "7",
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    CustomText(text:
                                    "AUG",
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
                                  CustomText(text:
                                  "Tuesday",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),

                                  SizedBox(height: 8),
                                  // Time and Buffer Time
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(text:
                                      "Time: 07:00 PM",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                      ),
                                      CustomText(text:
                                      "Buffer Time: 30 minutes",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ),
                                ],
                              )

                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const  CustomText(text:
                    "Service Duration",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),

                    Slider(
                      value: 5.0,          // Initial value
                      min: 5.0,            // Minimum value
                      max: 100.0,
                      activeColor: AppColors.black,
                      // Maximum value
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

                          CustomText(text: "2 hr",fontWeight: FontWeight.w600, color: AppColors.black_04,fontSize: 14,),

                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                /// Bill & Details Field
                CustomFormCard(
                    title: "Bill & Details",
                    hintText: "Enter Bill & Details",
                    hasBackgroundColor: true,
                    controller: TextEditingController()
                ),

                SizedBox(height: 12),

                /// service name
                ServiceCard(
                  status: '',
                  imageUrl: AppImages.clean_image, // Replace with actual image URL
                  serviceDetails: 'Need deep cleaning for 2 bedrooms and 1 bathroom. Also, please bring cleaning supplies.',
                  price: 25.00,
                  duration: 2,
                ),


                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    CustomText(text:
                    'Payment Method',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:AppColors.black,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    CustomImage(imageSrc: AppImages.visaCard),

                    const SizedBox(
                      height: 16,
                    ),

                    CustomText(text:
                    'Card Number',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:AppColors.black,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    ///Card Input
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.black_80, width: 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                fillColor: AppColors.white,
                                hintText: "1234 1234 1234 1234",
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            CustomImage(imageSrc: AppIcons.cardImage)
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 16,
                    ),

                    /// **Expiration Date & cvc Code
                    Row(
                      children: [
                        Expanded(
                          child: CustomFormCard(
                            title: AppStrings.expiration,
                            hintText: AppStrings.enterDay,
                            hasBackgroundColor: true,
                            controller: TextEditingController(),
                          ),
                        ),

                        SizedBox(width:  8),

                        Expanded(
                          child: CustomFormCard(
                            title: AppStrings.enterSecurity,
                            hintText: AppStrings.enterSecurityValue,
                            hasBackgroundColor: true,
                            controller: TextEditingController(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 16,
                    ),

                    ///century  & zip Code
                    Row(

                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        Expanded(
                          child:   // Reactive Dropdown
                          Obx(() {
                            return SizedBox(
                              height: 60,
                              child: Card(
                                elevation: 0.5,
                                color: AppColors.white,
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

                        ),

                        SizedBox(width: 8),

                        Expanded(
                          child: CustomFormCard(
                            title: AppStrings.zipText,
                            hintText: AppStrings.zipCode,
                            hasBackgroundColor: true,
                            controller: TextEditingController(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    /// Pay Button
                    CustomText(text:
                      'Cancellation & Refund Policy',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    SizedBox(height: 12),

                    BulletPoint(text: 'You can cancel your booking within 2 hours of placing it.'),
                    BulletPoint(text: 'After 2 hours, cancellation will not be allowed.'),
                    BulletPoint(text: 'If you cancel within the allowed time, the full amount will be refunded to your account.'),

                  ],
                ),

                SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {

                   ///Get.toNamed(AppRoutes.serviceBookSecondScreen);

                    showCustomDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColors,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),  // 90% of screen width
                  ),
                  child: CustomText(
                    text: 'Confirm',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
        ),
      ),

    );
  }
}

///Booking  Done showCustomDialog
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
            CustomText(text: ""),
            
            IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Icon(Icons.close,size: 32,color: Colors.black,))
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
                CustomImage(imageSrc: AppImages.alertImage),

                CustomText(text: "Booking  Done",
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color:AppColors.black,
                ),

                SizedBox(
                  height: 8,
                ),

                CustomText(text: "You have successful made order",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color:AppColors.neutral03,
                ),

                SizedBox(
                  height: 8,
                ),

                CustomButton(onTap: (){


                  Get.offNamed(AppRoutes.ownerHomeScreen);

                  // Navigator.of(context).pop();
                },
                  title: "Back to Home",
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
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
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
                       /*   Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:status=="Pending"? AppColors.danger:status=="Completed"?AppColors.normal:status=="Ongoing"?AppColors.lightBlue:status=="Cancelled"?AppColors.cancle:AppColors.white_50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomText(
                              text: status,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),*/
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


class StepCircle extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;

  StepCircle({required this.isActive, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 32,
      backgroundColor: isCompleted
          ? AppColors.lightBlue
          : isActive
          ? Colors.blueAccent
          : Colors.grey[300],
      child: isCompleted
          ? Icon(
        Icons.check,
        color: Colors.white,
        size: 32,
      )
          : null,
    );
  }
}


class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 6, color: Colors.black),
        SizedBox(width: 8),
        Expanded(
          child: CustomText(text:
            text,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.neutral03,
            textAlign: TextAlign.start,
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}
