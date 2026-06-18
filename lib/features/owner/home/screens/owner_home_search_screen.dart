import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:cleaning_service_app/features/location/widgets/location_search_widget.dart';
import 'package:cleaning_service_app/features/owner/home/controllers/owner_controller.dart';
import 'package:cleaning_service_app/features/owner/home/controllers/search_controller.dart'
    as search;
import 'package:cleaning_service_app/features/owner/service/controllers/category_controller.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/owner_service_controller.dart';
import 'package:cleaning_service_app/features/owner/service/models/search_filter_model.dart';
import 'package:cleaning_service_app/features/owner/service/screens/search_results_screen.dart';
import 'package:cleaning_service_app/features/payment/controllers/payment_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  final categoryController = Get.find<CategoryController>();
  final searchController = Get.put(search.SearchController());

  @override
  void dispose() {
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
                    _buildCategorySearchTextField(),
                    SizedBox(height: 16),
                    //_buildTitleSection("Date & Time"),
                    //_buildDataTimeSection(),
                    //SizedBox(height: 24),

                    /// Searchable Address Field
                    LocationSearchWidget(
                      //controller: locationController,
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
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImage(imageSrc: AppIcons.send_icon),

                          SizedBox(width: 8),

                          CustomText2(
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
                        const CustomText2(
                          text: "Price/hour ",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F0B18),
                        ),
                        Obx(
                          () => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF4899D1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '€${searchController.pricePerHour.value.toInt()}/h',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Obx(
                      () => SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: Color(0xFF4899D1),
                          inactiveTrackColor: Color(0xFFE0E0E0),
                          thumbColor: Colors.white,
                          overlayColor: Color(
                            0xFF4899D1,
                          ).withValues(alpha: 0.2),
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
                          value: searchController.pricePerHour.value,
                          min: 5.0,
                          max: 100.0,
                          divisions: 95,
                          onChanged: (double value) =>
                              searchController.setPricePerHour(value),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    ///Professional's Experience Section
                    _buildSectionHeader("Professional's experience"),
                    const SizedBox(height: 16),
                    _buildExperienceOptions(),
                    const SizedBox(height: 16),
                    ///Instant Booking Section
                    _buildSectionHeader("Instant Booking"),
                    _buildInstantBookingOptions(),
                    ///Gender Section
                    _buildSectionHeader("Gender"),
                    _buildGenderOptions(),

                    const SizedBox(height: 16),

                    _buildSectionHeader("Spoken Language"),

                    Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          value: searchController.selectedLanguage.value,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              searchController.setLanguage(newValue);
                            }
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
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final searchController =
                                  Get.find<search.SearchController>();
                              searchController.clearAllFilters();
                            },
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9EBF3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: const Text(
                                'Clear all',
                                style: TextStyle(
                                  color: Color(0xFF0F0B18),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Lexend',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        /// Show Button
                        SizedBox(
                          height: 44,
                          child: Obx(() {
                            return Skeletonizer(
                              enabled: searchController.isSearching.value,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final searchController =
                                      Get.find<search.SearchController>();
                                  await searchController.searchServices();
                                  //RESET SORT FILTER VALUES
                                  searchController.resetSortFilterValues();
                                  // Get applied filters and ensure category name is set
                                  final filters =
                                      searchController.appliedFilters.value;
                                  AppliedFilters? updatedFilters;

                                  if (filters != null) {
                                    // If categoryName is empty but we have a selected service, use it
                                    final categoryName =
                                        filters.categoryName?.isEmpty ?? true
                                        ? searchController
                                                  .selectedService
                                                  .value
                                                  .isNotEmpty
                                              ? searchController
                                                    .selectedService
                                                    .value
                                              : null
                                        : filters.categoryName;

                                    updatedFilters = AppliedFilters(
                                      search: filters.search,
                                      categoryId: filters.categoryId,
                                      categoryName: categoryName,
                                      date: filters.date,
                                      time: filters.time,
                                      location: filters.location,
                                      priceRange: filters.priceRange,
                                      experience: filters.experience,
                                      instantBooking: filters.instantBooking,
                                      gender: filters.gender,
                                      language: filters.language,
                                    );
                                  }

                                  // Always navigate to results screen, even if empty
                                  // (to show nearby services fallback)
                                  Get.to(
                                    SearchResultsScreen(
                                      //services: searchController.searchResults,
                                      totalResults:
                                          searchController.totalResults.value,
                                      appliedFilters: updatedFilters,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF7A51D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                  ),
                                ),
                                child: const Text(
                                  'Show',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Lexend',
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
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

  Widget _buildCategorySearchTextField() {
    return Obx(() {
      return Column(
        children: [
          TextField(
            controller: searchController.searchTextController,
            onTap: () => searchController.openSuggestions(),
            onChanged: (value) {
              searchController.onSearchCategoryChanged(value);
              if (value.isNotEmpty) {
                if ( !searchController.showDropDownList.value ) {
                  searchController.showDropDownList.value = true;
                }
              }else{
                if (searchController.showDropDownList.value) {
                  searchController.showDropDownList.value = false;
                }
              }
            },
            decoration: InputDecoration(
              hintText: 'Search Category',
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
                //child: Assets.icons.arrowDown.svg(width: 12, height: 12),
                child: GestureDetector(
                  onTap: () {
                    searchController.showDropDownList.value =
                        !searchController.showDropDownList.value;
                  },
                  //child: searchController.showDropDownList.value ? Assets.icons.arrowLeft.svg(width: 12, height: 12) : Assets.icons.arrowDown.svg(width: 12, height: 12),
                  child: searchController.showDropDownList.value
                      ? Icon(
                          Icons.keyboard_arrow_up,
                          weight: 600,
                          size: 30.r,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.keyboard_arrow_down,
                          weight: 600,
                          size: 30.r,
                          color: Colors.black,
                        ),
                  //child: searchController.showDropDownList.value ? Image.asset("assets/icons/arrow_up.png") : Assets.icons.arrowDown.svg(width: 12, height: 12),
                ),
              ),
              filled: true,
              fillColor: Color(0xFFE9EBF3),
              border: _buildOutlineInputBorder(),
              focusedBorder: _buildOutlineInputBorder(),
              enabledBorder: _buildOutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
          if (searchController.showSuggestions.value &&
              searchController.filteredServices.isNotEmpty)
            Obx((){
              if( !searchController.showDropDownList.value ){
                return SizedBox.shrink();
              }
              return Container(
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
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: searchController.filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = searchController.filteredServices[index];
                      final isSelected =
                          searchController.selectedService.value ==
                              service['label'];

                      return InkWell(
                        onTap: () => searchController.selectService(service),
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom:
                            index ==
                                searchController.filteredServices.length - 1
                                ? 0
                                : 8,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFF4899D1) : Colors.white,
                            border: Border.all(
                              color: Color(0xFF4F4F59),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              // Display image based on type (SVG or Network)
                              if (service['isSvg'] == true)
                                CustomImage(
                                  imageSrc: service['icon'] as String,
                                  imageType: ImageType.svg,
                                  height: 20,
                                  width: 20,
                                  imageColor: isSelected ? Colors.white : null,
                                )
                              else
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    service['icon'] as String,
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.cover,
                                    color: isSelected ? Colors.white : null,
                                    colorBlendMode: isSelected
                                        ? BlendMode.srcIn
                                        : null,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback to a default icon on error
                                      return Icon(
                                        Icons.category,
                                        size: 20,
                                        color: isSelected
                                            ? Colors.white
                                            : Color(0xFF0F0B18),
                                      );
                                    },
                                  ),
                                ),
                              SizedBox(width: 8),
                              Text(
                                service['label'] as String,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Color(0xFF0F0B18),
                                  fontSize: 14,
                                  fontWeight: isSelected
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
                  )
              );
            })
        ],
      );
    });
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
            // Before navigating back, close any open snackbar safely
            try {
              Get.closeCurrentSnackbar();
            } catch (_) {}
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

    return Obx(
      () => Column(
        children: List.generate(options.length, (index) {
          return Row(
            children: [
              Checkbox(
                value: searchController.selectedExperience.value == index,
                onChanged: (bool? value) => searchController.setExperience(
                  value == true ? index : null,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              CustomText2(
                text: options[index],
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInstantBookingOptions() {
    return Obx(
      () => Row(
        children: [
          Row(
            children: [
              Checkbox(
                value: searchController.instantBooking.value == true,
                onChanged: (bool? value) => searchController.setInstantBooking(
                  value == true ? true : null,
                ),
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
                value: searchController.instantBooking.value == false,
                onChanged: (bool? value) => searchController.setInstantBooking(
                  value == true ? false : null,
                ),
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
      ),
    );
  }

  Widget _buildGenderOptions() {
    return Obx(
      () => Row(
        children: [
          Row(
            children: [
              Checkbox(
                value: searchController.selectedGender.value == "Male",
                onChanged: (bool? value) =>
                    searchController.setGender(value == true ? "Male" : null),
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
                value: searchController.selectedGender.value == "Female",
                onChanged: (bool? value) =>
                    searchController.setGender(value == true ? "Female" : null),
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
      ),
    );
  }

}
