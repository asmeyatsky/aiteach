import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/config/app_colors.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.neonCyan,
    secondary: AppColors.neonBlue,
    tertiary: AppColors.neonPurple,
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: AppColors.background,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimary,
    onError: Colors.white,
    outline: AppColors.border,
  ),
  textTheme: GoogleFonts.spaceGroteskTextTheme(
    const TextTheme(
      displayLarge: TextStyle(color: AppColors.textPrimary),
      displayMedium: TextStyle(color: AppColors.textPrimary),
      displaySmall: TextStyle(color: AppColors.textPrimary),
      headlineLarge: TextStyle(color: AppColors.textPrimary),
      headlineMedium: TextStyle(color: AppColors.textPrimary),
      headlineSmall: TextStyle(color: AppColors.textPrimary),
      titleLarge: TextStyle(color: AppColors.textPrimary),
      titleMedium: TextStyle(color: AppColors.textPrimary),
      titleSmall: TextStyle(color: AppColors.textPrimary),
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textPrimary),
      bodySmall: TextStyle(color: AppColors.textSecondary),
      labelLarge: TextStyle(color: AppColors.textPrimary),
      labelMedium: TextStyle(color: AppColors.textSecondary),
      labelSmall: TextStyle(color: AppColors.textMuted),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textPrimary,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: GoogleFonts.spaceGrotesk(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.neonCyan,
    foregroundColor: AppColors.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.neonBlue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      textStyle: GoogleFonts.spaceGrotesk(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.neonCyan,
      textStyle: GoogleFonts.spaceGrotesk(
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.neonCyan,
      side: const BorderSide(color: AppColors.neonCyan),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.neonCyan, width: 2),
    ),
    labelStyle: const TextStyle(color: AppColors.textSecondary),
    hintStyle: const TextStyle(color: AppColors.textMuted),
    filled: true,
    fillColor: AppColors.surface,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.border),
    ),
    margin: const EdgeInsets.all(8),
  ),
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    textColor: AppColors.textPrimary,
    iconColor: AppColors.neonCyan,
  ),
  snackBarTheme: const SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.surfaceVariant,
    contentTextStyle: TextStyle(color: AppColors.textPrimary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.border,
  ),
  iconTheme: const IconThemeData(
    color: AppColors.textSecondary,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surfaceVariant,
    labelStyle: GoogleFonts.spaceGrotesk(color: AppColors.textPrimary),
    side: const BorderSide(color: AppColors.border),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.neonCyan,
    unselectedItemColor: AppColors.textMuted,
  ),
  navigationRailTheme: const NavigationRailThemeData(
    backgroundColor: AppColors.surface,
    selectedIconTheme: IconThemeData(color: AppColors.neonCyan),
    unselectedIconTheme: IconThemeData(color: AppColors.textMuted),
    selectedLabelTextStyle: TextStyle(color: AppColors.neonCyan),
    unselectedLabelTextStyle: TextStyle(color: AppColors.textMuted),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.neonCyan,
    linearTrackColor: AppColors.surfaceVariant,
  ),
  tabBarTheme: const TabBarThemeData(
    labelColor: AppColors.neonCyan,
    unselectedLabelColor: AppColors.textMuted,
    indicatorColor: AppColors.neonCyan,
  ),
);
