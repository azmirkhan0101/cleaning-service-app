import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/features/owner/home/owner_controller.dart';
import 'package:cleaning_service_app/features/payment/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerHomeSearchScreen extends StatefulWidget {
  OwnerHomeSearchScreen({super.key});

  @override
  State<OwnerHomeSearchScreen> createState() => _OwnerHomeSearchScreenState();
}

class _OwnerHomeSearchScreenState extends State<OwnerHomeSearchScreen> {
  final ownerController = Get.find<OwnerController>();

  final paymentController = Get.find<PaymentController>();

  int? _selectedExperience;
  bool? _instantBooking;
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchTextField(),

                ///================== Category show =============
                // Row(
                //   mainAxisSize:
                //       MainAxisSize.min, // Ensure Row size is as small as needed
                //   children: [
                //     // First item
                //     Container(
                //       width: 110,
                //       height: 45,
                //       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                //       margin: EdgeInsets.only(bottom: 5),
                //       decoration: BoxDecoration(
                //         color: Colors.blue,
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(color: Colors.grey),
                //       ),
                //       child: Row(
                //         children: [
                //           CustomImage(imageSrc: AppIcons.service_all),
                //           SizedBox(width: 2),
                //           CustomText(
                //             text: "All Service",
                //             fontSize: 12,
                //             fontWeight: FontWeight.w500,
                //             color: AppColors.white,
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(width: 12),
                //     // Second item
                //     Container(
                //       width: 110,
                //       height: 45,
                //       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                //       margin: EdgeInsets.only(bottom: 5),
                //       decoration: BoxDecoration(
                //         color: Colors.transparent,
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(color: Colors.grey),
                //       ),
                //       child: Row(
                //         children: [
                //           CustomImage(imageSrc: AppIcons.cleaning),
                //           SizedBox(width: 2),
                //           CustomText(
                //             text: "Cleaning",
                //             fontSize: 12,
                //             fontWeight: FontWeight.w500,
                //             color: AppColors.black,
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(width: 12),

                //     // Add more items as needed
                //     Container(
                //       width: 110,
                //       height: 45,
                //       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                //       margin: EdgeInsets.only(bottom: 5),
                //       decoration: BoxDecoration(
                //         color: Colors.transparent,
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(color: Colors.grey),
                //       ),
                //       child: Row(
                //         children: [
                //           CustomImage(imageSrc: AppIcons.laundry),
                //           SizedBox(width: 2),
                //           CustomText(
                //             text: "Laundry",
                //             fontSize: 12,
                //             fontWeight: FontWeight.w500,
                //             color: AppColors.black,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.pickerMapScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // pill shape
                      side: const BorderSide(
                        color: Color(0xFF4899D1),
                        width: 1,
                      ), // border
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    elevation: 0, // flat style, remove shadow
                    // minimumSize: Size(50, 50),  // 90% of screen width
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImage(imageSrc: AppIcons.send_icon),

                      SizedBox(width: 8),

                      CustomText(
                        text: 'Use my current location',
                        color: Color(0xFF4899D1),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8),

                const CustomText(
                  text: "Price/hour ",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),

                Slider(
                  value: 5.0, // Initial value
                  min: 5.0, // Minimum value
                  max: 100.0, // Maximum value
                  // divisions: 95,       // Number of discrete steps
                  activeColor: AppColors.lightBlue,
                  onChanged: (double value) {
                    // Handle the slider value change
                    print("Selected distance: $value miles");
                  },
                ),

                SizedBox(height: 12),

                // CustomText(
                //   text: "Select Rating",
                //   fontSize: 16,
                //   fontWeight: FontWeight.w400,
                //   color: AppColors.black,
                // ),

                // SizedBox(height: 10),

                // RatingBar.builder(
                //   initialRating: 5,
                //   minRating: 1,
                //   itemSize: 40,
                //   itemCount: 5,
                //   itemPadding: EdgeInsets.symmetric(horizontal: 2),
                //   itemBuilder: (context, _) =>
                //       Icon(Icons.star, color: Colors.orange),
                //   onRatingUpdate: (rating) {
                //     print('Rating: $rating');
                //   },
                // ),

                // SizedBox(width: 12),

                ///Professional's Experience Section
                _buildSectionHeader("Professional's experience"),
                const SizedBox(height: 16),
                _buildExperienceOptions(),
                const SizedBox(height: 16),

                ///Instant Booking Section
                _buildSectionHeader("Instant Booking"),
                const SizedBox(height: 16),
                _buildInstantBookingOptions(),
                const SizedBox(height: 16),

                ///Gender Section
                _buildSectionHeader("Gender"),
                const SizedBox(height: 16),
                _buildGenderOptions(),

