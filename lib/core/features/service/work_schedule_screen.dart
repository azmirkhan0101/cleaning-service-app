import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/features/service/service_controller.dart';
import 'package:cleaning_service_app/core/features/service/service_screen.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WorkScheduleScreen extends StatefulWidget {
  const WorkScheduleScreen({super.key});

  @override
  State<WorkScheduleScreen> createState() => _WorkScheduleScreenState();
}

class _WorkScheduleScreenState extends State<WorkScheduleScreen> {

  final  serviceController = Get.find<ServiceController>();


  final List<DaySchedule> _days = [
    DaySchedule(weekday: Weekday.monday,     start: const TimeOfDay(hour: 9,  minute: 0), end: const TimeOfDay(hour: 18, minute: 0), available: true),
    DaySchedule(weekday: Weekday.tuesday,    start: const TimeOfDay(hour: 9,  minute: 0), end: const TimeOfDay(hour: 18, minute: 0), available: true),
    DaySchedule(weekday: Weekday.wednesday,  start: const TimeOfDay(hour: 9,  minute: 0), end: const TimeOfDay(hour: 18, minute: 0), available: true),
    DaySchedule(weekday: Weekday.thursday,   start: const TimeOfDay(hour: 9,  minute: 0), end: const TimeOfDay(hour: 18, minute: 0), available: true),
    DaySchedule(weekday: Weekday.friday,     start: const TimeOfDay(hour: 9,  minute: 0), end: const TimeOfDay(hour: 18, minute: 0), available: true),
    DaySchedule(weekday: Weekday.saturday,   start: const TimeOfDay(hour: 9,  minute: 0), end: const TimeOfDay(hour: 18, minute: 0), available: false),
    DaySchedule(weekday: Weekday.sunday,     start: const TimeOfDay(hour: 9,  minute: 0), end: const TimeOfDay(hour: 18, minute: 0), available: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: 'Work schedule',leftIcon: true,),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
              CustomText(text:
              'When are you available to offer your services?',
                  fontSize: 18, fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                maxLines: 2,
            ),
            const SizedBox(height: 12),
            ..._days.map((d) => DayRow(
              schedule: d,
              onTapDay: () => _openTimeDialog(d),
              onToggle: (val) => setState(() => d.available = val),
              onSetBuffer: () => _setBufferTime(d), // stub for your flow
            )),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {

               Get.to(ServiceScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColors,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),  // 90% of screen width
              ),
              child: CustomText(
                text: 'Confirm',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openTimeDialog(DaySchedule day) async {
    // Only allow editing if the day is available
    if (!day.available) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${day.label} is set to Not available',style: TextStyle(fontSize: 18,
            fontWeight: FontWeight.w600),),backgroundColor: AppColors.lightRed,
         padding: EdgeInsets.all(24),
        ),
      );
      return;
    }

    // Keep temporary values while editing
    TimeOfDay tempStart = day.start;
    TimeOfDay tempEnd = day.end;

    bool? saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: Text('Set time • ${day.label}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TimeField(
                    label: 'Start',
                    time: tempStart,
                    onPick: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: tempStart,
                        helpText: 'Select start time',
                        builder: (context, child) => MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        ),
                      );
                      if (picked != null) setLocalState(() => tempStart = picked);
                    },
                  ),
                  const SizedBox(height: 8),
                  _TimeField(
                    label: 'End',
                    time: tempEnd,
                    onPick: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: tempEnd,
                        helpText: 'Select end time',
                        builder: (context, child) => MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        ),
                      );
                      if (picked != null) setLocalState(() => tempEnd = picked);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ValidationHint(start: tempStart, end: tempEnd),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                FilledButton(
                  onPressed: _isValidRange(tempStart, tempEnd) ? () => Navigator.pop(context, true) : null,
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved == true) {
      setState(() {
        day.start = tempStart;
        day.end = tempEnd;
      });
    }
  }

  /// set buffer time setup
  void _setBufferTime(DaySchedule day) {
    // Hook your buffer-time flow here
 /*   ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Set Buffer Time • ${day.label}')),
    );*/

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(8),
        contentPadding: EdgeInsets.all(8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: "Set Buffer Time",
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color:AppColors.lightBlue,
            ),

            InkWell(child: Icon(Icons.close,size: 32,),
              onTap: (){
              Navigator.of(context).pop();
            },)
          ],
        ),
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
               () {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Radio<bool>(
                         value:false  // Value for "No"
                         ,
                         fillColor:
                         WidgetStateColor.resolveWith((states) =>
                         AppColors.black_04),
                         groupValue: serviceController.setBufferTimeType.value,
                         onChanged:(bool? value) {
                           serviceController.setBufferTimeType.value=value!;
                         },
                       ),

                       const CustomText(
                         text:
                         "15 minutes",
                         fontSize:
                         14,
                         color: AppColors
                             .black,
                         fontWeight:
                         FontWeight
                             .w600,
                       ),

                     ],
                   ),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Radio<bool>(
                         value:
                         true, // Value for "No"
                         fillColor:
                         WidgetStateColor.resolveWith((states) =>
                         AppColors.black_04),
                         groupValue: serviceController.setBufferTimeType.value,
                         onChanged:(bool? value) {
                           serviceController.setBufferTimeType.value=value!;
                         },
                       ),

                       const CustomText(
                         text:
                         "30 minutes",
                         fontSize:
                         14,
                         color: AppColors
                             .black,
                         fontWeight:
                         FontWeight
                             .w600,
                       ),

                     ],
                   ),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Radio<bool>(
                         value:
                         false, // Value for "No"
                         fillColor:
                         WidgetStateColor.resolveWith((states) =>
                         AppColors.black_04),
                         groupValue: serviceController.setBufferTimeType.value,
                         onChanged:(bool? value) {
                           serviceController.setBufferTimeType.value=value!;
                         },
                       ),

                       const CustomText(
                         text:
                         "45 minutes",
                         fontSize:
                         14,
                         color: AppColors
                             .black,
                         fontWeight:
                         FontWeight
                             .w600,
                       ),

                     ],
                   ),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Radio<bool>(
                         value:
                         true, // Value for "No"
                         fillColor:
                         WidgetStateColor.resolveWith((states) =>
                         AppColors.black_04),
                         groupValue: serviceController.setBufferTimeType.value,
                         onChanged:(bool? value) {
                           serviceController.setBufferTimeType.value = value!;
                         },
                       ),

                       const CustomText(
                         text:
                         "1 hour   ",
                         fontSize:
                         14,
                         color: AppColors
                             .black,
                         fontWeight:
                         FontWeight
                             .w600,
                         maxLines: 2,
                       ),

                     ],
                   ),

                    SizedBox(
                      height: 8,
                    ),

                    CustomButton(
                        onTap: () {
                          Navigator.of(context).pop();

                        },
                        title: "Yes",
                        height: 45,
                        fontSize: 12,
                        fillColor: AppColors.appColors),


                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidRange(TimeOfDay start, TimeOfDay end) {
    final s = start.hour * 60 + start.minute;
    final e = end.hour * 60 + end.minute;
    return e > s; // end must be after start
    // If you need overnight ranges, allow e <= s and handle across midnight.
  }

  void _confirm() {
    // Example: serialize schedules and send to backend
    final data = _days
        .map((d) => {
      'day': d.label,
      'available': d.available,
      'start': d.format24(),
      'end': d.format24(isEnd: true),
    })
        .toList();
    debugPrint('SCHEDULE: $data');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule saved')),
    );
  }
}

