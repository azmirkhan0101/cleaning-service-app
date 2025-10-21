import 'package:cleaning_service_app/core/components/custom_netwrok_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';

class DetailsTabView extends StatelessWidget {
  const DetailsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Profile Image
        CustomNetworkImage(
          imageUrl: AppConstants.profileImage,
          height: 120,
          width: 120,
          boxShape: BoxShape.circle,
        ),

        SizedBox(height: 24),

        Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Name',
                color: const Color(0xFF0F0B18),
                fontSize: 14,
                fontFamily: FontFamily.lexend,
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),

              CustomText(
                text: 'Jorge Bond',
                color: const Color(0xFF4F4F59),
                fontSize: 14,
                fontFamily: FontFamily.lexend,
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Address',
                color: const Color(0xFF0F0B18),
                fontSize: 14,
                fontFamily: FontFamily.lexend,
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),

              CustomText(
                text: 'Los Angeles, California',
                color: const Color(0xFF4F4F59),
                fontSize: 14,
                fontFamily: FontFamily.lexend,
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Experience',
                color: const Color(0xFF0F0B18),
                fontSize: 14,
                fontFamily: FontFamily.lexend,
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),

              CustomText(
                text: '2 Years',
                color: const Color(0xFF4F4F59),
                fontSize: 14,
                fontFamily: FontFamily.lexend,
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'About me',
                color: const Color(0xFF0F0B18),
                fontSize: 14,
                fontFamily: FontFamily.lexend,
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),

              /* CustomText(text: 'Hello! I’m a dedicated cleaning service provider with a  passion for creating spotless,comfortable, and healthy spaces.',
                                fontSize: 14, color: AppColors.neutral03,maxLines: 2,textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
*/
              SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text:
                      'Hello! I’m a dedicated cleaning service provider with a  passion for creating spotless,comfortable, and healthy spaces.',
                  style: TextStyle(
                    color: const Color(0xFF4F4F59),
                    fontSize: 14,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                  children: [
                    TextSpan(
                      text: ' Read More',
                      style: TextStyle(
                        color: const Color(0xFF4899D1),
                        fontSize: 14,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
