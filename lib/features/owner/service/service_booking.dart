import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/common/widgets/time_picker_widget.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/owner_service_controller.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ServiceBooking extends StatefulWidget {
  const ServiceBooking({super.key});

  @override
  State<ServiceBooking> createState() => _ServiceBookingState();
}

class _ServiceBookingState extends State<ServiceBooking> {
  final ownerController = Get.find<OwnerServiceController>();
  final serviceBookingController = Get.find<ServiceBookingController>();

  DateTime? selected;

  int? selectedHour;
  int? selectedMinute;

  final List<int> hours = List.generate(24, (i) => i); // 0–23
  final List<int> minutes = List.generate(12, (i) => i * 5); // 0, 5, 10…55

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "Book Details", leftIcon: true),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16.w,
                children: [
                  _buildCircularStep(label: "Step 1", isCompleted: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4.w,
                    children: List.generate(
                      12,
                      (index) => Container(
                        width: 8,
                        height: 2,
                        decoration: BoxDecoration(
                          color: Color(0xFF4899D1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  _buildCircularStep(label: "Step 2", isCompleted: false),
                ],
              ),

              SizedBox(height: 16),

              CustomText2(
                text: "Enter Your Information",
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 24),

              /// Date And TimeField
              CustomFormCard(
                title: "Date And Time",
                hintText: "Enter date and time",
                hasBackgroundColor: true,
                prefixIcon: Icon(Icons.calendar_month),
                controller: serviceBookingController.dateTimeController,
                readOnly: true,
                onTap: () async {
                  _openBottomSheet(context);
                },
              ),

              SizedBox(height: 12),

              /// Phone Number Field
              CustomFormCard(
                title: "Phone Number",
                hintText: "Enter phone number",
                hasBackgroundColor: true,
                prefixIcon: Icon(Icons.phone),
                controller: serviceBookingController.phoneNumberController,
              ),

              SizedBox(height: 12),

              /// Service name Field
              CustomFormCard(
                title: "Enter Address",
                hintText: "Enter address",
                prefixIcon: Icon(Icons.location_pin),
                hasBackgroundColor: true,
                controller: serviceBookingController.addressController,
              ),

              SizedBox(height: 12),

              /// Service name Field
              CustomFormCard(
                title: "Description",
                hintText: "Enter description",
                hasBackgroundColor: true,

                maxLine: 2,
                controller: serviceBookingController.descriptionController,
              ),

              SizedBox(height: 12),

              SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.serviceBookSecondScreen);
                },
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
                child: CustomText2(
                  text: 'Confirm',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularStep({
    required String label,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(11),
          decoration: ShapeDecoration(
            color: isCompleted ? const Color(0xFF4899D1) : Color(0xFFDDE1ED),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: isCompleted
              ? Assets.icons.checkCircle.svg()
              : Assets.icons.circle.svg(),
        ),
        // StepCircle(isActive: true, isCompleted: true),
        CustomText(
          text: label,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: FontFamily.lexend,
          color: isCompleted ? AppColors.black : const Color(0xFFB9C2DB),
        ),
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
                          value: [serviceBookingController.selectedDate.value],
                          onValueChanged: (value) {
                            serviceBookingController.setSelectedDate(
                              value.first,
                            );
                          },
                        );
                      }),

                      /// ---------- Time Picker ----------
                      TimePickerWidget(
                        onTimeSelected: (time) {
                          serviceBookingController.setSelectedTime(time);
                          print(serviceBookingController.selectedTime.value);
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
                      if (serviceBookingController.unAvailableSlots.contains(
                        serviceBookingController.selectedTime.value,
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
                                            serviceBookingController
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
                                        Get.back();
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
                        serviceBookingController.setDateTimeController();
                        Get.back();
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
}
