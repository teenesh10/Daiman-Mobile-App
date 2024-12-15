import 'package:flutter/material.dart';

class CourtTile extends StatelessWidget {
  final String courtName;
  final bool isSelected;
  final ValueChanged<bool?> onChanged; // Update to accept nullable bool

  const CourtTile({super.key, 
    required this.courtName,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isSelected,
        onChanged: onChanged, // Pass the nullable bool
      ),
      title: Text(courtName),
    );
  }
}
