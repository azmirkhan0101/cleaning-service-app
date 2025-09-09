import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "Payment",leftIcon: true,),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              /// payment card
             Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color:AppColors.lightBlue,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Color(0xFF1E88E5) ,// The blue border for selected
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
                children:   [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text:
                      '€29 / month',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white_50,
                      ),


                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0), // Padding inside the container
                        decoration: BoxDecoration(
                          color:AppColors.white_50, // Background color
                          borderRadius: BorderRadius.circular(20.0), // Rounded corners
                          border: Border.all(color: AppColors.white_50), // Border color
                        ),
                        child: CustomText(
                          text: 'Pro Plan',
                          color: AppColors.black, // Text color
                          fontSize: 10.0, // Font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),

                    ],
                  ),

                  SizedBox(height: 6.0),

                  CustomText(text:
                  'Commission: 10%',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white_50,
                  ),

                  SizedBox(height: 8.0),

                  Row(
                    children: [
                      Icon(Icons.check_circle,color:AppColors.white_50,),

                      SizedBox(width: 6.0),

                      CustomText(text:
                      'Priority listing',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color:AppColors.white_50,
                      ),

                    ],
                  ),

                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.check_circle,color: AppColors.white_50,),

                      SizedBox(width: 6.0),

                      CustomText(text:
                      'Pro badge',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color:AppColors.white_50,
                      ),

                    ],
                  ),

                  SizedBox(height: 8.0),

                  Row(
                    children: [
                      Icon(Icons.check_circle,color:AppColors.white_50,),

                      SizedBox(width: 6.0),

                      CustomText(text:
                      ' €20 credits/month',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color:AppColors.white_50,
                      ),

                    ],
                  ),

                ],
              ),
            ),

            SizedBox(
              height: 12,
            ),

            CustomText(text:
            'Payment Method',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color:AppColors.black,

            ),
          ],
        ),
      ),
    );
  }
}
