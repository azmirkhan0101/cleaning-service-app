import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceBooking extends StatefulWidget {
  const ServiceBooking({super.key});

  @override
  State<ServiceBooking> createState() => _ServiceBookingState();
}

class _ServiceBookingState extends State<ServiceBooking> {
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

                      Container(
                        width: 70, // Width of the circle
                        height: 70.0, // Height of the circle
                        decoration: BoxDecoration(
                          color: AppColors.grey_1.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue, // Circle color
                            width: 2.0, // Border thickness
                          ),
                        ),
                        child:Container(
                          width: 20.0, // Width of the circle
                          height: 20.0, // Height of the circle
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                             // color: AppColors.lightBlue, // Circle color
                              width: 1.0, // Border thickness
                            ),
                          ),
                        ),
                      ),
                      CustomText(text: "Step 2",
                          color: AppColors.lightBlue,fontSize: 12,
                          fontWeight: FontWeight.w400)
                    ],
                  )
                ],
              ),

              SizedBox(height: 16),

              CustomText(text: "Enter Your Information",color: AppColors.black,fontSize: 18,
                fontWeight: FontWeight.w600,),

              SizedBox(height: 24),

              /// Date And TimeField
              CustomFormCard(
                  title: "Date And Time",
                  hintText: "Enter date and time",
                  hasBackgroundColor: true,
                  prefixIcon: Icon(Icons.calendar_month),
                  controller: TextEditingController()
              ),

              SizedBox(
                height: 12,
              ),

              /// Phone Number Field
              CustomFormCard(
                  title: "Phone Number",
                  hintText: "Enter phone number",
                  hasBackgroundColor: true,
                  prefixIcon: Icon(Icons.phone),
                  controller: TextEditingController()
              ),

              SizedBox(
                height: 12,
              ),

              /// Service name Field
              CustomFormCard(
                  title: "Enter Address",
                  hintText: "Enter address",
                  prefixIcon: Icon(Icons.location_pin),
                  hasBackgroundColor: true,
                  controller: TextEditingController()
              ),

              SizedBox(
                height: 12,
              ),

              /// Service name Field
              CustomFormCard(
                  title: "Description",
                  hintText: "Enter description",
                  hasBackgroundColor: true,

                  maxLine: 2,
                  controller: TextEditingController()
              ),

              SizedBox(
                height: 12,
              ),

              SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {

                  Get.toNamed(AppRoutes.serviceBookSecondScreen);
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


