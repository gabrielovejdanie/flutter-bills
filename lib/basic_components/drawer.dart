import 'package:bills_calculator/basic_components/button.dart';
import 'package:bills_calculator/core/auth.dart';
import 'package:bills_calculator/core/language_provider.dart';
import 'package:bills_calculator/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillsDrawer extends StatefulWidget {
  const BillsDrawer({super.key});

  @override
  _BillsDrawerState createState() => _BillsDrawerState();
}

final User? user = Auth().currentUser;

class _BillsDrawerState extends State<BillsDrawer> {
  Widget _userEmail() {
    return Text(
      '${user?.email}',
      style: const TextStyle(fontSize: GlobalThemeVariables.p),
    );
  }

  Future<void> _signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text('Settings'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  _userEmail(),
                  PrimaryButton('Sign Out', _signOut),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton(
              segments: const [
                ButtonSegment(
                    value: Locale('ro'),
                    label: Text(
                      'RO',
                    ),
                    enabled: true),
                ButtonSegment(
                    value: Locale('en'), label: Text('EN'), enabled: true),
              ],
              selected: {
                Provider.of<LanguageProvider>(context, listen: false).locale
              },
              onSelectionChanged: (newFilter) {
                Provider.of<LanguageProvider>(context, listen: false).locale =
                    newFilter.first;
              },
            ),
          ),
        ],
      ),
    );
  }
}
