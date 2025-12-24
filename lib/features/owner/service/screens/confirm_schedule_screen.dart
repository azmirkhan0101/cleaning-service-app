import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/available_slots_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConfirmScheduleScreen extends StatefulWidget {
  final String? providerId;
  final String serviceId;

  const ConfirmScheduleScreen({
    super.key,
    this.providerId,
    required this.serviceId,
  });

  @override
  State<ConfirmScheduleScreen> createState() => _ConfirmScheduleScreenState();
}

class _ConfirmScheduleScreenState extends State<ConfirmScheduleScreen> {
  final controller = Get.put(AvailableSlotsController());

  @override
  void initState() {
    super.initState();
    controller.setProviderId(widget.serviceId);
    // Select today's date by default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectDate(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: 'Confirm Schedule',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Section
                    CustomText(
                      text: 'Chose date',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A9FD8),
                    ),
                    SizedBox(height: 16.h),

                    // Calendar
                    _buildCalendar(),

                    SizedBox(height: 24.h),

                    // Time Section
                    CustomText(
                      text: 'Chose time',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A9FD8),
                    ),
                    SizedBox(height: 16.h),

                    // Time Slots
                    controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : _buildTimeSlots(),

                    SizedBox(height: 16.h),

                    // Info text
                    Center(
                      child: CustomText(
                        text: 'Select your preferred start time',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: CustomButton(
                title: 'Select Schedule',
                onTap: _handleBooking,
                fillColor: controller.isStartTimeSelected()
                    ? const Color(0xFFFFA726)
                    : Colors.grey,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          calendarType: CalendarDatePicker2Type.single,
          selectedDayHighlightColor: const Color(0xFF4A9FD8),
          weekdayLabels: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
          weekdayLabelTextStyle: TextStyle(
            color: const Color(0xFF4A9FD8),
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
          firstDayOfWeek: 0,
          controlsHeight: 50.h,
          controlsTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          dayTextStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
          disabledDayTextStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14.sp,
          ),
          selectableDayPredicate: (day) {
            // Only allow current and future dates
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            return day.isAfter(today.subtract(const Duration(days: 1)));
          },
        ),
        value: controller.selectedDate.value != null
            ? [controller.selectedDate.value!]
            : [],
        onValueChanged: (dates) {
          if (dates.isNotEmpty) {
            controller.selectDate(dates.first);
          }
        },
      ),
    );
  }

  Widget _buildTimeSlots() {
    final slots = controller.availableSlots.value?.slots ?? [];

    if (slots.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: CustomText(
            text: 'No time slots available for this date',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 2.2,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = controller.isSlotSelected(slot.time);
        final isAvailable = slot.available;

        return GestureDetector(
          onTap: isAvailable
              ? () {
                  controller.selectStartTime(slot.time);
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFFF6B35)
                  : (isAvailable ? Colors.white : Colors.grey.shade100),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFFF6B35)
                    : (isAvailable
                          ? Colors.grey.shade300
                          : Colors.grey.shade200),
                width: 1,
              ),
            ),
            child: Center(
              child: CustomText(
                text: _formatTime(slot.time),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isAvailable ? Colors.black87 : Colors.grey.shade400),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(String time) {
    try {
      // Parse time in 24-hour format (HH:mm)
      final parts = time.split(':');
      if (parts.length != 2) return time;

      final hour = int.parse(parts[0]);
      final minute = parts[1];

      // Convert to 12-hour format
      if (hour == 0) {
        return '12:$minute am';
      } else if (hour < 12) {
        return '${hour.toString().padLeft(2, '0')}:$minute am';
      } else if (hour == 12) {
        return '12:$minute pm';
      } else {
        return '${(hour - 12).toString().padLeft(2, '0')}:$minute pm';
      }
    } catch (e) {
      return time;
    }
  }

  void _handleBooking() {
    if (!controller.isStartTimeSelected()) {
      Get.snackbar(
        'Invalid Selection',
        'Please select a start time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    // Return selected data to previous screen
    Get.back(
      result: {
        'date': controller.selectedDate.value,
        'startTime': controller.selectedStartTime.value,
      },
    );
  }

  @override
  void dispose() {
    Get.delete<AvailableSlotsController>();
    super.dispose();
  }
}
