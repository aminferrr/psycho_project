import 'package:flutter/material.dart';

class AppTheme {
  // Базовый пастельно‑фиолетовый цвет
  static const Color _pastelPurple = Color(0xFFB39EB5);
  static const Color _pastelPurpleDark = Color(0xFF7E57C2);

  // Светлая тема (для всех пользователей)
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _pastelPurple,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F5FB),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFEDE7F6),
      foregroundColor: Color(0xFF3E2C4A),
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _pastelPurpleDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _pastelPurpleDark,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: _pastelPurpleDark,
      unselectedItemColor: Color(0xFF9E9E9E),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    ),
  );

  // Темная тема (опционально)
  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _pastelPurpleDark,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF1C1024),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF311B4B),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF2A163D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      elevation: 1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _pastelPurpleDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _pastelPurpleDark,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: _pastelPurple,
      unselectedItemColor: Color(0xFFBDBDBD),
      backgroundColor: Color(0xFF1F122C),
      type: BottomNavigationBarType.fixed,
    ),
  );
}