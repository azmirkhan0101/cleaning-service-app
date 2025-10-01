import 'package:flutter/material.dart';

class HourMinuteDropdown extends StatefulWidget {
  const HourMinuteDropdown({Key? key}) : super(key: key);

  @override
  State<HourMinuteDropdown> createState() => _HourMinuteDropdownState();
}

class _HourMinuteDropdownState extends State<HourMinuteDropdown> {
  int? selectedHour;
  int? selectedMinute;

  final List<int> hours = List.generate(24, (i) => i); // 0–23
  final List<int> minutes = List.generate(12, (i) => i * 5); // 0, 5, 10…55

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hour dropdown
        DropdownButton<int>(
          hint: const Text("Hour"),
          value: selectedHour,
          items: hours
              .map((h) => DropdownMenuItem(
            value: h,
            child: Text(h.toString().padLeft(2, '0')),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedHour = value;
            });
          },
        ),
        const SizedBox(width: 20),

        // Minute dropdown
        DropdownButton<int>(
          hint: const Text("Minute"),
          value: selectedMinute,
          items: minutes
              .map((m) => DropdownMenuItem(
            value: m,
            child: Text(m.toString().padLeft(2, '0')),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedMinute = value;
            });
          },
        ),
      ],
    );
  }
}
