import 'package:daiman_mobile/constants.dart';
import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/loading_screen.dart';
import 'package:daiman_mobile/navbar.dart';
import 'package:daiman_mobile/views/auth/forgot_password.dart';
import 'package:daiman_mobile/views/auth/login.dart';
import 'package:daiman_mobile/views/auth/register.dart';
import 'package:daiman_mobile/views/booking/booking.dart';
import 'package:daiman_mobile/views/booking/facility_list.dart';
import 'package:daiman_mobile/views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Ensure Firebase is initialized
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookingController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Daiman Sports',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Constants.primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.bold),
            displayMedium: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.bold),
            displaySmall: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.normal),
            bodyMedium: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.normal),
            labelLarge: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
        initialRoute: "/loading", // Default route when app starts
        onGenerateRoute: _onGenerateRoute, // Dynamic route generation
      ),
    );
  }

  // Define your routes here
  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/loading":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const LoadingScreen(); // Show loading screen first
        });
      case "/home":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const NavBar(); // Home screen
        });
      case "/login":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const LoginPage(); // Login page
        });
      case "/register":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const RegisterPage(); // Register page
        });
      case "/forgot_password":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const ForgotPasswordPage(); // Forgot password page
        });
      case "/profile":
        return MaterialPageRoute(builder: (BuildContext context) {
          return  ProfilePage(); // Forgot password page
        });
      case "/booking":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const BookingPage(); // Forgot password page
        });
      case "/facilitylist":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const FacilityListPage(); // Forgot password page
        });
      default:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const NavBar(); // Fallback to Home page
        });
    }
  }
}
