import 'package:flutter/material.dart';

const primaryDark = Color.fromRGBO(235, 193, 108, 1);
const primaryDarkBackground = Color.fromRGBO(23, 19, 11, 1);
const secondaryDarkBackground = Color.fromARGB(255, 57, 52, 43);
const ternaryDarkBackgroun = Color.fromRGBO(58, 71, 92, 1.000);
const secondaryDark = Color.fromRGBO(217, 196, 160, 1);
const onPrimaryDark = Color.fromRGBO(64, 45, 0, 1);
const primaryContainerDark = Color.fromRGBO(92, 66, 0, 1);
const onPrimaryContainerDark = Color.fromRGBO(38, 25, 0, 1);

const primaryLight = Color.fromRGBO(121, 89, 12, 1);
const primaryLightBackground = Color.fromRGBO(255, 248, 242, 1);
const secondaryLightBackground = Color.fromRGBO(235, 225, 212, 1);

class GlobalThemeVariables {
  static const double h1 = 18;
  static const double h2 = 16;
  static const double h3 = 14;
  static const double p = 12;
}

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        surface: primaryLightBackground, primary: primaryLight),
    fontFamily: "Montserrat",
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontSize: GlobalThemeVariables.h2,
          fontFamily: 'Alexandria',
          fontWeight: FontWeight.bold),
    ),
    cardTheme: const CardTheme(color: secondaryLightBackground));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        surface: primaryDarkBackground,
        primary: primaryDark,
        secondary: secondaryDark,
        onPrimary: onPrimaryDark,
        onPrimaryContainer: onPrimaryContainerDark),
    fontFamily: "Montserrat",
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontSize: GlobalThemeVariables.h2,
          fontFamily: 'Alexandria',
          fontWeight: FontWeight.bold),
    ),
    cardTheme: const CardTheme(color: secondaryDarkBackground));
