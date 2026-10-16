import 'package:flutter/material.dart';

abstract final class StudyColors {
  static const paper = Color(0xFFF3F0E8);
  static const frame = Color(0xFFE4E0D6);
  static const card = Color(0xFFFFFCF7);
  static const ink = Color(0xFF1B2430);
  static const muted = Color(0xFF5C6570);
  static const line = Color(0xFFD5CFC3);
  static const green = Color(0xFF0F6A4A);
  static const greenDark = Color(0xFF0A4A34);
  static const clay = Color(0xFF8E3B2E);
  static const night = Color(0xFF1B2430);
  static const disabled = Color(0xFFD9D3C7);
  static const disabledInk = Color(0xFF6B655C);
}

ThemeData buildStudyTheme() {
  const ink = StudyColors.ink;
  const text = TextTheme(
    headlineMedium: TextStyle(
      fontSize: 34,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: ink,
    ),
    titleLarge: TextStyle(
      fontSize: 28,
      height: 1.25,
      fontWeight: FontWeight.w700,
      color: ink,
    ),
    bodyLarge: TextStyle(fontSize: 22, height: 1.45, color: ink),
    bodyMedium: TextStyle(fontSize: 20, height: 1.4, color: ink),
    labelLarge: TextStyle(
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: ink,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'AtkinsonHyperlegible',
    scaffoldBackgroundColor: StudyColors.paper,
    colorScheme: const ColorScheme.light(
      primary: StudyColors.green,
      onPrimary: Colors.white,
      surface: StudyColors.card,
      onSurface: ink,
    ),
    textTheme: text,
    primaryTextTheme: text,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      labelStyle: text.bodyLarge?.copyWith(color: StudyColors.muted),
      hintStyle: text.bodyLarge?.copyWith(color: StudyColors.muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: StudyColors.line, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: StudyColors.line, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: StudyColors.green, width: 3),
      ),
    ),
  );
}
