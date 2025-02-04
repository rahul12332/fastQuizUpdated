import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'contant/appColor.dart';

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: AppColor.theme,
      scaffoldBackgroundColor: AppColor.pistelGray,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.theme,
        titleTextStyle: GoogleFonts.acme(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColor.buttonColor,
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.aclonica(
          color: AppColor.textColor,
          letterSpacing: 1,
        ),
        bodyMedium: GoogleFonts.acme(
          fontSize: 16,
          color: AppColor.textColor,
        ),
      ),
    );
  }
}
