// GetX currently types GetMaterialApp.theme against Flutter Material's ThemeData.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF3F8FE),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2674CE)),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      shadowColor: const Color(0xFF1A4C7A).withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF3F8FE),
      foregroundColor: Color(0xFF20344D),
      centerTitle: false,
      elevation: 0,
    ),
  );
}
