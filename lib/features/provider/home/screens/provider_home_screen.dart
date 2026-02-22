import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/components/icon_white_circle_background.dart';
import 'package:cleaning_service_app/core/utils/address_from_latlng/address_from_latlng.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/features/bookings/controllers/owner_booking_controller.dart';
import 'package:cleaning_service_app/features/main-layout/controllers/main_layout_controller.dart';
import 'package:cleaning_service_app/features/notification/controllers/notification_controller.dart';
import 'package:cleaning_service_app/features/profile/controllers/profile_controller.dart';
import 'package:cleaning_service_app/features/profile/screens/profile_screen.dart';
import 'package:cleaning_service_app/features/provider/home/controllers/provider_home_controller.dart';
import 'package:cleaning_service_app/features/provider/subscription/screens/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({super.key});

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {
  final notificationController = Get.put(NotificationController());
  final homeController = Get.put(ProviderHomeController());
  final profileController = Get.put(ProfileController());

  final RxString address = 'Loading...'.obs;
  final RxBool isLoadingAddress = true.obs;

  @override
  void initState() {
    super.initState();
    _fetchAddress();

    // Listen to profile changes to update address
    ever(profileController.profile, (_) {
      _fetchAddress();
    });
  }

  void _fetchAddress() async {
    if (profileController.profile.value?.latitude == null ||
        profileController.profile.value?.longitude == null) {
      address.value = 'No location set';
      isLoadingAddress.value = false;
      return;
    }

    isLoadingAddress.value = true;
    try {
      final fetchedAddress = await AddressFromLatLng.getAddressFromLatLng(
        profileController.profile.value!.latitude,
        profileController.profile.value!.longitude,
      );

      if (fetchedAddress != null && fetchedAddress.isNotEmpty) {
        // Extract city/area (text after last comma)
        final parts = fetchedAddress.split(',');
        if (parts.length >= 2) {
          // Show last 2 parts (e.g., "Dhaka, Bangladesh")
          address.value = parts.reversed
              .take(2)
              .toList()
              .reversed
              .join(', ')
              .trim();
        } else {
          address.value = fetchedAddress;
        }
      } else {
        address.value = 'No location set';
      }
    } catch (e) {
      debugPrint('Error fetching address: $e');
      address.value = 'Location unavailable';
    } finally {
      isLoadingAddress.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0EEFF),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(24), // Custom height
      //   child: AppBar(scrolledUnderElevation: 0),
      // ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              homeController.fetchHomepageData(),
              homeController.fetchPendingHomeBookings(),
              notificationController.fetchNotifications(),
              profileController.fetchProfile(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),

                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Pending Bookings Card
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.find<MainLayoutController>().changeTab(1);
                            Get.find<BookingController>().filterServices(1);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 0.5,
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText2(
                                        text: 'Pending Bookings',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),

                                      CustomImage(
                                        imageSrc: AppIcons.current_icon,
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8.0),

                                  Obx(() {
                                    final count = homeController
                                        .homepageData
                                        .value
                                        ?.pendingBookings;
                                    return CustomText2(
                                      text: count?.toString() ?? '--',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    );
                                  }),

                                  SizedBox(height: 8.0),

                                  CustomText2(
                                    text: 'Current Bookings',
                                    fontSize: 8.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.neutral03,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// Earnings Card
                      Expanded(
                        child: InkWell(
                          onTap: () => ProfileScreen().onTapMyBalance(context),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 0.5,
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 18,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText2(
                                        text: 'Earnings',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),

                                      CustomImage(
                                        imageSrc: AppIcons.earning_icon,
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8.0),

                                  CustomText2(
                                    text:
                                        '€${homeController.homepageData.value?.monthlyEarnings ?? '--'}',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),

                                  SizedBox(height: 8.0),

                                  CustomText2(
                                    text: 'This Month',
                                    fontSize: 8.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.neutral03,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// New Messages Card
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // Get.toNamed(AppRoutes.providerInboxScreen);
                            Get.find<MainLayoutController>().changeTab(3);
                          },
                          child: Card(
                            elevation: 0.5,
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText2(
                                        text: 'New Message',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),

                                      CustomImage(imageSrc: AppIcons.message),
                                    ],
                                  ),

                                  SizedBox(height: 8.0),

                                  Obx(() {
                                    final unread = homeController
                                        .homepageData
                                        .value
                                        ?.unreadMessages;
                                    return CustomText2(
                                      text: unread?.toString() ?? '--',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    );
                                  }),

                                  SizedBox(height: 8.0),

                                  CustomText2(
                                    text: 'Unread',
                                    fontSize: 8.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.neutral03,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// Current Plan Card
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // Get.toNamed(AppRoutes.proPlanSubscriptionScreen);
                            Get.to(() => SubscriptionScreen());
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 0.5,
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText2(
                                        text: 'Current Plan',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),

                                      CustomImage(
                                        imageSrc: AppIcons.current_plan,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),

                                  Obx(() {
                                    final plan = homeController
                                        .homepageData
                                        .value
                                        ?.currentPlan;
                                    return CustomText2(
                                      text: plan?.isNotEmpty == true
                                          ? plan!
                                          : '—',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    );
                                  }),

                                  SizedBox(height: 8.0),

                                  Row(
                                    children: [
                                      CustomText2(
                                        text: '',
                                        fontSize: 8.0,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.neutral03,
                                      ),

                                      CustomText2(
                                        text: '',
                                        fontSize: 8.0,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.lightBlue,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText2(
                        text: 'Pending Bookings',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),

                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.bookingsScreen,
                            arguments: [
                              {"status": "Pending"},
                            ],
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CustomText2(
                            text: 'See all',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightBlue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Obx(() {
                    if (homeController.isLoadingPending.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final items = homeController.pendingBookings;
                    if (items.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: CustomText2(
                            text: 'No pending bookings',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.neutral03,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final b = items[index];
                        print("======> image url: ${b.ownerProfilePicture}");
                        return AppointmentCard(
                          name: b.ownerName,
                          time: b.timeAgo,
                          appointment: _formatAppointment(
                            b.bookingDateTime,
                            b.ownerName,
                          ),
                          avatarUrl: b.ownerProfilePicture,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: NavBar(currentIndex: 0),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // location section
          Row(
            children: [
              IconWhiteCircleBackground(
                icon: Assets.icons.locationMarker.svg(),
              ),

              SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText2(
                        text: 'My Location',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),

                      SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.locationScreen);
                        },
                        child: Icon(
                          Icons.edit,
                          size: 14,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),

                  Obx(() {
                    return Skeletonizer(
                      enabled: isLoadingAddress.value,
                      child: CustomText(
                        text: address.value,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 4,
            children: [
              IconWhiteCircleBackground(
                icon: Assets.icons.badge.svg(
                  // colorFilter: ColorFilter.mode(
                  //   // Colors.blue,
                  //   plan == 'PLATINUM'
                  //       ? Color(0xFFE5E4E2)
                  //       : plan == 'GOLD'
                  //       ? Color(0xFF8A5A2B)
                  //       : plan == 'SILVER'
                  //       ? Color(0xFFC0C0C0)
                  //       : Color(0xFF4B3F72),
                  //   BlendMode.srcIn,
                  // ),
                ),
              ),

              CustomText(
                text: homeController.homepageData.value?.currentPlan ?? '',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),

              SizedBox(width: 4),
              IconWhiteCircleBackground(
                icon: Obx(() {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Assets.icons.notificationBell.svg(
                          width: 24,
                          height: 24,
                        ),
                      ),
                      if (notificationController.unreadCount.value > 0)
                        Positioned(
                          right: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF00B046) /* green */,
                              shape: OvalBorder(),
                            ),
                            child: Center(
                              child: Text(
                                '${notificationController.unreadCount.value}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                onTap: () {
                  // showCustomDialog(context);
                  Get.toNamed(AppRoutes.notificationScreen);
                },
              ),
            ],
          ),
        ],
      );
    });
  }
}

String _formatAppointment(DateTime dateTime, String ownerName) {
  // Example: Nov 04, 2025 - 05:30 PM with {ownerName} (Cleaning)
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final m = months[dateTime.month - 1];
  final d = dateTime.day.toString().padLeft(2, '0');
  final y = dateTime.year;
  final hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final min = dateTime.minute.toString().padLeft(2, '0');
  final ampm = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '$m $d, $y - ${hour12.toString().padLeft(2, '0')}:$min $ampm with $ownerName (Cleaning)';
}

class AppointmentCard extends StatelessWidget {
  final String name;
  final String time;
  final String appointment;
  final String avatarUrl;

  const AppointmentCard({
    super.key,
    required this.name,
    required this.time,
    required this.appointment,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: (){
      //   Get.find<MainLayoutController>().changeTab(3);
      // },
      onTap: () {
        Get.toNamed(
          AppRoutes.bookingsScreen,
          arguments: [
            {"status": "Pending"},
          ],
        );
      },
      child: Card(
        elevation: 0.5,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with safe fallback when URL is empty/invalid
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.grey.shade300,
                backgroundImage:
                    (avatarUrl.isNotEmpty &&
                        (avatarUrl.startsWith('http://') ||
                            avatarUrl.startsWith('https://')))
                    ? NetworkImage(avatarUrl)
                    : null,
                child:
                    (avatarUrl.isNotEmpty &&
                        (avatarUrl.startsWith('http://') ||
                            avatarUrl.startsWith('https://')))
                    ? null
                    : Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: name,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),

                        CustomText(
                          text: time,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.neutral03,
                        ),
                      ],
                    ),

                    // const SizedBox(height: 12.0),
                    CustomText(
                      text: appointment,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.neutral03,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
