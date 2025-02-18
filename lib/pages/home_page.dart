import 'dart:convert';

import 'package:bills_calculator/basic_components/app_bar.dart';
import 'package:bills_calculator/basic_components/button.dart';
import 'package:bills_calculator/basic_components/bill_card.dart';
import 'package:bills_calculator/basic_components/floating_new_bill_button.dart';
import 'package:bills_calculator/core/auth.dart';
import 'package:bills_calculator/core/database_service.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/pages/add_bill_form.dart';
import 'package:bills_calculator/theme/bills_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final DatabaseService _databaseService = DatabaseService();
  final User? user = Auth().currentUser;

  Future<void> _signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Home Page');
  }

  Widget _userEmail() {
    return Text(
      '${user?.email}',
      style: const TextStyle(fontSize: 12),
    );
  }

  Widget generateBillsWidget(List<Bill> bills) {
    return Column(
        children: bills
            .map((item) => BillCard(
                item.name,
                'Total: ${item.total} ${item.currency}',
                '${item.quantity} ${item.unit}',
                () {}))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    _databaseService.getBills(context);
    return Scaffold(
        appBar: const CustomAppBar('Home Page'),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      _userEmail(),
                      PrimaryButton('Sign Out', _signOut),
                    ]),
                Consumer<BillsProvider>(builder: (context, bills, child) {
                  print(bills.bills);
                  if (bills.bills.isNotEmpty) {
                    return generateBillsWidget(bills.bills);
                  } else {
                    return const Text('No Bills added');
                  }
                })
              ],
            )),
        floatingActionButton: FloatingNewBillButton('New Bill', () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddBillFormPage()));
        }));
  }
}
