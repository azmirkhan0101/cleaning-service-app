import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';

class ReferScreen extends StatefulWidget {
  const ReferScreen({super.key});

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:
            ''
            'Refer Your \n Friends and Earn',
        backButton: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                CustomImage(imageSrc: AppImages.refer_image, height: 300),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText2(
                        text: 'Important Note',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),

                      SizedBox(height: 8),

                      CustomText2(
                        text:
                            '• Invite a verified & active provider and get -3% commission discount for 1 month.',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),

                      SizedBox(height: 8),
                      CustomText2(
                        text: 'Multiple referrals can extend the discount:',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: 8),
                      Text('• 3 providers invited → 3 months discount'),
                      Text(
                        '• 5 providers invited → permanent -3% and "Scout Provider" badge',
                      ),

                      SizedBox(height: 32),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue, // Button color
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Referral Code',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '8cs445',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            CustomText2(
                              text: "Copy Code",
                              color: AppColors.white_50,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColors,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.9,
                      50,
                    ), // 90% of screen width
                  ),
                  child: CustomText2(
                    text: 'Share Now',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
