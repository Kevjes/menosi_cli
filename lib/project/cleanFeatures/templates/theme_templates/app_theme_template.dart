String appThemeTemplate() {
  return '''
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_font_sizes.dart';
import '../utils/app_colors.dart';

class AppThemes {
  static final TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: AppFontSizes.s32,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: AppFontSizes.s24,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: AppFontSizes.s16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: AppFontSizes.s14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: AppFontSizes.s12,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
  );

  static final TextTheme darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: AppFontSizes.s32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: AppFontSizes.s24,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: AppFontSizes.s24,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: AppFontSizes.s14,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    cardColor: Colors.white,
    iconTheme: const IconThemeData(color: AppColors.primary),
    canvasColor: Colors.white,
    brightness: Brightness.light,
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    radioTheme: const RadioThemeData(
        fillColor: WidgetStatePropertyAll(AppColors.primary)),
    primaryColor: AppColors.primary,
    textTheme: lightTextTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.primary,
        fontSize: AppFontSizes.s20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(color: Colors.white),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primary,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    textTheme: darkTextTheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: AppFontSizes.s20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}

''';
}
