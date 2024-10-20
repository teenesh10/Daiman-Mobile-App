import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static const Color primaryColor = Colors.blueAccent;
  static const Color secondaryColor = Colors.red;
  static const Color bgColor = Colors.white;

  // Updated color for AppBar title
  static const Color appBarTitleColor = Colors.white;

  // Text styles with Google Fonts
  static final TextStyle headingStyle = GoogleFonts.lato(  // Updated font type
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,  // Primary color for heading text
  );

  static final TextStyle bodyTextStyle = GoogleFonts.lato(
    fontSize: 16,
    color: Colors.white,
  );

  static final TextStyle contactTextStyle = GoogleFonts.lato(
    fontSize: 16,
    color: Colors.grey,
  );

  // Button style
  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(vertical: 16),
    textStyle: GoogleFonts.lato(  // Button text style
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}
