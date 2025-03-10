import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    brightness: Brightness.light, // Ajout pour éviter l'erreur
    primary: const Color(0xFFE57373),
    secondary: const Color(0xFFE86C74),
    tertiary: const Color(0xFFF1909C),
    errorContainer: const Color(0xFFEF4050),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark, // Ajout pour éviter l'erreur
    primary: const Color(0xFFE173FF),
    secondary: const Color(0xFF886CFF),
    tertiary: const Color(0xFF2190FF),
    errorContainer: const Color(0xFF3F50FF),
  ),
);
