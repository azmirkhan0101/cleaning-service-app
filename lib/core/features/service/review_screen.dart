import 'package:cleaning_service_app/core/components/custom_netwrok_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';


class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "Review",leftIcon: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (BuildContext context,index){

                    return _buildTestimonial(
                      name: 'Daniel Brown',
                      rating: 5,
                      testimonial: 'Excellent service! Professional, reliable, and exceeded my expectations. Highly recommended!',
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildTestimonial({required String name, required int rating, required String testimonial}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        CustomNetworkImage(
        imageUrl: AppConstants.profileImage,
        height: 50,
        width: 50,
        boxShape: BoxShape.circle,
      ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                CustomText(text:
                name,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),

                SizedBox(width: 8),

                Row(
                  children: List.generate(
                    rating,
                        (index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20.0,
                    ),
                  ),
                ),
                SizedBox(height: 6),

                CustomText(text:
                    testimonial,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    color: AppColors.grey_2
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}