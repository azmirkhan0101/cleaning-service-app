import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/common/widgets/time_picker_widget.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart' as phone_countries;
import 'package:intl_phone_field/intl_phone_field.dart';

class ServiceBookingStepOne extends StatefulWidget {
  const ServiceBookingStepOne({
    super.key,
    required this.serviceBookingController,
  });

  final ServiceBookingController serviceBookingController;

  @override
  State<ServiceBookingStepOne> createState() => _ServiceBookingStepOneState();
}

class _ServiceBookingStepOneState extends State<ServiceBookingStepOne> {
  late final TextEditingController _localPhoneController;
  late String _isoCode;
  bool _adjusting = false;

  @override
  void initState() {
    super.initState();
    _localPhoneController = TextEditingController();
    _isoCode = Get.deviceLocale?.countryCode ?? 'US';
    _localPhoneController.addListener(_onLocalNumberChanged);
  }

  @override
  void dispose() {
    _localPhoneController.removeListener(_onLocalNumberChanged);
    _localPhoneController.dispose();
    super.dispose();
  }

  void _onLocalNumberChanged() {
    if (_adjusting) return;
    final text = _localPhoneController.text;
    if (text.startsWith('+')) {
      final match = RegExp(r'^\+(\d{1,4})').firstMatch(text);
      if (match != null) {
        final digits = match.group(1)!;
        final dialWithPlus = '+$digits';
        final matches = phone_countries.countries.where((c) {
          final cd = c.dialCode;
          return cd == digits || cd == dialWithPlus;
        }).toList();
        if (matches.isNotEmpty) {
          final country = matches.first;
          final iso = country.code;
          if (iso != _isoCode && iso.isNotEmpty) {
            setState(() {
              _isoCode = iso;
            });
          }
          final withoutDial = text.substring(match.group(0)!.length);
          _adjusting = true;
          _localPhoneController.text = withoutDial;
          _localPhoneController.selection = TextSelection.collapsed(
            offset: _localPhoneController.text.length,
          );
          _adjusting = false;
          // Update E.164 in controller using new iso/dial code
          final e164 =
              '${country.dialCode.startsWith('+') ? country.dialCode : '+${country.dialCode}'}$withoutDial';
          widget.serviceBookingController.phoneNumberController.text = e164;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text: "Enter Your Information",
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
        ),

        SizedBox(height: 24),
        CustomFormCard(
          title: "Date And Time",
          hintText: "Enter date and time",
          hasBackgroundColor: true,
          prefixIcon: Icon(Icons.calendar_month),
          controller: widget.serviceBookingController.dateTimeController,
          readOnly: true,
          onTap: () async {
            _openBottomSheet(context);
          },
        ),

        SizedBox(height: 12),

        /// Service Duration Field (hours)
        CustomFormCard(
          title: "Service Duration (hours)",
          hintText: "e.g. 2",
          hasBackgroundColor: true,
          prefixIcon: Icon(Icons.timer_outlined),
          controller: widget.serviceBookingController.durationController,
          keyboardType: TextInputType.number,
        ),

        /// Phone Number Field with country picker & validation
        Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text: "Phone Number",
            color: const Color(0xFF0F0B18),
            fontSize: 16,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w600,
            height: 1.50,
          ),
        ),
        const SizedBox(height: 4),
        IntlPhoneField(
          key: ValueKey(_isoCode),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          invalidNumberMessage: 'Invalid phone number',
          initialCountryCode: _isoCode,
          decoration: InputDecoration(
            hintText: 'e.g. 1XXXXXXXXX',
            prefixIcon: const Icon(Icons.phone),
            filled: true,
            fillColor: const Color(0xFFE9EBF3),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
          ),
          controller: _localPhoneController,
          onChanged: (phone) {
            // Persist E.164 complete number in controller
            widget.serviceBookingController.phoneNumberController.text =
                phone.completeNumber;
          },
          onCountryChanged: (country) {
            if (country.code != _isoCode) {
              setState(() {
                _isoCode = country.code;
              });
            }
          },
        ),

        SizedBox(height: 12),

        /// Service name Field
        CustomFormCard(
          title: "Enter Address",
          hintText: "Enter address",
          prefixIcon: Icon(Icons.location_pin),
          hasBackgroundColor: true,
          controller: widget.serviceBookingController.addressController,
          readOnly: true,
          onTap: () async {
            final result = await Get.toNamed(AppRoutes.pickerMapScreen);
            if (result is Map) {
              final address = result['address']?.toString() ?? '';
              final lat = (result['latitude'] as num?)?.toDouble() ?? 0.0;
              final lng = (result['longitude'] as num?)?.toDouble() ?? 0.0;
              widget.serviceBookingController.setSelectedAddress(
                address: address,
                latitude: lat,
                longitude: lng,
              );
            }
          },
        ),

        SizedBox(height: 12),

        /// Service name Field
        CustomFormCard(
          title: "Description",
          hintText: "Enter description",
          hasBackgroundColor: true,

          maxLine: 2,
          controller: widget.serviceBookingController.descriptionController,
        ),

        SizedBox(height: 24),

        ElevatedButton(
          onPressed: () => _onPressNext(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.appColors,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.9,
              50,
            ), // 90% of screen width
          ),
          child: CustomText(
            text: 'Next',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 16),
      ],
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // fullscreen feel
      // isDismissible: false, // Prevent tap outside dismiss
      // enableDrag: false, // Prevent drag down dismiss
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DefaultTabController(
          length: 2,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
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
                            animateToDisplayedMonthDate: true,
                            currentDate: DateTime.now(),
                            selectedDayHighlightColor: Colors.blue,
                          ),
                          value: [
                            widget.serviceBookingController.selectedDate.value,
                          ],
                          onValueChanged: (value) {
                            widget.serviceBookingController.setSelectedDate(
                              value.first,
                            );
                          },
                        );
                      }),

                      /// ---------- Time Picker ----------
                      TimePickerWidget(
                        onTimeSelected: (time) {
                          widget.serviceBookingController.setSelectedTime(time);
                          print(
                            widget.serviceBookingController.selectedTime.value,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                /// ---------- Confirm Button ----------
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FilledButton(
                    onPressed: () {
                      if (widget.serviceBookingController.unAvailableSlots
                          .contains(
                            widget.serviceBookingController.selectedTime.value,
                          )) {
                        Get.dialog(
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color(0xFF1B2D51),
                                width: 1.6,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 27,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Title
                                  const Text(
                                    'Booking Conflict',
                                    style: TextStyle(
                                      fontFamily: 'Lexend',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F0B18),
                                      letterSpacing: -1,
                                      height: 1.3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),

                                  // Clock Icon with X Badge
                                  Stack(
                                    children: [
                                      // Clock Icon
                                      // Container(
                                      //   width: 90,
                                      //   height: 90,
                                      //   decoration: BoxDecoration(
                                      //     shape: BoxShape.circle,
                                      //     color: const Color(
                                      //       0xFFB9C2DB,
                                      //     ).withOpacity(0.3),
                                      //   ),
                                      //   child: const Icon(
                                      //     Icons.access_time,
                                      //     size: 50,
                                      //     color: Color(0xFF4899D1),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Assets.icons.clock.svg(
                                          width: 68,
                                          height: 68,
                                          colorFilter: ColorFilter.mode(
                                            const Color(0xFF4899D1),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                      // X Badge
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFDE5640),
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Unavailable message
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF4F4F59),
                                        height: 1.5,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text:
                                              'The provider is unavailable at ',
                                        ),
                                        TextSpan(
                                          text: _formatTime(
                                            widget
                                                .serviceBookingController
                                                .selectedTime
                                                .value,
                                          ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF0F0B18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),

                                  // Next available message
                                  RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF4F4F59),
                                        height: 1.5,
                                      ),
                                      children: [
                                        TextSpan(text: 'Next available: '),
                                        TextSpan(
                                          text: '08:30 AM',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1B2D51),
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),

                                  // OK Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFF7A51D,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 100,
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(
                                          fontFamily: 'Lexend',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        widget.serviceBookingController.setDateTimeController();
                        Navigator.of(context).pop();
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.appColors,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      fixedSize: Size(double.maxFinite, 48.w),
                    ),
                    child: Text("Done"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _onPressNext(BuildContext context) {
    if (widget.serviceBookingController.dateTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select date and time'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (widget.serviceBookingController.durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter service duration'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    final rawPhone = widget.serviceBookingController.phoneNumberController.text;
    if (rawPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter phone number'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    final normalized = widget.serviceBookingController
        .validateAndNormalizePhone(rawPhone);
    if (normalized == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid phone number with country code (e.g., +8801XXXXXXXXX)',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    // Update the controller with normalized value so subsequent steps use it
    widget.serviceBookingController.phoneNumberController.text = normalized;
    if (widget.serviceBookingController.addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter address'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    // Get.toNamed(AppRoutes.serviceBookSecondScreen);
    widget.serviceBookingController.currentStep.value += 1;
    widget.serviceBookingController.printStepOneInfo();
  }
}
