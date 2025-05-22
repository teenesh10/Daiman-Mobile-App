import 'package:daiman_mobile/constants.dart';
import 'package:daiman_mobile/controllers/auth_controller.dart';
import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/controllers/payment_controller.dart';
import 'package:daiman_mobile/loading_screen.dart';
import 'package:daiman_mobile/navbar.dart';
import 'package:daiman_mobile/views/auth/forgot_password.dart';
import 'package:daiman_mobile/views/auth/login.dart';
import 'package:daiman_mobile/views/auth/register.dart';
import 'package:daiman_mobile/views/booking/booking.dart';
import 'package:daiman_mobile/views/booking/booking_history.dart';
import 'package:daiman_mobile/views/booking/court_list.dart';
import 'package:daiman_mobile/views/booking/facility_list.dart';
import 'package:daiman_mobile/views/booking/live_availability.dart';
import 'package:daiman_mobile/views/chatbot/chatbot_screen.dart';
import 'package:daiman_mobile/views/chatbot/report_screen.dart';
import 'package:daiman_mobile/views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Ensure Firebase is initialized
  Stripe.publishableKey =
      'pk_test_51QXxohJMi70xUkuHjcec8DFEuYOLYPVY2DEX2PMZTfIvvon1FybbHJontUwhpVLkMl3PNkNfD5hLVD3eebxv7xKg00lLibZj4m'; 
  await Stripe.instance.applySettings();
  await AuthController().checkUserStatus();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookingController()),
        ChangeNotifierProvider(create: (context) => PaymentController()),
      ],
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
          return ProfilePage(); // Forgot password page
        });
      case "/booking":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const BookingPage(); // Forgot password page
        });
      case "/facilitylist":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const FacilityListPage(); // Forgot password page
        });
      case "/history":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const BookingHistoryPage(); // Forgot password page
        });
      case "/live":
        return MaterialPageRoute(builder: (BuildContext context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return LiveAvailabilityPage(facilityId: args['facilityId']);
        });
      case "/court":
        return MaterialPageRoute(builder: (BuildContext context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return CourtListPage(
            facilityID: args['facilityID'],
            date: args['date'],
            startTime: args['startTime'],
            duration: args['duration'],
          );
        });
      case "/chat":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const ChatScreen();
        });
      case "/report":
        return MaterialPageRoute(builder: (BuildContext context) {
          return ReportIssueScreen();
        });
      default:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const NavBar(); // Fallback to Home page
        });
    }
  }
}
