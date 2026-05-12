import 'package:flutter/material.dart';

class AppColors {
  // Dark theme (SplashScreen)
  static const darkNavy = Color(0xFF0B1E3D);
  static const navyBlue = Color(0xFF142B52);
  static const primaryBlue = Color(0xFF2D60E8);
  static const lightBlue = Color(0xFF4A7CF7);
  static const emergencyRed = Color(0xFFE53935);
  static const successGreen = Color(0xFF43A047);
  static const warningOrange = Color(0xFFFB8C00);
  static const normalTag = Color(0xFF43A047);
  static const riskTag = Color(0xFFE53935);
  static const attentionTag = Color(0xFFFB8C00);
  static const cardWhite = Color(0xFFFFFFFF);
  static const textOnDark = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0C4DE);
  static const divider = Color(0xFF1E3A6E);

  // Light theme
  static const lightBackground = Color(0xFFF0F4F8);
  static const lightCard = Colors.white;
  static const lightText = Color(0xFF1A2340);
  static const lightTextSecondary = Color(0xFF64748B);
  static const lightDivider = Color(0xFFE2E8F0);
  static const lightNavBar = Colors.white;
  static const lightInputFill = Color(0xFFF8FAFC);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryBlue,
          surface: AppColors.lightCard,
          onSurface: AppColors.lightText,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightCard,
          foregroundColor: AppColors.lightText,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightInputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightDivider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightDivider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
          ),
          labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
          hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryBlue,
          surface: AppColors.navyBlue,
          onSurface: AppColors.textOnDark,
        ),
        scaffoldBackgroundColor: AppColors.darkNavy,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navyBlue,
          foregroundColor: AppColors.textOnDark,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.navyBlue,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
          ),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          hintStyle: const TextStyle(color: AppColors.textSecondary),
        ),
      );
}
