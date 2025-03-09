import 'package:bills_calculator/core/language_provider.dart';
import 'package:bills_calculator/core/start_based_on_login.dart';
import 'package:bills_calculator/l10n/l10n.dart';
import 'package:bills_calculator/core/bills_provider.dart';
import 'package:bills_calculator/theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    if (kDebugMode) {
      print("Firebase Initialized");
    }
  });
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider(create: (context) => BillsProvider()),
    ChangeNotifierProvider(create: (context) => LanguageProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, settingsc});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const WidgetTree(),
      supportedLocales: L10n.all,
      locale: Provider.of<LanguageProvider>(context).locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
