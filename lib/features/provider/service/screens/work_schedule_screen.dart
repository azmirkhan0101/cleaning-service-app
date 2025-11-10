import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/features/provider/service/controllers/service_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkScheduleScreen extends StatefulWidget {
  const WorkScheduleScreen({super.key});

  @override
  State<WorkScheduleScreen> createState() => _WorkScheduleScreenState();
}

class _WorkScheduleScreenState extends State<WorkScheduleScreen> {
  final createController = Get.find<ServiceCreateController>();

  final Map<String, DaySchedule> _schedule = {
    'monday': DaySchedule(
      day: 'Monday',
      isAvailable: true,
      startTime: '09:00',
      endTime: '17:00',
    ),
    'tuesday': DaySchedule(
      day: 'Tuesday',
      isAvailable: true,
      startTime: '09:00',
      endTime: '17:00',
    ),
    'wednesday': DaySchedule(
      day: 'Wednesday',
      isAvailable: true,
      startTime: '09:00',
      endTime: '17:00',
    ),
    'thursday': DaySchedule(
      day: 'Thursday',
      isAvailable: true,
      startTime: '09:00',
      endTime: '17:00',
    ),
    'friday': DaySchedule(
      day: 'Friday',
      isAvailable: true,
      startTime: '09:00',
      endTime: '17:00',
    ),
    'saturday': DaySchedule(
      day: 'Saturday',
      isAvailable: false,
      startTime: '',
      endTime: '',
    ),
    'sunday': DaySchedule(
      day: 'Sunday',
      isAvailable: false,
      startTime: '',
      endTime: '',
    ),
  };

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: ListView.separated(
                  itemCount: _schedule.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final key = _schedule.keys.elementAt(index);
                    final daySchedule = _schedule[key]!;
                    return _buildDayCard(key, daySchedule);
                  },
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => ElevatedButton(
                  onPressed: createController.isCreating.value
                      ? null
                      : _confirmSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7A51D),
                    disabledBackgroundColor: const Color(
                      0xFFF7A51D,
                    ).withOpacity(0.6),
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

  Widget _buildDayCard(String key, DaySchedule daySchedule) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9EBF3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Day name
          SizedBox(
            width: 70,
            child: Text(
              daySchedule.day,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F0B18),
              ),
            ),
          ),

          // Time fields (only show if available)
          if (daySchedule.isAvailable) ...[
            // From time
            Expanded(
              child: InkWell(
                onTap: () => _showCustomTimePicker(
                  context,
                  daySchedule.day,
                  isStartTime: true,
                  currentTime: daySchedule.startTime,
                  onConfirm: (time) {
                    setState(() {
                      daySchedule.startTime = time;
                    });
                  },
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE9EBF3)),
                  ),
                  child: Text(
                    daySchedule.startTime,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F0B18),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 6),

            const Text(
              '-',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4F4F59),
              ),
            ),

            const SizedBox(width: 6),

            // Until time
            Expanded(
              child: InkWell(
                onTap: () => _showCustomTimePicker(
                  context,
                  daySchedule.day,
                  isStartTime: false,
                  currentTime: daySchedule.endTime,
                  onConfirm: (time) {
                    setState(() {
                      daySchedule.endTime = time;
                    });
                  },
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE9EBF3)),
                  ),
                  child: Text(
                    daySchedule.endTime,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F0B18),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),
          ],

          if (!daySchedule.isAvailable) const Expanded(child: SizedBox()),

          // Toggle switch
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: daySchedule.isAvailable,
              onChanged: (value) {
                setState(() {
                  daySchedule.isAvailable = value;
                  if (!value) {
                    daySchedule.startTime = '';
                    daySchedule.endTime = '';
                  } else {
                    daySchedule.startTime = '09:00';
                    daySchedule.endTime = '17:00';
                  }
                });
              },
              activeColor: const Color(0xFF4899D1),
              activeTrackColor: const Color(0xFF4899D1).withOpacity(0.5),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFE9EBF3),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomTimePicker(
    BuildContext context,
    String dayName, {
    required bool isStartTime,
    required String currentTime,
    required Function(String) onConfirm,
  }) {
    // Parse current time
    final parts = currentTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
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
                        onConfirm(timeString);
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

  void _confirmSchedule() async {
    // Get the create controller
    final createController = Get.find<ServiceCreateController>();

    // Convert to the required JSON format
    final scheduleData = _schedule.map(
      (key, value) => MapEntry(key, {
        'day': value.day,
        'isAvailable': value.isAvailable,
        'startTime': value.startTime,
        'endTime': value.endTime,
      }),
    );

    // Save schedule data to controller
    createController.workSchedule = scheduleData;

    // Call the API
    await createController.createService();
  }
}

/// Model class for day schedule
class DaySchedule {
  String day;
  bool isAvailable;
  String startTime;
  String endTime;

  DaySchedule({
    required this.day,
    required this.isAvailable,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'isAvailable': isAvailable,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
