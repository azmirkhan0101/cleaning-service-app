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
