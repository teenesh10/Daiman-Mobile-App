import 'package:daiman_mobile/constants.dart';
import 'package:daiman_mobile/loading_screen.dart';
import 'package:daiman_mobile/navbar.dart';
import 'package:daiman_mobile/views/auth/forgot_password.dart';
import 'package:daiman_mobile/views/auth/login.dart';
import 'package:daiman_mobile/views/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Ensure Firebase is initialized
  runApp(const MyApp());
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
          textTheme: GoogleFonts.playfairDisplayTextTheme(),
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
      default:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const NavBar(); // Fallback to Home page
        });
    }
  }
}
