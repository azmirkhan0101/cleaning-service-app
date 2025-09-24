import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_netwrok_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/nav_bar/owner_nav_bar.dart';
import 'package:cleaning_service_app/core/components/nav_bar/provider_nav_bar.dart' show NavBar;
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final storage = GetStorage();

    return Scaffold(
      appBar: CustomAppbar(titleName: "Profile",),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Profile Section
            _buildProfileSection(),

            const SizedBox(height: 16),

            // General Section
            const Text('General', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),

            _buildSettingsList(context),
          ],
        ),
      ),
       bottomNavigationBar: OwnerNavBar(currentIndex: 4),
    );
  }

  // Profile Section with image, name, email, and sign out
  Widget _buildProfileSection() {
    return Row(
      children: [

        ///Profile Image

        CustomNetworkImage(
          imageUrl: AppConstants.profileImage,
          height: 50,
          width: 50,
          boxShape: BoxShape.circle,
        ),


        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CustomText(text: 'Mehedi Hasan ', fontWeight: FontWeight.bold, fontSize: 16),
            CustomText(text: 'jorgebong@gmail.com', fontSize: 14, color: Colors.grey),
          ],
        ),

        const Spacer(),

        // Sign Out Button
        TextButton(
          onPressed: () {

            Get.offNamed(AppRoutes.loginScreen);
          },
          child: const Text('Sign out', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }


  ///List of Settings
  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [

        InkWell(child: _buildSettingsItem('Profile Information', Icons.person),
        onTap: (){
          Get.toNamed(AppRoutes.editPersonProfileScreen);
        },
        ),


        InkWell(child: _buildSettingsItem('Password Management', Icons.lock),
        onTap: (){
          Get.toNamed(AppRoutes.changePasswordScreen);
        },
        ),

        InkWell(child: _buildSettingsItem('Knowledge Hub', Icons.account_balance_wallet),
          onTap: (){
            Get.toNamed(AppRoutes.educationHomeScreen);
          },
        ),

        InkWell(child: _buildSettingsItem('About Us', Icons.info),
          onTap: (){

            Get.toNamed(AppRoutes.aboutUsScreen);
          },
        ),

        InkWell(child: _buildSettingsItem('Privacy Policy', Icons.privacy_tip),onTap: (){

          Get.toNamed(AppRoutes.privacyPolicyScreen);
        },),

        InkWell(child: _buildSettingsItem('Terms & Conditions', Icons.description),
         onTap: (){
           Get.toNamed(AppRoutes.termsConditionScreen);
         },
        ),

        InkWell(child: _buildSettingsItem('Invite Friend', Icons.person_add),
         onTap: (){
          //ReferScreen
           Get.toNamed(AppRoutes.referScreen);
         },
        ),
        InkWell(child: _buildSettingsItem('Delete Account', Icons.delete),
         onTap: (){

           showDialog(
             context: context,
             builder: (ctx) => AlertDialog(
               backgroundColor: Colors.white,
               insetPadding: EdgeInsets.all(8),
               contentPadding: EdgeInsets.all(8),
               title: SizedBox(),
               content: SizedBox(
                 width: MediaQuery.sizeOf(context).width,
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [

                       Icon(Icons.delete_forever_outlined,size: 90,color: AppColors.red,),

                       //  CustomImage(imageSrc: AppImages.alertImage),

                       CustomText(text: "Delete Account",
                         fontSize: 22,
                         fontWeight: FontWeight.w600,
                         color:AppColors.black,
                       ),

                       SizedBox(
                         height: 8,
                       ),

                       CustomText(text: "Are you sure you want to delete ?",
                         fontSize: 16,
                         fontWeight: FontWeight.w400,
                         color:AppColors.grey_2,
                       ),

                       SizedBox(
                         height: 8,
                       ),

                       CustomButton(
                           onTap: () {
                             Navigator.of(context).pop();

                           },
                           title: "Yes",
                           height: 45,
                           fontSize: 12,
                           fillColor: AppColors.appColors),

                       SizedBox(
                         height: 12,
                       ),

                       CustomButton(
                         onTap: () {
                           Navigator.of(context).pop();
                         },
                         title: "NO",
                         height: 45,
                         fontSize: 12,
                         fillColor: AppColors.white,
                         textColor: AppColors.brinkPink,
                         isBorder: true,
                         borderWidth: 1,
                       )
                     ],
                   ),
                 ),
               ),
             ),
           );
         },
        ),
      ],
    );
  }

  // Settings Item with Icon, Text, and Arrow
  Widget _buildSettingsItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title,),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),

    );
  }
}
