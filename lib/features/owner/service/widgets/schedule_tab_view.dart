import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleTabView extends StatelessWidget {
  const ScheduleTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceDetailsController = Get.find<ServiceDetailsController>();

    return Obx(() {
      if (serviceDetailsController.isScheduleLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      final schedule = serviceDetailsController.schedule.value;

      if (schedule == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text('No schedule available'),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: schedule.allDays.length,
        itemBuilder: (context, index) {
          final daySchedule = schedule.allDays[index];

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
                    text: daySchedule.day,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),

                  Row(
                    children: [
                      if (daySchedule.isAvailable &&
                          daySchedule.startTime.isNotEmpty)
                        CustomText2(
                          text:
                              "${daySchedule.startTime} — ${daySchedule.endTime}",
                          fontSize: 16,
                        ),

                      const SizedBox(width: 10),

                      CustomText2(
                        text: daySchedule.isAvailable
                            ? 'Available'
                            : 'Not available',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: daySchedule.isAvailable
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
    });
  }
}