                const SizedBox(height: 16),

                CustomText(
                  text: "Spoken Language",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),

                // Obx(() {
                //   return SizedBox(
                //     height: 60,
                //     child: Card(
                //       color: AppColors.white,
                //       elevation: 0.2,
                //       child: DropdownButton<String>(
                //         value: paymentController.selectedCountry.value.isEmpty
                //             ? null
                //             : paymentController
                //                   .selectedCountry
                //                   .value, // Bind to the GetX value
                //         onChanged: (String? newValue) {
                //           paymentController.selectedCountry.value = newValue!;
                //         },
                //         items: <String>['USA', 'Canada', 'India', 'Australia']
                //             .map<DropdownMenuItem<String>>((String value) {
                //               return DropdownMenuItem<String>(
                //                 value: value,
                //                 enabled: true,
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: Text(value),
                //                 ),
                //               );
                //             })
                //             .toList(),
                //         icon: Icon(
                //           Icons.arrow_drop_down,
                //         ), // Adding the dropdown icon
                //         iconSize: 24, // Adjust the icon size if needed
                //         isExpanded:
                //             true, // Makes the DropdownButton take up all available space
                //       ),
                //     ),
                //   );
                // }),
                SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Assets.icons.arrowDown.svg(),
                    Text(
                      'English',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF0F0B18),
                        fontSize: 16,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // CustomButton(
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     Get.toNamed(AppRoutes.ownerSearchScreen);
                //   },
                //   title: "Apply",
                //   fontSize: 16, // Bigger button text for tablets
                //   width: double.infinity,
                //   height: 50,
                //   fillColor: AppColors.appColors,
                //   borderRadius: 24,
                // ),
                Container(
                  width: double.infinity,
                  height: 46,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE9EBF3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 176,
                        children: [
                          Text(
                            'Clear all',
                            style: TextStyle(
                              color: const Color(0xFF0F0B18),
                              fontSize: 14,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                          Container(
                            width: 90,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF7A51D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x6B4C4E64),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                  spreadRadius: -4,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                    vertical: 7,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Text(
                                        'Show',
                                        style: TextStyle(
                                          color: Colors.white,
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _buildSearchTextField() {
    return TextField(
      // controller: ownerController.searchTextController,
      decoration: InputDecoration(
        hintText: 'Search Your Service',
        hintStyle: TextStyle(
          color: Color(0xFF4F4F59),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(Icons.search, color: Color(0xFF0F0B18)),
        filled: true,
        fillColor: Color(0xFFE9EBF3),
        border: _buildOutlineInputBorder(),
        focusedBorder: _buildOutlineInputBorder(),
        enabledBorder: _buildOutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Search',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF0F0B18),
          fontSize: 24,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w600,
          height: 1.40,
          letterSpacing: -0.50,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Assets.icons.arrowLeft.svg(),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.50, color: const Color(0xFF0D0D0D)),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 4,
            children: [
              Text(
                '14 Sep',
                style: TextStyle(
                  color: const Color(0xFF4F4F59),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              Assets.icons.calanderIcon.svg(),
            ],
          ),
        ),

        SizedBox(width: 16),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildExperienceOptions() {
    final options = [
      "0-1 year of experience",
      "1-5 years of experience",
      "5+ years of experience",
    ];

    return Column(
      children: List.generate(options.length, (index) {
        return Row(
          children: [
            Checkbox(
              value: _selectedExperience == index,
              onChanged: (bool? value) {
                setState(() {
                  _selectedExperience = value == true ? index : null;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // const SizedBox(width: 8),
            CustomText(
              text: options[index],
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInstantBookingOptions() {
    return Row(
      children: [
        Row(
          children: [
            Checkbox(
              value: _instantBooking == true,
              onChanged: (bool? value) {
                setState(() {
                  _instantBooking = value == true ? true : null;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Yes",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),

        const SizedBox(width: 16),

        Row(
          children: [
            Checkbox(
              value: _instantBooking == false,
              onChanged: (bool? value) {
                setState(() {
                  _instantBooking = value == true ? false : null;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(width: 8),
            const Text(
              "No",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOptions() {
    return Row(
      children: [
        Row(
          children: [
            Checkbox(
              value: _selectedGender == "Male",
              onChanged: (bool? value) {
                setState(() {
                  _selectedGender = value == true ? "Male" : null;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Male",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(width: 32),
        Row(
          children: [
            Checkbox(
              value: _selectedGender == "Female",
              onChanged: (bool? value) {
                setState(() {
                  _selectedGender = value == true ? "Female" : null;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Female",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ],
    );
  }
}
