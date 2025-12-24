/// Model for individual time slot
class TimeSlotModel {
  final String time;
  final bool available;

  TimeSlotModel({required this.time, required this.available});

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      time: json['time'] ?? '',
      available: json['available'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'time': time, 'available': available};
  }
}

/// Model for working hours
class WorkingHoursModel {
  final String startTime;
  final String endTime;

  WorkingHoursModel({required this.startTime, required this.endTime});

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'startTime': startTime, 'endTime': endTime};
  }
}

/// Model for available slots response
class AvailableSlotsModel {
  final String date;
  final String day;
  final bool isAvailable;
  final WorkingHoursModel workingHours;
  final List<TimeSlotModel> slots;

  AvailableSlotsModel({
    required this.date,
    required this.day,
    required this.isAvailable,
    required this.workingHours,
    required this.slots,
  });

  factory AvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    return AvailableSlotsModel(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      workingHours: WorkingHoursModel.fromJson(json['workingHours'] ?? {}),
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((slot) => TimeSlotModel.fromJson(slot))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day': day,
      'isAvailable': isAvailable,
      'workingHours': workingHours.toJson(),
      'slots': slots.map((slot) => slot.toJson()).toList(),
    };
  }
}
