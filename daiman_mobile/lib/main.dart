import 'package:daiman_mobile/constants.dart';
import 'package:daiman_mobile/home_page.dart';
import 'package:daiman_mobile/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
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
          primaryColor: Constants.primaryColor,
          scaffoldBackgroundColor: Constants.bgColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.playfairDisplayTextTheme(),
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
          return const LoadingScreen(); // Show loading screen first
        });
      case "/home":
        return MaterialPageRoute(builder: (BuildContext context) {
          return const HomePage();
        });
      default:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const HomePage();
        });
    }
  }
}
