// loading_screen.dart
import 'package:daiman_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    // Retrieve login details from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Attempt to log in with saved credentials
      String? savedEmail = prefs.getString('userEmail');
      String? savedPassword = prefs.getString('userPassword');

      if (savedEmail != null && savedPassword != null) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: savedEmail, password: savedPassword);
          Navigator.pushReplacementNamed(context, "/home");
        } catch (e) {
          // If login fails, navigate to login page
          Navigator.pushReplacementNamed(context, "/login");
        }
      } else {
        // No saved credentials, navigate to login page
        Navigator.pushReplacementNamed(context, "/login");
      }
    } else {
      // Not logged in and no shared preference data, navigate to login page
      Navigator.pushReplacementNamed(context, "/login");
    }

    _isNavigating = false; // Reset the flag after the operation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgColor,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 400.w,
          height: 400.h,
        ),
      ),
    );
  }
}
