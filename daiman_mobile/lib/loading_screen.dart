// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'demo_mode.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    if (_isNavigating) return;
    _isNavigating = true;

    // Add a delay for the loading screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    // Check if demo mode is enabled
    bool isDemoMode = await DemoMode.isDemoMode();
    
    if (isDemoMode) {
      // Enable demo mode and go to home
      await DemoMode.enableDemoMode();
      Navigator.pushReplacementNamed(context, "/home");
      _isNavigating = false;
      return;
    }

    // Retrieve login details from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) {
      return;
    }

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }

    _isNavigating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200.w,
              height: 200.h,
              errorBuilder: (context, error, stackTrace) {
                return const Text('Image not found',
                    style: TextStyle(color: Colors.red));
              },
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
