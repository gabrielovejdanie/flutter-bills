import 'dart:convert';

import 'package:bills_calculator/basic_components/app_bar.dart';
import 'package:bills_calculator/basic_components/button.dart';
import 'package:bills_calculator/basic_components/bill_card.dart';
import 'package:bills_calculator/basic_components/floating_new_bill_button.dart';
import 'package:bills_calculator/core/auth.dart';
import 'package:bills_calculator/core/database_service.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/pages/add_bill_page.dart';
import 'package:bills_calculator/theme/bills_provider.dart';
import 'package:bills_calculator/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

String initialFilter = 'unpaid';
double totalOfSelected = 0;
double totalPerPerson = 0;

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  final User? user = Auth().currentUser;
  Future<void> _signOut() async {
    await Auth().signOut();
  }

  Widget _userEmail() {
    return Text(
      '${user?.email}',
      style: const TextStyle(fontSize: GlobalThemeVariables.p),
    );
  }

//  billsProvider.selectedBills
//                 .map((item) => BillCard(item))
//                 .toList()),
  Widget generateBillsWidget(BillsProvider billsProvider) {
    if (billsProvider.loading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else if (billsProvider.bills.isNotEmpty) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height / 1.55,
        child: RefreshIndicator(
          onRefresh: () {
            return _databaseService.getBills(context);
          },
          child: ListView(
              shrinkWrap: true,
              children:
                  billsProvider.selectedBills.map((e) => BillCard(e)).toList()),
        ),
      );
    } else {
      return const Center(child: Text('No Bills added'));
    }
  }

  @override
  void initState() {
    _databaseService.getBills(context).then((bills) {
      Provider.of<BillsProvider>(context, listen: false)
          .changeSelectedBills(initialFilter);
    });

    Provider.of<BillsProvider>(context, listen: false).addListener(() {
      List<Bill> bills =
          Provider.of<BillsProvider>(context, listen: false).selectedBills;
      setState(() {
        totalOfSelected = 0;
        totalPerPerson = 0;
        if (bills.isNotEmpty) {
          for (var i = 0; i < bills.length; i++) {
            totalOfSelected += bills[i].total;
          }
          totalPerPerson = totalOfSelected / bills[0].nrOfPeople;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar('Home Page'),
        drawer: Drawer(
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
            ],
          ),
        ),
        body: Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SegmentedButton(
                  segments: const [
                    ButtonSegment(
                        value: 'unpaid',
                        label: Text('Not Paid'),
                        enabled: true),
                    ButtonSegment(
                        value: 'paid', label: Text('Paid'), enabled: true),
                    ButtonSegment(
                        value: 'all', label: Text('All'), enabled: true)
                  ],
                  selected: {initialFilter},
                  onSelectionChanged: (newFilter) {
                    setState(() {
                      Provider.of<BillsProvider>(context, listen: false)
                          .changeSelectedBills(newFilter.first);
                      initialFilter = newFilter.first;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ${totalOfSelected.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: GlobalThemeVariables.h3),
                        ),
                        Text(
                          'Per person: ${totalPerPerson.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: GlobalThemeVariables.h3),
                        )
                      ]),
                ),
                Consumer<BillsProvider>(
                    builder: (context, billsProvider, child) {
                  return generateBillsWidget(billsProvider);
                })
              ],
            )),
        floatingActionButton: FloatingNewBillButton('New Bill', () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddBillFormPage()));
        }));
  }
}
