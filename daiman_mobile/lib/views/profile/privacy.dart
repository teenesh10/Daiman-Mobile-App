import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            SizedBox(height: 16),
            Text(
              "This app collects user information such as name and email address for the purpose of managing facility bookings. We respect your privacy and ensure your data is not shared with third parties without your consent.",
            ),
            SizedBox(height: 12),
            Text(
              "All personal data is securely stored in Firebase services. You may request deletion of your account and data at any time via the Delete Account option in the Settings page.",
            ),
            SizedBox(height: 12),
            Text(
              "We do not collect sensitive information. Usage data may be collected anonymously for performance improvements.",
            ),
            SizedBox(height: 12),
            Text(
              "By using this app, you agree to this privacy policy.",
            ),
          ],
        ),
      ),
    );
  }
}
