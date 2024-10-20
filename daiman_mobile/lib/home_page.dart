import 'package:daiman_mobile/controllers/auth_controller.dart';
import 'package:daiman_mobile/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sports Facility Booking',
          style: GoogleFonts.lato(  // Apply custom font to AppBar title
            color: Constants.appBarTitleColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Constants.primaryColor,  // Use primary color for the AppBar background
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to the Sports Facility Booking App!',
              style: Constants.headingStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'View Facilities',
              onPressed: () {
                // Navigate to view facilities
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Make a Booking',
              onPressed: () {
                // Navigate to make a booking
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'My Profile',
              onPressed: () {
                // Navigate to user profile
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Logout',
              onPressed: () async {
                // Call the logout function from AuthController
                AuthController authController = AuthController();
                await authController.logout();

                // Navigate to the loading screen or login page
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Contact us: support@example.com',
              style: Constants.contactTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
