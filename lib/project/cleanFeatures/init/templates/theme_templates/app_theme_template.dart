String appThemeTemplate() {
  return '''
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';

class AppThemes {
  static final TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: AppDimensions.fontSizeExtraLarge,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: AppDimensions.fontSizeLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: AppDimensions.fontSizeMedium,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: AppDimensions.fontSizeSmall,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: AppDimensions.fontSizeExtraSmall,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
  );

  static final TextTheme darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: AppDimensions.fontSizeExtraLarge,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: AppDimensions.fontSizeLarge,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: AppDimensions.fontSizeMedium,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: AppDimensions.fontSizeSmall,
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
        fontSize: AppDimensions.fontSizeLarge,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: const CardTheme(color: Colors.white),
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
        fontSize: AppDimensions.fontSizeLarge,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}


''';
}
