
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFFFF8E1), // Light Cream
    primaryColor: const Color(0xFFD7CCC8), // Soft Brown
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFBCAAA4), // Lighter Brown
      secondary: Color(0xFF8D6E63), // Darker Brown
      background: Color(0xFFFFF8E1), // Light Cream
      surface: Color(0xFFF5F5F5), // Off-white for cards
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onBackground: Colors.black,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFFD7CCC8), // Soft Brown
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF3E2723)), // Dark Brown
      bodyMedium: TextStyle(color: Color(0xFF3E2723)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF212121), // Dark Grey
    primaryColor: const Color(0xFF3E2723), // Dark Brown
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8D6E63), // Muted Brown
      secondary: Color(0xFFBCAAA4), // Lighter Brown
      background: Color(0xFF212121), // Dark Grey
      surface: Color(0xFF303030), // Slightly Lighter Grey for cards
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.white,
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF3E2723), // Dark Brown
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}
