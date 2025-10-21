import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:flutter/material.dart';

class ScheduleTabView extends StatelessWidget {
  const ScheduleTabView({super.key});

  static const List<Map<String, String>> schedule = [
    {
      'day': 'Monday',
      'startTime': '9:00',
      'endTime': '18:00',
      'bufferTime': '30 Min',
      'status': 'Available',
    },
    {
      'day': 'Tuesday',
      'startTime': '9:00',
      'endTime': '18:00',
      'bufferTime': '15 Min',
      'status': 'Available',
    },
    {
      'day': 'Wednesday',
      'startTime': '9:00',
      'endTime': '18:00',
      'bufferTime': '15 Min',
      'status': 'Available',
    },
    {
      'day': 'Thursday',
      'startTime': '9:00',
      'endTime': '18:00',
      'bufferTime': '15 Min',
      'status': 'Available',
    },
    {
      'day': 'Friday',
      'startTime': '9:00',
      'endTime': '18:00',
      'bufferTime': '15 Min',
      'status': 'Available',
    },
    {
      'day': 'Saturday',
      'startTime': '',
      'endTime': '',
      'bufferTime': '',
      'status': 'Not available',
    },
    {
      'day': 'Sunday',
      'startTime': '',
      'endTime': '',
      'bufferTime': '',
      'status': 'Not available',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        final daySchedule = schedule[index];

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText2(
                  text: daySchedule['day']!,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),

                Row(
                  children: [
                    if (daySchedule['startTime']!.isNotEmpty)
                      CustomText2(
                        text:
                            "${daySchedule['startTime']} — ${daySchedule['endTime']}",
                        fontSize: 16,
                      ),

                    const SizedBox(width: 10),

                    CustomText2(
                      text: daySchedule['status']!,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: daySchedule['status'] == 'Available'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
