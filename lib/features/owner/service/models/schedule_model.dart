// Schedule Day Model
class ScheduleDayModel {
  final String day;
  final bool isAvailable;
  final String startTime;
  final String endTime;

  ScheduleDayModel({
    required this.day,
    required this.isAvailable,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleDayModel.fromJson(Map<String, dynamic> json) {
    return ScheduleDayModel(
      day: json['day'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }
}

// Schedule Model
class ScheduleModel {
  final ScheduleDayModel monday;
  final ScheduleDayModel tuesday;
  final ScheduleDayModel wednesday;
  final ScheduleDayModel thursday;
  final ScheduleDayModel friday;
  final ScheduleDayModel saturday;
  final ScheduleDayModel sunday;

  ScheduleModel({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      monday: ScheduleDayModel.fromJson(json['monday'] ?? {}),
      tuesday: ScheduleDayModel.fromJson(json['tuesday'] ?? {}),
      wednesday: ScheduleDayModel.fromJson(json['wednesday'] ?? {}),
      thursday: ScheduleDayModel.fromJson(json['thursday'] ?? {}),
      friday: ScheduleDayModel.fromJson(json['friday'] ?? {}),
      saturday: ScheduleDayModel.fromJson(json['saturday'] ?? {}),
      sunday: ScheduleDayModel.fromJson(json['sunday'] ?? {}),
    );
  }

  List<ScheduleDayModel> get allDays => [
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
  ];
}
