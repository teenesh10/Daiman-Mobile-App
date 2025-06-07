import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Terms & Conditions",
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
            Text(
              "Welcome to Daiman Sports Booking App!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              "By using this app, you agree to the following terms and conditions:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            TermsBulletPoint(
                text:
                    "1. All bookings are subject to availability and must be made in advance."),
            TermsBulletPoint(
                text:
                    "2. Users must arrive at least 15 minutes before the scheduled booking time."),
            TermsBulletPoint(
                text:
                    "3. Booking Fees are non-refundable, except in circumstances where there is an occurrence of a technical glitch at no fault of the User."),
            TermsBulletPoint(
                text:
                    "4. Proper sports attire is required for all facility usage."),
            TermsBulletPoint(
                text:
                    "5. The facility reserves the right to cancel any booking due to unforeseen circumstances."),
            TermsBulletPoint(
                text:
                    "6. Users are responsible for any damage caused to the facility equipment."),
            TermsBulletPoint(text: "7. Bookings are non-transferable."),
            TermsBulletPoint(
                text:
                    "8. Misuse or abuse of the facilities may result in suspension or ban from future bookings."),
            SizedBox(height: 24),
            Text(
              "Thank you for using our app and following these guidelines to ensure a great experience for everyone!",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

class TermsBulletPoint extends StatelessWidget {
  final String text;
  const TermsBulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
