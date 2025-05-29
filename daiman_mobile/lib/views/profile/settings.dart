import 'package:daiman_mobile/controllers/auth_controller.dart';
import 'package:daiman_mobile/views/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ListTile(
            title: const Text(
              "Delete Account",
              style: TextStyle(color: Colors.red),
            ),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => ConfirmationPopup(
                  title: "Are you sure you want to delete your account?",
                  confirmText: "Yes, Delete",
                  cancelText: "Cancel",
                  onConfirm: () async {
                    await _authController.deleteUserCompletely();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
