import 'package:flutter/material.dart';

class ConfirmationPopup extends StatelessWidget {
  final String title;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;

  const ConfirmationPopup({
    super.key,
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            onConfirm(); // Execute confirm action
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(confirmText, style: const TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
