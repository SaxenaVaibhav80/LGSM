import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF0F3433),     // Dark green from the app
      secondary: const Color(0xFFCEF03F),    // Lime accent color
      surface: Colors.white,   // Slight off-white background
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0F3433),
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0F3433),
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF0F3433),
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF0F3433),
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: const Color(0xFF0F3433),
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: const Color(0xFF0F3433),
      ),
    ),
    // Card theme
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
    ),
    // Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0F3433),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF0F3433)),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFFCEF03F),    // Lime accent becomes primary in dark mode
      secondary: const Color(0xFF0F3433),
      surface: const Color(0xFF1E1E1E),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
    // Card theme
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF1E1E1E),
    ),
    // Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCEF03F),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCEF03F)),
      ),
    ),
  );
}