import 'package:bills_calculator/basic_components/app_bar.dart';
import 'package:bills_calculator/basic_components/button.dart';
import 'package:bills_calculator/basic_components/drawer.dart';
import 'package:bills_calculator/basic_components/input.dart';
import 'package:bills_calculator/core/language_provider.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/models/months.dart';
import 'package:flutter/material.dart';
import 'package:bills_calculator/core/database_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditBillFormPage extends StatefulWidget {
  final Bill billToEdit;

  const EditBillFormPage({super.key, required this.billToEdit});

  @override
  State<EditBillFormPage> createState() => _EditBillFormPageState();
}

class _EditBillFormPageState extends State<EditBillFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _nrOfPeopleController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  Month selectedMonth = months.first;
  bool monthChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.billToEdit.name;
    _quantityController.text = widget.billToEdit.quantity.toStringAsFixed(0);
    _totalController.text = widget.billToEdit.total.toStringAsFixed(2);
    _unitController.text = widget.billToEdit.unit;
    _nrOfPeopleController.text =
        widget.billToEdit.nrOfPeople.toStringAsFixed(0);
    _currencyController.text = widget.billToEdit.currency;
  }

  void submitData() {
    if (_currencyController.text.isEmpty) {
      _currencyController.text = 'lei';
    }
    if (_totalController.text.isNotEmpty &&
        _nrOfPeopleController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      double pricePerPerson = double.parse(_totalController.text) /
          double.parse(_nrOfPeopleController.text);
      double pricePerUnit = double.parse(_totalController.text) /
          double.parse(_quantityController.text);
      var newBill = Bill(
          isPaid: widget.billToEdit.isPaid,
          name: _nameController.text,
          quantity: double.parse(_quantityController.text),
          total: double.parse(_totalController.text),
          nrOfPeople: double.parse(_nrOfPeopleController.text),
          currency: _currencyController.text,
          unit: _unitController.text,
          pricePerPerson: pricePerPerson,
          pricePerUnit: pricePerUnit,
          month: selectedMonth.name,
          from: selectedMonth.startDate,
          to: selectedMonth.endDate,
          id: widget.billToEdit.id);
      DatabaseService db = DatabaseService();
      db.updateBill(context, newBill);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Not enough information to update Bill!'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar('Edit Bill'),
        drawer: BillsDrawer(),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                BillsInput(
                  AppLocalizations.of(context)!.billName,
                  _nameController,
                  required: true,
                ),
                const SizedBox(height: 10),
                BillsInput(
                  AppLocalizations.of(context)!.totalValue,
                  _totalController,
                  numbersOnly: true,
                ),

                const SizedBox(height: 10),
                BillsInput(
                  AppLocalizations.of(context)!.numberOfPeople,
                  _nrOfPeopleController,
                  numbersOnly: true,
                ),
                const SizedBox(height: 10),
                BillsInput(
                  AppLocalizations.of(context)!.quantityOfUnits,
                  _quantityController,
                  numbersOnly: true,
                ),
                const SizedBox(height: 10),
                BillsInput(
                  AppLocalizations.of(context)!.unitOptional,
                  _unitController,
                ),
                const SizedBox(height: 10),
                BillsInput(
                  AppLocalizations.of(context)!.currencyOptional,
                  _currencyController,
                ),
                const SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.selectMonth),
                DropdownMenu<Month>(
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
                      setState(() {
                        selectedMonth = value;
                        monthChanged = true;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),

                // PrimaryButton('Select Bill time range', () async {
                //   final DateTimeRange? dateTimeRange =
                //       await showDateRangePicker(
                //           context: context,
                //           firstDate: DateTime(2000),
                //           lastDate: DateTime(3000));
                //   if (dateTimeRange != null) {
                //     print(dateTimeRange.duration.inDays);
                //     setState(() {
                //       selectedDates = dateTimeRange;
                //     });
                //   }
                // }),

                PrimaryButton(AppLocalizations.of(context)!.submit, () {
                  submitData();
                })
              ],
            ),
          ),
        ));
  }
}
