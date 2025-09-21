import 'package:flutter/material.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text_field/custom_text_field.dart';
import 'package:cleaning_service_app/core/features/payment/payment_controller.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart' show AppIcons;
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class BoostPaymentScreen extends StatefulWidget {
  const BoostPaymentScreen({super.key});

  @override
  State<BoostPaymentScreen> createState() => _BoostPaymentScreenState();
}

class _BoostPaymentScreenState extends State<BoostPaymentScreen> {

  final  paymentController = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "Payment",leftIcon: true,),

      body: Padding(
        padding:   EdgeInsets.all(12.0),
        child: Column(
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
            CustomButton(
              onTap: () {

                showCustomDialog(context);
              },
              title:"Pay",
              fontSize: 16, // Bigger button text for tablets
              width: double.infinity,
              height:  50,
              fillColor: AppColors.appColors,
              borderRadius: 24,
              // Wider button on tablets
            )
          ],
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(8),
          contentPadding: EdgeInsets.all(8),
          // Optional title if provided
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(imageSrc: AppImages.alertImage),

                  CustomText(text: "Account created \n Successfully",
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color:AppColors.black,
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  CustomButton(onTap: (){

                    //  if(userType=="provider"){
                    Get.offNamed(AppRoutes.providerHome);

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
}





