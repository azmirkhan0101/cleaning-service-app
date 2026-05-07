import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_network_image/custom_network_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/helper/extension/base_extensions.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_const/app_const.dart';
import 'package:cleaning_service_app/features/auth/screens/login_screen.dart';
// import 'package:cleaning_service_app/features/provider/profile/earning_screen.dart';
import 'package:cleaning_service_app/features/common/screens/generic_webview_screen.dart';
import 'package:cleaning_service_app/features/common/types/role.dart';
import 'package:cleaning_service_app/features/profile/controllers/profile_controller.dart';
import 'package:cleaning_service_app/features/profile/screens/edit_profile_screen.dart';
import 'package:cleaning_service_app/features/profile/screens/knowledge_hub_screen.dart';
import 'package:cleaning_service_app/features/profile/screens/policy_condition_screen.dart';
import 'package:cleaning_service_app/features/profile/screens/refer_screen.dart';
import 'package:cleaning_service_app/features/provider/subscription/screens/subscription_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/assets-gen/assets.gen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  RxBool isCountryUploading = false.obs;
  final TextEditingController countryController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final profileController = Get.put(ProfileController());
  RxString selectedCountryCode = "".obs;

  @override
  Widget build(BuildContext context) {
    final String? role = AppStorageService.getUserRole();

    return Scaffold(
      appBar: CustomAppBar(title: "Profile"),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: profileController.refreshProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  _buildProfileSection(profileController),

                  // Show Boost Button if provider
                  SizedBox(height: 24.h),
                  if (role != Role.owner.value)
                    FilledButton(
                      onPressed: () {
                        Get.to(const SubscriptionScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7A51D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.2,
                          40,
                        ), // 90% of screen width
                      ),
                      child: CustomText(
                        text: "Boost",
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  8.heightBox,
                  // General Section
                  const Text(
                    'General',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8.h),

                  _buildSettingsList(context, role, profileController),
                ],
              ),
            ),
          ),
        );
      }),
      // bottomNavigationBar: OwnerNavBar(currentIndex: 4),
    );
  }

  // Profile Section with image, name, email, and sign out
  Widget _buildProfileSection(ProfileController profileController) {
    final profile = profileController.profile.value;

    return Row(
      children: [
        ///Profile Image
        CustomNetworkImage(
          imageUrl: profile?.profilePicture ?? AppConstants.profileImage,
          height: 50,
          width: 50,
          boxShape: BoxShape.circle,
        ),

        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText2(
                text: profile?.userName ?? 'Loading...',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              CustomText2(
                text: profile?.email ?? 'Loading...',
                fontSize: 14,
                color: Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Sign Out Button
        TextButton(
          onPressed: () {
            profileController.signOut();
            Get.offAll(LoginScreen());
          },
          child: const Text('Sign out', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  ///List of Settings
  Widget _buildSettingsList(
    BuildContext context,
    String? role,
    ProfileController profileController,
  ) {
    return Column(
      spacing: 16.h,
      children: [
        // Profile Information
        InkWell(
          child: _buildSettingsItem(
            'Profile Information',
            Icons.person_outline,
          ),
          onTap: () {
            Get.to(EditProfileScreen(isOwner: role == Role.owner.value));
          },
        ),
        // My Balance (only for Provider)
         if (role == Role.provider.value)
        Skeletonizer(
          enabled: profileController.isLoadingStripeDashboard.value,
          child: InkWell(
            child: _buildSettingsItem(
              'My Balance Stripe',
              Icons.account_balance_wallet_outlined,
            ),
            onTap: () => onTapMyBalance(context),
          ),
        ),

        //Password Management
        InkWell(
          child: _buildSettingsItem('Password Management', Icons.lock_outline),
          onTap: () {
            Get.toNamed(AppRoutes.changePasswordScreen);
          },
        ),

        // Knowledge Hub (Only for Owner)
        if (role == Role.owner.value)
          InkWell(
            child: _buildSettingsItem('Knowledge Hub', Icons.menu_book_sharp),
            onTap: () {
              // Get.toNamed(AppRoutes.educationHomeScreen);
              Get.to(KnowledgeHubScreen());
            },
          ),

        // About Us
        InkWell(
          child: _buildSettingsItem('About Us', Icons.info_outline),
          onTap: () {
            // Get.toNamed(AppRoutes.aboutUsScreen);
            Get.to(PolicyConditionScreen(title: "About Us"));
          },
        ),

        // Privacy Policy
        InkWell(
          child: _buildSettingsItem(
            'Privacy Policy',
            Icons.privacy_tip_outlined,
          ),
          onTap: () {
            // Get.toNamed(AppRoutes.privacyPolicyScreen);
            Get.to(PolicyConditionScreen(title: "Privacy Policy"));
          },
        ),

        // Terms & Conditions
        InkWell(
          child: _buildSettingsItem(
            'Terms & Conditions',
            Icons.description_outlined,
          ),
          onTap: () {
            // Get.toNamed(AppRoutes.termsConditionScreen);
            Get.to(PolicyConditionScreen(title: "Terms & Conditions"));
          },
        ),

        // Affiliation condition (Only for Provider
        // if (role == Role.provider.value)
        //   InkWell(
        //     child: _buildSettingsItem(
        //       'Affiliation Condition',
        //       Icons.handshake_outlined,
        //     ),
        //     onTap: () {
        //       // Get.toNamed(AppRoutes.affiliationConditionScreen);
        //       Get.to(PolicyConditionScreen(title: "Affiliation Condition"));
        //     },
        //   ),

        // Invite Friend
        // InkWell(
        //   child: _buildSettingsItem('Invite Friend', Icons.people_outline),
        //   onTap: () {
        //     //ReferScreen
        //     // Get.toNamed(AppRoutes.referScreen);
        //     Get.to(ReferScreen());
        //   },
        // ),

        // Delete Account
        InkWell(
          child: _buildSettingsItem('Delete Account', Icons.delete_outline),
          onTap: () {
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
                        Icon(
                          Icons.delete_forever_outlined,
                          size: 90,
                          color: AppColors.red,
                        ),

                        //  CustomImage(imageSrc: AppImages.alertImage),
                        CustomText2(
                          text: "Delete Account",
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),

                        SizedBox(height: 8),

                        CustomText(
                          text: "Are you sure you want to delete?",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey_2,
                        ),

                        SizedBox(height: 8),

                        CustomButton(
                          onTap: () {
                            // Get.offAll(LoginScreen());
                            Navigator.of(context).pop();
                          },
                          title: "Delete Account feature coming soon",
                          height: 45,
                          fontSize: 12,
                          // fillColor: AppColors.appColors,
                          fillColor: AppColors.grey_3,
                        ),

                        SizedBox(height: 12),

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
                        ),
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
  Widget _buildSettingsItem(String title, IconData icon, {Widget? iconWidget}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFE9EBF3)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          if (iconWidget != null)
            iconWidget
          else
            Icon(icon, color: Colors.blue, size: 24),
          SizedBox(width: 8.w),
          CustomText(
            text: title,
            color: const Color(0xFF0F0B18),
            fontSize: 14,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
        ],
      ),
    );
  }

  void onTapMyBalance(BuildContext context) async {
    final profileCtrl = Get.find<ProfileController>();
    String? url = await profileCtrl.fetchStripeDashboardUrl();
    if (url == null || url.isEmpty) {
      showCountryDialog();
    }else{
      if (context.mounted) {
        Get.to(
              () => GenericWebViewScreen(
            title: 'Stripe Dashboard',
            url: url,
            isDashboard: true,
          ),
        );
      }
    }
  }



  //COUNTRY INPUT DIALOG FOR STRIPE CONNECTION
  void showCountryDialog() {
    // Reset selection when opening dialog
    selectedCountryCode.value = "";

    Get.dialog(
      Obx(() => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Connect to Stripe"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your account is not connected to Stripe.\n"
                    "To connect, please select your country.",
              ),
              const SizedBox(height: 20),

              // Searchable Dropdown
              DropdownSearch<String>(
                items: (filter, infiniteScrollProps) => countryMap.keys.toList(),
                // Display name instead of code in the list
                itemAsString: (String code) => countryMap[code] ?? code,
                onChanged: (String? code){
                  selectedCountryCode.value = code ?? "";
                  print("Selected Country: ${selectedCountryCode.value}");
                },
                // onSaved: (String? code) {
                // },
                // Validation
                validator: (value) => (value == null || value.isEmpty)
                    ? "Please select a country"
                    : null,
                decoratorProps: const DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: "Select Country",
                    hintText: "Search country...",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                ),
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Search country...",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Changed for visibility, customize as needed
              foregroundColor: Colors.white,
            ),
            onPressed: isCountryUploading.value
                ? null
                : () async {
              if (!formKey.currentState!.validate()) return;

              print("Country code: ${selectedCountryCode.value}");

              isCountryUploading.value = true;
              try {
                // Use the selected country code directly from the Rx variable
                bool success = await profileController.uploadCountry(
                  country: selectedCountryCode.value,
                );

                if (success) {
                  String? url = await profileController.createStripeOnboardingLink();
                  if (url == null || url.isEmpty) {
                    Toast.errorToast('Unable to open Stripe link');
                  } else {
                    Get.back(); // Close dialog before navigating
                    Get.to(() => GenericWebViewScreen(title: 'Stripe Onboarding', url: url));
                  }
                } else {
                  Toast.errorToast("Country upload failed!");
                }
              } catch (e) {
                Toast.errorToast("Something went wrong. Try again.");
              } finally {
                isCountryUploading.value = false;
              }
            },
            child: isCountryUploading.value
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
                : const Text("Submit"),
          ),
        ],
      )),
      barrierDismissible: false,
    );
  }

  // Map of codes to names for display purposes
  final Map<String, String> countryMap = {
    "US": "United States", "GB": "United Kingdom", "FR": "France", "DE": "Germany",
    "IT": "Italy", "ES": "Spain", "NL": "Netherlands", "BE": "Belgium",
    "AT": "Austria", "CH": "Switzerland", "SE": "Sweden", "NO": "Norway",
    "DK": "Denmark", "FI": "Finland", "IE": "Ireland", "CZ": "Czech Republic",
    "SK": "Slovakia", "HU": "Hungary", "RO": "Romania", "BG": "Bulgaria",
    "HR": "Croatia", "SI": "Slovenia", "LT": "Lithuania", "LV": "Latvia",
    "EE": "Estonia", "MT": "Malta", "CY": "Cyprus", "GR": "Greece",
    "PT": "Portugal", "LU": "Luxembourg", "AU": "Australia", "JP": "Japan",
    "SG": "Singapore", "HK": "Hong Kong", "CA": "Canada", "MX": "Mexico",
    "BR": "Brazil", "IN": "India", "TH": "Thailand", "MY": "Malaysia",
    "NZ": "New Zealand", "PH": "Philippines", "ID": "Indonesia", "VN": "Vietnam",
    "AE": "United Arab Emirates", "SA": "Saudi Arabia", "PK": "Pakistan"
  };
}
