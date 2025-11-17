import 'package:cleaning_service_app/features/provider/service/models/provider_service_model.dart';
import 'package:get/get.dart';

class WorkScheduleController extends GetxController {
  // Schedule state
  final RxMap<String, DaySchedule> schedule = <String, DaySchedule>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSchedule();
  }

  /// Initialize default schedule
  void _initializeSchedule() {
    schedule.value = {
      'monday': DaySchedule(
        day: 'Monday',
        isAvailable: true,
        startTime: '09:00',
        endTime: '17:00',
        bufferTime: 15,
      ),
      'tuesday': DaySchedule(
        day: 'Tuesday',
        isAvailable: true,
        startTime: '09:00',
        endTime: '17:00',
        bufferTime: 15,
      ),
      'wednesday': DaySchedule(
        day: 'Wednesday',
        isAvailable: true,
        startTime: '09:00',
        endTime: '17:00',
        bufferTime: 15,
      ),
      'thursday': DaySchedule(
        day: 'Thursday',
        isAvailable: true,
        startTime: '09:00',
        endTime: '17:00',
        bufferTime: 15,
      ),
      'friday': DaySchedule(
        day: 'Friday',
        isAvailable: true,
        startTime: '09:00',
        endTime: '17:00',
        bufferTime: 15,
      ),
      'saturday': DaySchedule(
        day: 'Saturday',
        isAvailable: false,
        startTime: '',
        endTime: '',
        bufferTime: 15,
      ),
      'sunday': DaySchedule(
        day: 'Sunday',
        isAvailable: false,
        startTime: '',
        endTime: '',
        bufferTime: 15,
      ),
    };
  }

  /// Toggle day availability
  void toggleDayAvailability(String key, bool value) {
    final daySchedule = schedule[key];
    if (daySchedule != null) {
      daySchedule.isAvailable = value;
      if (!value) {
        daySchedule.startTime = '';
        daySchedule.endTime = '';
      } else {
        daySchedule.startTime = '09:00';
        daySchedule.endTime = '17:00';
      }
      schedule.refresh();
    }
  }

  /// Update start time
  void updateStartTime(String key, String time) {
    final daySchedule = schedule[key];
    if (daySchedule != null) {
      daySchedule.startTime = time;
      schedule.refresh();
    }
  }

  /// Update end time
  void updateEndTime(String key, String time) {
    final daySchedule = schedule[key];
    if (daySchedule != null) {
      daySchedule.endTime = time;
      schedule.refresh();
    }
  }

  /// Update buffer time
  void updateBufferTime(String key, int minutes) {
    final daySchedule = schedule[key];
    if (daySchedule != null) {
      daySchedule.bufferTime = minutes;
      schedule.refresh();
    }
  }

  /// Get schedule data as JSON
  Map<String, Map<String, dynamic>> getScheduleData() {
    return schedule.map((key, value) => MapEntry(key, value.toJson()));
  }

  /// Load existing schedule data
  void loadScheduleData(Map<String, Map<String, dynamic>> scheduleData) {
    scheduleData.forEach((key, value) {
      final daySchedule = schedule[key.toLowerCase()];
      if (daySchedule != null) {
        daySchedule.isAvailable = value['isAvailable'] ?? false;
        daySchedule.startTime = value['startTime'] ?? '';
        daySchedule.endTime = value['endTime'] ?? '';
        daySchedule.bufferTime = value['bufferTime'] ?? 15;
      }
    });
    schedule.refresh();
  }
}
