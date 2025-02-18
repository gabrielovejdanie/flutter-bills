import 'package:flutter/material.dart';

const primary = Color.fromRGBO(195, 112, 75, 1);
const primaryDarkBackground = Color.fromRGBO(28, 34, 44, 1);
const secondaryDarkBackground = Color(0xFF303A4B);
const ternaryDarkBackgroun = Color.fromRGBO(58, 71, 92, 1.000);

const primaryLightBackground = Color.fromRGBO(251, 245, 243, 1);
const secondaryLightBackground = Color.fromRGBO(239, 214, 206, 1);

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        surface: primaryLightBackground, primary: primary),
    fontFamily: "Montserrat",
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontSize: 16, fontFamily: 'Alexandria', fontWeight: FontWeight.bold),
    ),
    cardTheme: const CardTheme(color: secondaryLightBackground));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        surface: primaryDarkBackground, primary: primary),
    fontFamily: "Montserrat",
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontSize: 16, fontFamily: 'Alexandria', fontWeight: FontWeight.bold),
    ),
    cardTheme: const CardTheme(color: secondaryDarkBackground));
