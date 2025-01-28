import 'package:flutter/material.dart';

class CourtTile extends StatelessWidget {
  final String courtName;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const CourtTile({
    super.key,
    required this.courtName,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(courtName),
      trailing: Checkbox(
        value: isSelected,
        onChanged: (bool? value) {
          if (value != null) {
            onChanged(value);
          }
        },
        activeColor: Colors.blue,
      ),
    );
  }
}
