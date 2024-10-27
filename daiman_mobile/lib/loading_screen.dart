// loading_screen.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart'; // Ensure to import your constants

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isNavigating = false; // Navigation lock

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    if (_isNavigating) return; // Prevent multiple navigations
    _isNavigating = true; // Set the flag

    // Add a delay for the loading screen
    await Future.delayed(const Duration(seconds: 2)); // Delay for 2 seconds

    // Check if the widget is still mounted before navigating
    if (!mounted) {
      return;
    }

    // Retrieve login details from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Check if the widget is still mounted before navigating
    if (!mounted) {
      return;
    }

    if (isLoggedIn) {
      // User is logged in, navigate to home page
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      // Not logged in, navigate to login page
      Navigator.pushReplacementNamed(context, "/login");
    }

    _isNavigating = false; // Reset the flag after the operation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Your logo asset
              width: 200.w,
              height: 200.h,
              errorBuilder: (context, error, stackTrace) {
                return const Text('Image not found',
                    style: TextStyle(color: Colors.red));
              },
            ),
            const SizedBox(
                height: 20), // Space between logo and loading indicator
            const CircularProgressIndicator(), // Loading indicator
          ],
        ),
      ),
    );
  }
}
