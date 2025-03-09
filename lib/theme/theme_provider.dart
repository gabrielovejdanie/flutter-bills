import 'package:bills_calculator/core/secure_storage.dart';
import 'package:bills_calculator/theme/theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider() {
    SecureStore.read('theme').then((storedTheme) {
      if (storedTheme == 'dark') {
        themeData = darkMode;
      } else {
        themeData = lightMode;
      }
    });
  }
  ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      SecureStore.write('theme', 'dark');
    } else {
      themeData = lightMode;
      SecureStore.write('theme', 'light');
    }
  }
}
