import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:cleaning_service_app/features/provider/service/controllers/review_fetch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewScreen extends StatefulWidget {



  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  final ReviewFetchController controller = Get.put<ReviewFetchController>(ReviewFetchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Review", backButton: true),
      body: Obx((){
        if( controller.isLoading.value ){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if( controller.errorMessage.value.isNotEmpty ){
          return Center(
            child: Text(controller.errorMessage.value),
          );
        }else if( controller.reviews.isEmpty ){
          return Center(
            child: Text("No reviews found"),
          );
        }else{
         return ListView.builder(
           itemCount: controller.reviews.length,
             itemBuilder: (context, index){
           final review = controller.reviews[index];
           return _buildTestimonial(
             imageUrl: review.ownerProfilePicture,
             name: review.ownerName,
             rating: review.rating,
             testimonial: review.review,
           );
         });
        }
      }),
    );
  }

  Widget _buildTestimonial({
    required String imageUrl,
    required String name,
    required double rating,
    required String testimonial,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl: imageUrl,
            height: 50,
            width: 50,
            boxShape: BoxShape.circle,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText2(
                  text: name,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),

                SizedBox(width: 8),

                Row(
                  children: List.generate(
                    rating.toInt(),
                    (index) =>
                        Icon(Icons.star, color: Colors.amber, size: 20.0),
                  ),
                ),
                SizedBox(height: 6),

                CustomText2(
                  text: testimonial,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  color: AppColors.grey_2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
