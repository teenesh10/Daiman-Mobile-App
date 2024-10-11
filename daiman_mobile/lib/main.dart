import 'package:daiman_mobile/home_page.dart';
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
        title: 'Daiman',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 106, 8, 41),
          scaffoldBackgroundColor: const Color.fromRGBO(229, 229, 229, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.playfairDisplayTextTheme(),
        ),
        initialRoute: "/",
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

// We need to make an onGenerateRoute function to handle routing

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
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
