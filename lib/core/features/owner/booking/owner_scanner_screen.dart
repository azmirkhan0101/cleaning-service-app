
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OwnerScannerScreen extends StatefulWidget {
  const OwnerScannerScreen({super.key});

  @override
  State<OwnerScannerScreen> createState() => _OwnerScannerScreenState();
}

class _OwnerScannerScreenState extends State<OwnerScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "QR Code Scanner",leftIcon: true,),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          InkWell(
            onTap: (){
              _showRatingDialog(context);
            },
            child: Center(
              child: CustomImage(imageSrc: AppImages.qr_code_image,
                width: 200,
                height: 200,
                fit: BoxFit.cover,),
            ),
          ),

          SizedBox(
            height: 24,
          ),


        ],
      ),
    );
  }


  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(8),
          contentPadding: EdgeInsets.all(8),
          // Optional title if provided
           title: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               CustomText(text: "Completed",
                 fontSize: 22,
                 fontWeight: FontWeight.w600,
                 color:AppColors.black,
               ),

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

                children: [
                  CustomImage(imageSrc: AppImages.alertImage),

                  CustomText(text: "Give your Rating",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:AppColors.black,
                  ),

                  SizedBox(
                    height: 8,
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
                  SizedBox(height: 10),

                /// password Field
                CustomFormCard(
                    titleColor: Colors.black,
                    title: "Comments",
                    hintText: "Nice work",
                    hasBackgroundColor: true,
                    controller:TextEditingController()
                ),

                  SizedBox(height: 10),
                  CustomText(text: 'Provider name: Jorge Bond',fontSize: 18,),

                  SizedBox(
                    height: 12,
                  ),

                  CustomButton(onTap: (){

                    Get.offNamed(AppRoutes.ownerHomeScreen);

                    // Navigator.of(context).pop();
                  },
                    title: "submit",
                    fontSize: 16,
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
