import 'package:cleaning_service_app/features/common/controllers/time_picker_controller.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimePickerWidget extends StatefulWidget {
  // final OwnerServiceController ownerController;

  const TimePickerWidget({super.key, this.onTimeSelected});
  final void Function(TimeOfDay time)? onTimeSelected;

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  final TimePickerController timePickerController = Get.put(
    TimePickerController(),
  );

  final ServiceBookingController serviceBookingController = Get.find();

  late int _hour;
  late int _minute; // Will be 0 or 30
  late bool _isAM;

  @override
  void initState() {
    super.initState();
    // Initialize from controller or defaults
    // final currentTime =
    //     ownerController.selectedTime.value ??
    //     const TimeOfDay(hour: 1, minute: 30);
    // const TimeOfDay(hour: 1, minute: 30);
    final currentTime =
        timePickerController.selectedTime.value ??
        const TimeOfDay(hour: 1, minute: 30);

    _hour = currentTime.hourOfPeriod == 0 ? 12 : currentTime.hourOfPeriod;
    _minute = currentTime.minute >= 30 ? 30 : 0;
    _isAM = currentTime.period == DayPeriod.am;
  }

  void _updateTime() {
    // Convert to 24-hour format for TimeOfDay
    int hour24 = _hour == 12 ? (_isAM ? 0 : 12) : (_isAM ? _hour : _hour + 12);

    final hh = hour24.toString().padLeft(2, '0');
    final mm = _minute.toString().padLeft(2, '0');
    serviceBookingController.selectedTimeString.value = "$hh:$mm";
    print(serviceBookingController.selectedTimeString.value);

    timePickerController.setTime(TimeOfDay(hour: hour24, minute: _minute));
    widget.onTimeSelected?.call(TimeOfDay(hour: hour24, minute: _minute));
  }

  void _incrementHour() {
    setState(() {
      _hour = _hour == 12 ? 1 : _hour + 1;
      _updateTime();
    });
  }

  void _decrementHour() {
    setState(() {
      _hour = _hour == 1 ? 12 : _hour - 1;
      _updateTime();
    });
  }

  void _incrementMinute() {
    setState(() {
      if (_minute == 0) {
        _minute = 30;
      } else {
        // Minute goes from 30 to 00, so increment hour
        _minute = 0;
        _hour = _hour == 12 ? 1 : _hour + 1;
        // If hour wrapped from 12 to 1, toggle AM/PM
        if (_hour == 1) {
          _isAM = !_isAM;
        }
      }
      _updateTime();
    });
  }

  void _decrementMinute() {
    setState(() {
      if (_minute == 30) {
        _minute = 0;
      } else {
        // Minute goes from 00 to 30, so decrement hour
        _minute = 30;
        _hour = _hour == 1 ? 12 : _hour - 1;
        // If hour wrapped from 1 to 12, toggle AM/PM
        if (_hour == 12) {
          _isAM = !_isAM;
        }
      }
      _updateTime();
    });
  }

  void _togglePeriod() {
    setState(() {
      _isAM = !_isAM;
      _updateTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFE9EBF3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hour Picker
            _buildPickerColumn(
              value: _hour.toString().padLeft(2, '0'),
              onIncrement: _incrementHour,
              onDecrement: _decrementHour,
            ),

            // Colon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                  fontFamily: 'Roboto',
                ),
              ),
            ),

            // Minute Picker (30-minute intervals)
            _buildPickerColumn(
              value: _minute.toString().padLeft(2, '0'),
              onIncrement: _incrementMinute,
              onDecrement: _decrementMinute,
            ),

            const SizedBox(width: 32),

            // AM/PM Picker
            _buildPickerColumn(
              value: _isAM ? 'am' : 'pm',
              onIncrement: _togglePeriod,
              onDecrement: _togglePeriod,
              isText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerColumn({
    required String value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    bool isText = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up Arrow
        InkWell(
          onTap: onIncrement,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 16,
              color: const Color(0xFF0F0B18),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Value Display
        Container(
          width: isText ? 45 : 50,
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0F0B18),
              fontFamily: 'Poppins',
              height: 1.50,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Down Arrow
        InkWell(
          onTap: onDecrement,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: const Color(0xFF0F0B18),
            ),
          ),
        ),
      ],
    );
  }
}
