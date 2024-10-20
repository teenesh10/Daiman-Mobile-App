// loading_screen.dart
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

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

_checkLoginStatus() async {
    if (_isNavigating) return; // Prevent multiple navigations
    _isNavigating = true; // Set the flag

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        String? savedEmail = prefs.getString('userEmail');
        String? savedPassword = prefs.getString('userPassword');

        if (savedEmail != null && savedPassword != null) {
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: savedEmail, password: savedPassword);
            Navigator.pushReplacementNamed(context, "/home");
          } catch (e) {
            Navigator.pushReplacementNamed(context, "/login");
          }
        } else {
          Navigator.pushReplacementNamed(context, "/login");
        }
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
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
