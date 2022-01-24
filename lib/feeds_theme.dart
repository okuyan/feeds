import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedsTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
        fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.black),
    bodyText2: GoogleFonts.openSans(
        fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black),
    subtitle1: GoogleFonts.openSans(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
    subtitle2: GoogleFonts.openSans(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
    headline1: GoogleFonts.openSans(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
    headline2: GoogleFonts.openSans(
        fontSize: 21.0, fontWeight: FontWeight.w700, color: Colors.black),
    headline3: GoogleFonts.openSans(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
        fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.white),
    subtitle1: GoogleFonts.openSans(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
    subtitle2: GoogleFonts.openSans(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline1: GoogleFonts.openSans(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline2: GoogleFonts.openSans(
        fontSize: 21.0, fontWeight: FontWeight.w700, color: Colors.white),
    headline3: GoogleFonts.openSans(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
  );

  static light() {
    return ThemeData(
      canvasColor: const Color.fromRGBO(227, 225, 224, 1.0),
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.purple,
        secondary: Colors.purpleAccent,
        brightness: Brightness.light,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Colors.green,
      ),
      textTheme: lightTextTheme,
    );
  }

  static dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.purple,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.purple[300],
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.purple,
        secondary: Colors.purpleAccent,
        brightness: Brightness.dark,
      ),
      textTheme: darkTextTheme,
    );
  }
}
