import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_netwrok_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/nav_bar/provider_nav_bar.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderInboxScreen extends StatefulWidget {
  const ProviderInboxScreen({super.key});

  @override
  State<ProviderInboxScreen> createState() => _ProviderInboxScreenState();
}

class _ProviderInboxScreenState extends State<ProviderInboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "Inbox"),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [


            SizedBox(
              height: 20,
            ),

            GestureDetector(
              onTap: (){
               Get.toNamed(AppRoutes.messageScreen);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomNetworkImage(
                        imageUrl: AppConstants.profileImage,
                        height: 50,
                        width: 50,
                        boxShape: BoxShape.circle,
                      ),

                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [

                         CustomText(
                           text: "Mehedi Hassan",
                           fontSize: 18,
                           fontWeight: FontWeight.w600,
                           left: 10,
                         ),

                         CustomText(
                           text: "This is text to use on this messages. ",
                           fontSize: 12,
                           fontWeight: FontWeight.w400,
                           left: 10,
                           color: AppColors.grey_2,
                         ),
                       ],
                     )
                    ],
                  ),
                  CustomText(
                    text: "3.00 pm",
                    fontSize: 14,
                    color: AppColors.grey_2.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            ),

            SizedBox(
              height: 24,
            ),

            GestureDetector(
              onTap: (){
                Get.toNamed(AppRoutes.messageScreen);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                     CustomImage(imageSrc: AppImages.user_image,
                       height: 50,
                       width: 50,
                     ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          CustomText(
                            text: "Joseph Miller",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            left: 10,
                          ),

                          CustomText(
                            text: "This is text to use on this messages. ",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            left: 10,
                            color: AppColors.grey_2,
                          ),
                        ],
                      )
                    ],
                  ),
                  CustomText(
                    text: "1d",
                    fontSize: 14,
                    color: AppColors.grey_2.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            ),

            SizedBox(
              height: 24,
            ),

            GestureDetector(
              onTap: (){
                 Get.toNamed(AppRoutes.messageScreen);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                      CustomImage(imageSrc: AppImages.user_image,
                        height: 50,
                        width: 50,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          CustomText(
                            text: "William Garcia",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            left: 10,
                          ),

                          CustomText(
                            text: "This is text to use on this messages. ",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            left: 10,
                            color: AppColors.grey_2,
                          ),
                        ],
                      )
                    ],
                  ),
                  CustomText(
                    text: "1d",
                    fontSize: 14,
                    color: AppColors.grey_2.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: NavBar(currentIndex: 3),
    );
  }
}


