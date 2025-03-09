import 'package:bills_calculator/core/secure_storage.dart';
import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  LanguageProvider() {
    SecureStore.read('locale').then((storedLocale) {
      if (storedLocale != null) {
        locale = Locale(storedLocale);
      } else {
        locale = const Locale('ro');
      }
    });
  }
  Locale _locale = const Locale('ro');

  Locale get locale => _locale;

  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  toggleEnRo() {
    if (locale == const Locale('ro')) {
      locale = const Locale('en');
      SecureStore.write('locale', 'en');
    } else if (locale == const Locale('en')) {
      locale = const Locale('ro');
      SecureStore.write('locale', 'ro');
    }
  }
}
