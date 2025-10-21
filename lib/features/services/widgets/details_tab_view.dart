import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_netwrok_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';

class DetailsTabView extends StatelessWidget {
  const DetailsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Profile Image
        Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomNetworkImage(
                  imageUrl: AppConstants.profileImage,
                  height: 102,
                  width: 102,
                  boxShape: BoxShape.circle,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Assets.icons.badge.svg(),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24),

        _buildInfoSection("Name", "Jorge Bond"),
        const SizedBox(height: 16),
        _buildInfoSection("Phone Number", "01840-560614"),
        const SizedBox(height: 16),
        _buildInfoSection("Email", "jorgebong@gmail.com"),
        const SizedBox(height: 16),
        _buildInfoSection("Address", "Los Angeles, California"),
        const SizedBox(height: 16),
        _buildInfoSection("Experience", "2 Years"),
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

        // Chat Icon
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF4899D1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Assets.icons.chat.svg(),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          color: const Color(0xFF0F0B18),
          fontSize: 14,
          fontFamily: FontFamily.lexend,
          fontWeight: FontWeight.w600,
          height: 1.50,
        ),

        CustomText(
          text: value,
          color: const Color(0xFF4F4F59),
          fontSize: 14,
          fontFamily: FontFamily.lexend,
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      ],
    );
  }
}