/// Model

enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class DaySchedule {
  DaySchedule({
    required this.weekday,
    required this.start,
    required this.end,
    required this.available,
  });

  final Weekday weekday;
  TimeOfDay start;
  TimeOfDay end;
  bool available;

  String get label => weekday.name[0].toUpperCase() + weekday.name.substring(1);

  /// Formats as 24h string like "09:00"
  String format24({bool isEnd = false}) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(isEnd ? end.hour : start.hour)}:${two(isEnd ? end.minute : start.minute)}';
  }
}

///===================== UI widgets =========================

class DayRow extends StatelessWidget {
  const DayRow({
    super.key,
    required this.schedule,
    required this.onTapDay,
    required this.onToggle,
    required this.onSetBuffer,
  });

  final DaySchedule schedule;
  final VoidCallback onTapDay;
  final ValueChanged<bool> onToggle;
  final VoidCallback onSetBuffer;

  @override
  Widget build(BuildContext context) {
    final muted = !schedule.available;
    final labelStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: muted ? Colors.black45 : Colors.black87,
    );

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(schedule.label, style: labelStyle),
            ),
            Switch(
              value: schedule.available,
              onChanged: onToggle,
               activeColor: AppColors.lightBlue,
            ),
            const SizedBox(width: 8),
            Text(
              schedule.available ? 'Available' : 'Not available',
              style: TextStyle(
                color: schedule.available ? Colors.green.shade700 : Colors.black45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [

            Expanded(
              child: InkWell(
                onTap: onTapDay,
                borderRadius: BorderRadius.circular(8),
                child: IgnorePointer(
                  ignoring: true,
                  child: _TimeRangeDisplay(
                    start: schedule.start,
                    end: schedule.end,
                    disabled: !schedule.available,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: schedule.available ? onSetBuffer : null,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                backgroundColor: AppColors.lightBlue,
              ),
              child: const Text('Set Buffer Time',style: TextStyle(color: AppColors.white),),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(height: 1),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _TimeRangeDisplay extends StatelessWidget {
  const _TimeRangeDisplay({
    required this.start,
    required this.end,
    required this.disabled,
  });

  final TimeOfDay start;
  final TimeOfDay end;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 16,
      color: disabled ? Colors.black38 : Colors.black87,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
     //   border: Border.all(color: disabled ? Colors.black12 : Colors.black26),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_fmt(start), style: style),
          const SizedBox(width: 8),
          const Text('—'),
          const SizedBox(width: 8),
          Text(_fmt(end), style: style),
        ],
      ),
    );
  }

  String _fmt(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class _TimeField extends StatelessWidget {
  const _TimeField({required this.label, required this.time, required this.onPick});
  final String label;
  final TimeOfDay time;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
        //  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }
}

class _ValidationHint extends StatelessWidget {
  const _ValidationHint({required this.start, required this.end});
  final TimeOfDay start;
  final TimeOfDay end;

  @override
  Widget build(BuildContext context) {
    final s = start.hour * 60 + start.minute;
    final e = end.hour * 60 + end.minute;
    if (e > s) {
      return const SizedBox.shrink();
    }
    return Row(
      children: const [
        Icon(Icons.error_outline, color: Colors.red, size: 18),
        SizedBox(width: 6),
        Expanded(child: Text('End time must be after start time.', style: TextStyle(color: Colors.red))),
      ],
    );
  }
}
