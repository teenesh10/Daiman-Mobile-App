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
          primaryColor: primaryColor,
          scaffoldBackgroundColor: bgColor,
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
        initialRoute: "/loading",
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/loading":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const LoadingScreen();
        });
      case "/home":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const NavBar();
        });
      case "/login":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const LoginPage();
        });
      case "/register":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const RegisterPage();
        });
      case "/forgot_password":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const ForgotPasswordPage();
        });
      case "/profile":
        return MaterialPageRoute(builder: (BuildContext context) {
          return ProfilePage();
        });
      case "/booking":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const BookingPage();
        });
      case "/history":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const BookingHistoryPage();
        });
      case "/live":
        final args = settings.arguments as Map<String, dynamic>?;

        if (args == null ||
            !args.containsKey('facilityID') ||
            !args.containsKey('date')) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text("Invalid navigation parameters.")),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (context) => LiveAvailabilityPage(
            facilityID: args['facilityID'],
            date: args['date'],
          ),
        );
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
