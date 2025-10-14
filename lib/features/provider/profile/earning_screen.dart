import 'dart:ui' as ui;

import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyEarningScreen extends StatefulWidget {
  const MyEarningScreen({super.key});

  @override
  State<MyEarningScreen> createState() => _MyEarningScreenState();
}

class _MyEarningScreenState extends State<MyEarningScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        appBar: CustomAppbar(titleName: "My Earning", leftIcon: true),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 130,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 0.5,
                          color: AppColors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText2(
                                  text: "Weekly earning",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.green,
                                  bottom: 10.h,
                                ),

                                CustomText2(
                                  text: "800\$",
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.green,
                                  bottom: 10.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Card(
                          elevation: 0.5,
                          color: AppColors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText2(
                                  text: "Total earning".tr,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black_04,
                                  bottom: 10.h,
                                ),

                                CustomText2(
                                  text: "800\$",
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black_04,
                                  bottom: 10.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImage(imageSrc: AppImages.earning_image),

                    SizedBox(width: 12.h),
                    CustomText2(
                      text: "Earning Details",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightBlue,
                      bottom: 10.h,
                    ),
                  ],
                ),
                SizedBox(height: 16),

                Card(
                  elevation: 0.5,
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.black),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText2(
                                    text: "Clark Kent",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black_04,
                                  ),
                                  SizedBox(height: 8),
                                  CustomText2(
                                    text: "PayPal",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.lightBlue,
                                  ),
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomText2(
                                    text: "9/21/25 - 11:15 AM",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey_2,
                                  ),

                                  SizedBox(height: 8.h),

                                  CustomText2(
                                    text: "1000\$",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.lightBlue,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
