import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsTabView extends StatelessWidget {
  const DetailsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceDetailsController = Get.find<ServiceDetailsController>();

    return Obx(() {
      final providerDetails = serviceDetailsController.providerDetails.value;

      if (serviceDetailsController.isProviderLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (providerDetails == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Text('No provider details available'),
          ),
        );
      }

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
                    imageUrl: providerDetails.profilePicture,
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
                      boxShadow: const [
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

          const SizedBox(height: 24),

          _buildInfoSection("Name", providerDetails.name),
          const SizedBox(height: 16),
          _buildInfoSection("Address", providerDetails.address),
          const SizedBox(height: 16),
          _buildInfoSection(
            "Experience",
            "${providerDetails.experience} Years",
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'About me',
                  color: Color(0xFF0F0B18),
                  fontSize: 14,
                  fontFamily: FontFamily.lexend,
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
                const SizedBox(height: 8),
                Text(
                  providerDetails.aboutMe,
                  style: const TextStyle(
                    color: Color(0xFF4F4F59),
                    fontSize: 14,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),

          // Chat Icon
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4899D1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Assets.icons.chat.svg(),
          ),
        ],
      );
    });
  }

  Widget _buildInfoSection(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 12,
          color: const Color(0xFF9A9A9A),
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
        const SizedBox(height: 4),
        CustomText(
          text: value,
          fontSize: 14,
          color: const Color(0xFF333333),
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      ],
    );
  }
}
