import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/features/common/widgets/time_picker_widget.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:cleaning_service_app/features/location/widgets/location_search_widget.dart';
import 'package:cleaning_service_app/features/owner/home/owner_controller.dart';
import 'package:cleaning_service_app/features/owner/service/owner_service_controller.dart';
import 'package:cleaning_service_app/features/payment/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class OwnerHomeSearchScreen extends StatefulWidget {
  const OwnerHomeSearchScreen({super.key});

  @override
  State<OwnerHomeSearchScreen> createState() => _OwnerHomeSearchScreenState();
}

class _OwnerHomeSearchScreenState extends State<OwnerHomeSearchScreen> {
  final locationController = Get.find<LocationController>();
  final ownerController = Get.find<OwnerController>();

  final paymentController = Get.find<PaymentController>();
  final ownerServiceController = Get.find<OwnerServiceController>();

  int? _selectedExperience;
  bool? _instantBooking;
  String? _selectedGender;
  String? _selectedService;
  DateTime _selectedDate = DateTime.now();
  double _pricePerHour = 20.0;
  final TextEditingController _searchController = TextEditingController();
  bool _showSuggestions = false;
  List<Map<String, dynamic>> _filteredServices = [];
  String _selectedLanguage = 'English';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildScreenBackgroundImage(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 32.0,
                top: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppBar(),
                    SizedBox(height: 16.h),
                    _buildSearchTextField(),
                    SizedBox(height: 16),
                    _buildTitleSection("Date & Time"),
                    _buildDataTimeSection(),
                    SizedBox(height: 24),

                    /// Searchable Address Field
                    LocationSearchWidget(
                      controller: locationController,
                      hintText: "Search for your address...",
                      showLabel: true,
                      labelText: "Enter your address",
                    ),
                    SizedBox(height: 12),

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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: "Price/hour ",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F0B18),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF4899D1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '\$${_pricePerHour.toInt()}h',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: Color(0xFF4899D1),
                        inactiveTrackColor: Color(0xFFE0E0E0),
                        thumbColor: Colors.white,
                        overlayColor: Color(0xFF4899D1).withValues(alpha: 0.2),
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 10,
                          elevation: 2,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 20,
                        ),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: _pricePerHour,
                        min: 5.0,
                        max: 100.0,
                        divisions: 95,
                        onChanged: (double value) {
                          setState(() {
                            _pricePerHour = value;
                          });
                        },
                      ),
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
                    // 12.h.heightBox,
                    _buildInstantBookingOptions(),
                    // const SizedBox(height: 16),

                    ///Gender Section
                    _buildSectionHeader("Gender"),
                    // const SizedBox(height: 16),
                    _buildGenderOptions(),

                    const SizedBox(height: 16),
                    // CustomText(
                    //   text: "Spoken Language",
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.w700,
                    //   color: AppColors.black,
                    // ),
                    _buildSectionHeader("Spoken Language"),

                    // SizedBox(height: 12),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        value: _selectedLanguage,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLanguage = newValue!;
                          });
                        },
                        items:
                            <String>[
                              'English',
                              'Spanish',
                              'French',
                              'German',
                              'Chinese',
                              'Arabic',
                              'Hindi',
                              'Portuguese',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: const Color(0xFF0F0B18),
                                    fontSize: 16,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                              );
                            }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return <String>[
                            'English',
                            'Spanish',
                            'French',
                            'German',
                            'Chinese',
                            'Arabic',
                            'Hindi',
                            'Portuguese',
                          ].map<Widget>((String value) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Assets.icons.arrowDown.svg(),
                                SizedBox(width: 12),
                                Text(
                                  value,
                                  style: TextStyle(
                                    color: const Color(0xFF0F0B18),
                                    fontSize: 16,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 40,
                          padding: EdgeInsets.zero,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          elevation: 4,
                          offset: Offset(0, 0),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        iconStyleData: IconStyleData(
                          icon: SizedBox.shrink(),
                          iconSize: 0,
                        ),
                      ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
        ],
      ),
    );
  }

  GestureDetector _buildDataTimeSection() {
    return GestureDetector(
      onTap: () => _openBottomSheet(context),
      child: Row(
        spacing: 8,
        children: [
          Assets.icons.clock.svg(),

          Obx(() {
            // Get time from controller if available
            final time = ownerServiceController.selectedTime.value;
            String timeStr;

            if (time != null) {
              // Convert 24-hour format to 12-hour with AM/PM
              final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
              final minute = time.minute.toString().padLeft(2, '0');
              final period = time.period == DayPeriod.am ? 'AM' : 'PM';
              timeStr = '$hour:$minute $period';
            } else {
              timeStr = DateFormat('hh:mm a').format(_selectedDate);
            }

            final dateStr = DateFormat('EEE, dd MMM').format(_selectedDate);

            return _buildTitleSection('$timeStr, $dateStr');
          }),

          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          //   decoration: ShapeDecoration(
          //     shape: RoundedRectangleBorder(
          //       side: BorderSide(width: 0.50, color: const Color(0xFF0D0D0D)),
          //       borderRadius: BorderRadius.circular(2),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     spacing: 4,
          //     children: [
          //       Text(
          //         DateFormat('dd MMM').format(_selectedDate),
          //         style: TextStyle(
          //           color: const Color(0xFF4F4F59),
          //           fontSize: 10,
          //           fontFamily: 'Poppins',
          //           fontWeight: FontWeight.w400,
          //           height: 1.50,
          //         ),
          //       ),
          //       Assets.icons.calanderIcon.svg(),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: const Color(0xFF0F0B18),
        fontSize: 16,
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w600,
        height: 1.50,
      ),
    );
  }

  Widget _buildScreenBackgroundImage() {
    return Positioned(
      top: 0,
      left: 0,
      right: -40,
      bottom: -60,
      child: Image.asset(Assets.images.onboardingBg.path, fit: BoxFit.cover),
    );
  }

  Widget _buildSearchTextField() {
    final List<Map<String, dynamic>> serviceOptions = [
      {'icon': AppIcons.service_all, 'label': 'All Service', 'isSvg': true},
      {'icon': AppIcons.cleaning, 'label': 'Cleaning', 'isSvg': true},
      {'icon': AppIcons.laundry, 'label': 'Laundry', 'isSvg': true},
      {'icon': AppIcons.working, 'label': 'Handyman', 'isSvg': true},
      {'icon': AppIcons.industry, 'label': 'Electrical', 'isSvg': true},
    ];

    return Column(
      children: [
        TextField(
          controller: _searchController,
          onTap: () {
            setState(() {
              _showSuggestions = true;
              _filteredServices = serviceOptions;
            });
          },
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _showSuggestions = true;
                _filteredServices = serviceOptions;
              } else {
                _showSuggestions = true;
                _filteredServices = serviceOptions
                    .where(
                      (service) => service['label']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()),
                    )
                    .toList();
              }
            });
          },
          decoration: InputDecoration(
            hintText: 'Search Your Service',
            hintStyle: TextStyle(
              color: Color(0xFF4F4F59),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.search, color: Color(0xFF0F0B18)),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Assets.icons.arrowDown.svg(width: 12, height: 12),
            ),
            filled: true,
            fillColor: Color(0xFFE9EBF3),
            border: _buildOutlineInputBorder(),
            focusedBorder: _buildOutlineInputBorder(),
            enabledBorder: _buildOutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          ),
        ),
        if (_showSuggestions && _filteredServices.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF4F4F59), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              itemCount: _filteredServices.length,
              itemBuilder: (context, index) {
                final service = _filteredServices[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _searchController.text = service['label'];
                      _selectedService = service['label'];
                      _showSuggestions = false;
                      _filteredServices = [];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: index == _filteredServices.length - 1 ? 0 : 8,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedService == service['label']
                          ? Color(0xFF4899D1)
                          : Colors.white,
                      border: Border.all(color: Color(0xFF4F4F59), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomImage(
                          imageSrc: service['icon'] as String,
                          imageType: ImageType.svg,
                          height: 20,
                          width: 20,
                          imageColor: _selectedService == service['label']
                              ? Colors.white
                              : null,
                        ),
                        SizedBox(width: 8),
                        Text(
                          service['label'] as String,
                          style: TextStyle(
                            color: _selectedService == service['label']
                                ? Colors.white
                                : Color(0xFF0F0B18),
                            fontSize: 14,
                            fontWeight: _selectedService == service['label']
                                ? FontWeight.w500
                                : FontWeight.w400,
                            fontFamily: 'Lexend',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Assets.icons.arrowLeft.svg(),
        ),
        Text(
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
        SizedBox(width: 48), // Placeholder for alignment
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

  Future<void> _showCalendarPicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF4899D1), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Color(0xFF0D0D0D), // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF4899D1), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // fullscreen feel
      isDismissible: false, // Prevent tap outside dismiss
      enableDrag: false, // Prevent drag down dismiss
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DefaultTabController(
          length: 2,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 32),
                        onPressed: () {
                          Navigator.pop(context); // close bottom sheet
                        },
                      ),
                    ),
                  ],
                ),

                /// ---------- Custom Segmented Tab ----------
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black54,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: "Date"),
                      Tab(text: "Time"),
                    ],
                  ),
                ),

                /// ---------- Tab Content ----------
                Expanded(
                  child: TabBarView(
                    children: [
                      /// ---------- Date Picker ----------
                      Obx(() {
                        return CalendarDatePicker2(
                          config: CalendarDatePicker2Config(
                            calendarType: CalendarDatePicker2Type.single,
                          ),
                          value:
                              ownerServiceController.selectedDate.value == null
                              ? []
                              : [ownerServiceController.selectedDate.value!],
                          onValueChanged: (dates) {
                            if (dates.isNotEmpty) {
                              ownerServiceController.setDate(dates.first);
                            }
                          },
                        );
                      }),

                      /// ---------- Time Picker ----------
                      TimePickerWidget(),
                    ],
                  ),
                ),

                /// ---------- Confirm Button ----------
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: () {
                      // Update local _selectedDate when user confirms
                      if (ownerServiceController.selectedDate.value != null) {
                        setState(() {
                          _selectedDate =
                              ownerServiceController.selectedDate.value!;
                        });
                      }

                      Navigator.pop(context);

                      final date = ownerServiceController.selectedDate.value;
                      final time = ownerServiceController.selectedTime.value;
                      Get.snackbar(
                        "Selection",
                        "Date: ${date ?? "Not set"}\nTime: ${time?.format(context) ?? "Not set"}",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Text("Confirm"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
