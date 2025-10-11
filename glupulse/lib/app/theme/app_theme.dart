import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor agar class ini tidak bisa diinstansiasi
  AppTheme._();

  // Definisikan warna utama
  static const Color _primaryColor = Color(0xFF242E49);
  static const Color inputFieldColor = Color(0xFFE0E0E0);
  static const Color inputLabelColor = Color(0xFF808B9B);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    // Tentukan skema warna utama aplikasi
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      primary: _primaryColor,
      brightness: Brightness.light,
    ),
    // Atur warna latar belakang default untuk Scaffold
    scaffoldBackgroundColor: Colors.white,
    // Atur tema untuk AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white, // Warna untuk judul dan ikon di AppBar
      elevation: 0,
      centerTitle: true,
    ),
  );
}