import 'dart:convert';

import 'package:bills_calculator/basic_components/app_bar.dart';
import 'package:bills_calculator/basic_components/button.dart';
import 'package:bills_calculator/basic_components/drawer.dart';
import 'package:bills_calculator/basic_components/input.dart';
import 'package:bills_calculator/core/database_service.dart';
import 'package:bills_calculator/core/language_provider.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/models/months.dart';
import 'package:bills_calculator/core/bills_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExistingBill {
  final String name;
  final double total;
  final String month;
  final TextEditingController monthController;
  final TextEditingController totalController;
  ExistingBill(this.name, this.total, this.month, this.monthController,
      this.totalController);
}

class ExistingBillsPage extends StatefulWidget {
  const ExistingBillsPage({super.key});

  @override
  State<ExistingBillsPage> createState() => _ExistingBillsPageState();
}

class _ExistingBillsPageState extends State<ExistingBillsPage> {
  final existingBills = [];
  List<Bill> clonedBills = [];

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    List<Bill> bills = Provider.of<BillsProvider>(context).billsToEdit;
    // Cloning the array
    clonedBills = bills.map((person) => person.clone()).toList();
    bills.map((bill) {
      existingBills.add(ExistingBill(bill.name, bill.total, bill.month,
          TextEditingController(), TextEditingController()));
    }).toList();
  }

  List<Widget> buildBills() {
    List<Bill> bills = Provider.of<BillsProvider>(context).billsToEdit;
    return bills.asMap().entries.map((bill) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${bill.value.name} - ${bill.value.month}',
            style: const TextStyle(fontSize: 20)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: DropdownMenu<Month>(
            expandedInsets: EdgeInsets.zero,
            initialSelection: months.first,
            dropdownMenuEntries: months.map((Month month) {
              return DropdownMenuEntry<Month>(
                value: month,
                label: Provider.of<LanguageProvider>(context).locale ==
                        const Locale('ro')
                    ? month.romanianName
                    : month.name,
              );
            }).toList(),
            onSelected: (value) {
              if (value != null) {
                Locale locale =
                    Provider.of<LanguageProvider>(context, listen: false)
                        .locale;
                if (locale == const Locale('ro')) {
                  updateMonth(bill.value.name, value.romanianName);
                } else {
                  updateMonth(bill.value.name, value.name);
                }
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: BillsInput(
            'New total',
            existingBills[bill.key].totalController,
            required: true,
          ),
        ),
        const Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5), child: Divider())
      ]);
    }).toList();
  }

  void submitData() {
    if (this.existingBills.any((b) => b.totalController.text.isEmpty)) {
      showSnackbar(context, 'Please fill in all the fields');
    } else {
      for (var i = 0; i < clonedBills.length; i++) {
        clonedBills[i].total =
            double.parse(existingBills[i].totalController.text);
        Provider.of<BillsProvider>(context, listen: false)
            .bills
            .add(clonedBills[i]);
      }

      DatabaseService()
          .setBills(
              context, Provider.of<BillsProvider>(context, listen: false).bills)
          .then((v) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        showSnackbar(context, 'Changes saved');
      }).onError((e, _) {
        showSnackbar(context, 'Error! $e');
      });
    }
  }

  showSnackbar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  updateMonth(billName, month) {
    clonedBills = clonedBills.map((bill) {
      if (bill.name == billName) {
        bill.month = month;
      }
      return bill;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(AppLocalizations.of(context)!.addBillTitle),
        drawer: BillsDrawer(),
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height - 100,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: buildBills(),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            label: const Text('Save'),
            icon: const Icon(Icons.save),
            onPressed: () {
              submitData();
            }));
  }
}
