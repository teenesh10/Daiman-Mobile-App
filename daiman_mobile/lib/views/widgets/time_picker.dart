// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class TimePickerSpinner extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;

  const TimePickerSpinner({required this.onTimeSelected, super.key});

  @override
  _TimePickerSpinnerState createState() => _TimePickerSpinnerState();
}

class _TimePickerSpinnerState extends State<TimePickerSpinner> {
  String _selectedPeriod = 'AM';
  int _selectedHour = 12;
  int _selectedMinute = 0;

  void _onTimeChange() {
    int hour = _selectedHour;
    if (_selectedPeriod == 'PM' && hour != 12) {
      hour += 12;
    } else if (_selectedPeriod == 'AM' && hour == 12) {
      hour = 0;
    }

    final timeOfDay = TimeOfDay(hour: hour, minute: _selectedMinute);
    widget.onTimeSelected(timeOfDay);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hour Picker
        DropdownButton<int>(
          value: _selectedHour,
          items: List.generate(12, (index) => index + 1)
              .map((hour) => DropdownMenuItem<int>(
                    value: hour,
                    child: Text(hour.toString().padLeft(2, '0')),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedHour = value!;
            });
            _onTimeChange();
          },
        ),
        const Text(" : "),
        // Minute Picker
        DropdownButton<int>(
          value: _selectedMinute,
          items: [0, 30]
              .map((minute) => DropdownMenuItem<int>(
                    value: minute,
                    child: Text(minute.toString().padLeft(2, '0')),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedMinute = value!;
            });
            _onTimeChange();
          },
        ),
        const SizedBox(width: 10),
        // AM/PM Picker
        DropdownButton<String>(
          value: _selectedPeriod,
          items: ['AM', 'PM']
              .map((period) => DropdownMenuItem<String>(
                    value: period,
                    child: Text(period),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedPeriod = value!;
            });
            _onTimeChange();
          },
        ),
      ],
    );
  }
}
