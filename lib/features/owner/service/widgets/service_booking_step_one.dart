import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/common/widgets/phone_input_field.dart';
import 'package:cleaning_service_app/features/common/widgets/time_picker_widget.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_booking_controller.dart';
import 'package:cleaning_service_app/features/owner/service/screens/confirm_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:intl_mobile_field/countries.dart' as phone_countries;
// import 'package:intl_mobile_field/intl_mobile_field.dart';

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
            // _openBottomSheet(context);
            final result = await Get.to(
              ConfirmScheduleScreen(
                serviceId: widget.serviceBookingController.serviceId.value,
              ),
            );

            if (result != null) {
              final selectedDate = result['date'] as DateTime?;
              final startTime = result['startTime'] as String?;

              if (selectedDate != null && startTime != null) {
                // Update controller with selected date and time
                widget.serviceBookingController.selectedDateString.value =
                    '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                widget.serviceBookingController.selectedTimeString.value =
                    startTime;

                // Update the display field
                widget.serviceBookingController.dateTimeController.text =
                    '${widget.serviceBookingController.selectedDateString.value} $startTime';

                // Update selectedDate in controller
                widget.serviceBookingController.selectedDate.value =
                    selectedDate;
              }
            }
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
        PhoneInputField(
          onChanged: (e164) {
            // Persist E.164 complete number in controller
            widget.serviceBookingController.phoneNumberController.text = e164;
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
      isScrollControlled: true,
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
                            print(
                              "Selected Date: ${value.first.toIso8601String().substring(0, 10)}",
                            );
                            widget
                                .serviceBookingController
                                .selectedDateString
                                .value = value.first
                                .toIso8601String()
                                .substring(0, 10);
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
                      widget.serviceBookingController.setDateTimeController();
                      Navigator.of(context).pop();
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

  void _onPressNext(BuildContext context) {
    if (widget.serviceBookingController.dateTimeController.text.isEmpty) {
      Toast.errorToast('Please select date and time');
      return;
    }
    if (widget.serviceBookingController.durationController.text.isEmpty) {
      Toast.errorToast('Please enter service duration');
      return;
    }
    // Phone number captured via PhoneInputField callback into controller
    if (widget.serviceBookingController.phoneNumberController.text.isEmpty) {
      Toast.errorToast('Please enter phone number');
      return;
    }
    if (widget.serviceBookingController.addressController.text.isEmpty) {
      Toast.errorToast('Please enter address');
      return;
    }
    // Get.toNamed(AppRoutes.serviceBookSecondScreen);
    widget.serviceBookingController.currentStep.value += 1;
    // widget.serviceBookingController.printStepOneInfo();
  }
}
