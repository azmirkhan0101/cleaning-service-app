import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/features/provider/service/controllers/provider_service_controller.dart';
import 'package:cleaning_service_app/features/provider/service/controllers/service_create_controller.dart';
import 'package:cleaning_service_app/features/provider/service/controllers/work_schedule_controller.dart';
import 'package:cleaning_service_app/features/provider/service/models/provider_service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WorkScheduleScreen extends StatelessWidget {
  const WorkScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleController = Get.put(WorkScheduleController());
    final createController = Get.find<ServiceCreateController>();

    // Load existing schedule data if in edit mode
    if (createController.isEditMode.value &&
        createController.workSchedule.isNotEmpty) {
      scheduleController.loadScheduleData(createController.workSchedule);
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Work schedule', backButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const CustomText2(
                text: 'When are you available to offer your services?',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              /// ======> Set Buffer Time <=====
              FilledButton(
                onPressed: () {
                  _showBufferTimePicker(context);
                },
                child: const CustomText2(
                  text: 'Set Buffer Time',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              /// Schedule
              Expanded(
                child: Obx(
                  () => ListView.separated(
                    itemCount: scheduleController.schedule.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final key = scheduleController.schedule.keys.elementAt(
                        index,
                      );
                      final daySchedule = scheduleController.schedule[key]!;
                      return _buildDayCard(
                        context,
                        scheduleController,
                        key,
                        daySchedule,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => ElevatedButton(
                  onPressed: createController.isCreating.value
                      ? null
                      : () => _confirmSchedule(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7A51D),
                    disabledBackgroundColor: const Color(
                      0xFFF7A51D,
                    ).withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: createController.isCreating.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const CustomText2(
                          text: 'Confirm',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(
    BuildContext context,
    WorkScheduleController controller,
    String key,
    DaySchedule daySchedule,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9EBF3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Row of day name, switch and status (available/not available)
          Row(
            children: [
              // Day name
              CustomText(
                text: daySchedule.day,
                textAlign: TextAlign.center,
                color: const Color(0xFF0F0B18),
                fontSize: 16,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
              const Spacer(),

              // Toggle switch
              Transform.scale(
                scale: 1.2,
                child: Switch(
                  value: daySchedule.isAvailable,
                  onChanged: (value) {
                    controller.toggleDayAvailability(key, value);
                  },
                  activeThumbColor: const Color(0xFFFFFFFF),
                  activeTrackColor: const Color(0xFF4899D1),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE9EBF3),
                  trackOutlineColor: WidgetStateProperty.all(
                    const Color(0xFFE9EBF3),
                  ),
                ),
              ),
              SizedBox(width: 28.w),

              /// Status text
              CustomText(
                text: daySchedule.isAvailable ? 'Available' : 'Not available',
                textAlign: TextAlign.center,
                color: daySchedule.isAvailable
                    ? const Color(0xFF4899D1)
                    : const Color(0xFF4F4F59),
                fontSize: 12,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ],
          ),

          /// Start time, buffer, end time and set buffer time button
          Row(
            children: [
              /// Start time
              if (daySchedule.isAvailable) ...[
                // From time
                Expanded(
                  child: InkWell(
                    onTap: () => _showCustomTimePicker(
                      context,
                      controller,
                      key,
                      daySchedule.day,
                      isStartTime: true,
                      currentTime: daySchedule.startTime,
                    ),
                    child: _buildStartEndTimeCard(
                      daySchedule,
                      isStartTime: true,
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                Column(
                  spacing: 4,
                  children: [
                    Obx(() {
                      return CustomText(
                        text: '${controller.bufferTime.value} Min',
                        textAlign: TextAlign.center,
                        color: const Color(0xFF0F0B18),
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      );
                    }),

                    Container(
                      width: 12,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: const Color(0xFF4F4F59),
                          ),
                        ),
                      ),
                    ),

                    CustomText(text: ""),
                  ],
                ),

                const SizedBox(width: 6),

                /// Until time
                Expanded(
                  child: InkWell(
                    onTap: () => _showCustomTimePicker(
                      context,
                      controller,
                      key,
                      daySchedule.day,
                      isStartTime: false,
                      currentTime: daySchedule.endTime,
                    ),
                    child: _buildStartEndTimeCard(
                      daySchedule,
                      isStartTime: false,
                    ),
                  ),
                ),
                SizedBox(width: 22.w),

                /// Set buffer time button
                // GestureDetector(
                //   onTap: () => _showBufferTimePicker(
                //     context,
                //     controller,
                //     key,
                //     daySchedule,
                //   ),
                //   child: Container(
                //     width: 82.w,
                //     height: 23.h,
                //     padding: const EdgeInsets.symmetric(vertical: 2),
                //     decoration: ShapeDecoration(
                //       color: const Color(0xFF4899D1),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(2),
                //       ),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       spacing: 10,
                //       children: [
                //         Text(
                //           'Set Buffer Time',
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 10,
                //             fontFamily: 'Lexend',
                //             fontWeight: FontWeight.w400,
                //             height: 1.50,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartEndTimeCard(
    DaySchedule daySchedule, {
    required bool isStartTime,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        // color: const Color(0xFFF7F8FA),
        // borderRadius: BorderRadius.circular(6),
        border: Border(
          bottom: BorderSide(color: const Color(0xFF000000), width: 1),
        ),
      ),
      child: CustomText(
        text: isStartTime ? daySchedule.startTime : daySchedule.endTime,
        textAlign: TextAlign.center,
        color: const Color(0xFF0F0B18),
        fontSize: 16,
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w400,
        height: 1.50,
      ),
    );
  }

  void _showCustomTimePicker(
    BuildContext context,
    WorkScheduleController controller,
    String key,
    String dayName, {
    required bool isStartTime,
    required String currentTime,
  }) {
    // Parse current time
    final parts = currentTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Schedule $dayName',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4899D1),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // From/Until label
                    Text(
                      isStartTime ? 'From:' : 'Until:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4F4F59),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Time picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hour picker
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                setDialogState(() {
                                  hour = (hour + 1) % 24;
                                });
                              },
                              icon: const Icon(Icons.keyboard_arrow_up),
                              iconSize: 32,
                              color: const Color(0xFF4F4F59),
                            ),
                            Text(
                              hour.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F0B18),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setDialogState(() {
                                  hour = (hour - 1 + 24) % 24;
                                });
                              },
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 32,
                              color: const Color(0xFF4F4F59),
                            ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        // Colon
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            ':',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F0B18),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Minute picker (disabled)
                        Column(
                          children: [
                            IconButton(
                              onPressed: null, // Disabled
                              icon: const Icon(Icons.keyboard_arrow_up),
                              iconSize: 32,
                              color: const Color(0xFFE9EBF3),
                              disabledColor: const Color(0xFFE9EBF3),
                            ),
                            Text(
                              minute.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F0B18),
                              ),
                            ),
                            IconButton(
                              onPressed: null, // Disabled
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 32,
                              color: const Color(0xFFE9EBF3),
                              disabledColor: const Color(0xFFE9EBF3),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Confirm button
                    ElevatedButton(
                      onPressed: () {
                        final timeString =
                            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
                        if (isStartTime) {
                          controller.updateStartTime(key, timeString);
                        } else {
                          controller.updateEndTime(key, timeString);
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7A51D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBufferTimePicker(BuildContext context) {
    final controller = Get.find<WorkScheduleController>();
    int bufferTime = controller.bufferTime.value;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Buffer Time',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4899D1),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Buffer Time label
                    const Text(
                      'Buffer Time:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4F4F59),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Buffer time picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Minutes picker
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                setDialogState(() {
                                  controller.increaseBufferTime();
                                });
                              },
                              icon: const Icon(Icons.keyboard_arrow_up),
                              iconSize: 32,
                              color: const Color(0xFF4F4F59),
                            ),
                            Text(
                              controller.bufferTime.value.toString().padLeft(
                                2,
                                '0',
                              ),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F0B18),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setDialogState(() {
                                  controller.decreaseBufferTime();
                                });
                              },
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 32,
                              color: const Color(0xFF4F4F59),
                            ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        // Minutes label
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Min',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F4F59),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Confirm button
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: const Color(0xFFF7A51D),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(24),
                    //     ),
                    //     padding: const EdgeInsets.symmetric(vertical: 14),
                    //     minimumSize: const Size(double.infinity, 48),
                    //   ),
                    //   child: const Text(
                    //     'Confirm',
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w600,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmSchedule() async {
    // Get controllers
    final workScheduleController = Get.find<WorkScheduleController>();
    final createController = Get.find<ServiceCreateController>();

    // Get schedule data from controller
    final scheduleData = workScheduleController.getScheduleData();

    // Save schedule data to create controller
    createController.workSchedule.value = scheduleData;
    createController.bufferTime.value = workScheduleController.bufferTime.value;

    // Validate before API call (Toast.errorToast will show error)
    if (!createController.validateServiceData()) {
      return;
    }

    // Call the appropriate API based on edit mode
    final success = createController.isEditMode.value
        ? await createController.updateService()
        : await createController.createService();

    // If service created/updated successfully, refresh services list and navigate back
    if (success) {
      // Refresh the services list if controller exists
      try {
        final providerServiceController = Get.find<ProviderServiceController>();
        await providerServiceController.refreshServices();
      } catch (e) {
        // Controller not found, skip refresh
      }
    }
  }
}
