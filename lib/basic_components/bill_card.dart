import 'package:bills_calculator/basic_components/button.dart';
import 'package:bills_calculator/core/database_service.dart';
import 'package:bills_calculator/core/language_provider.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/models/months.dart';
import 'package:bills_calculator/pages/edit_bill_page.dart';
import 'package:bills_calculator/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BillCard extends StatelessWidget {
  final Bill bill;

  String getMonth(context, String name) {
    Locale locale =
        Provider.of<LanguageProvider>(context, listen: false).locale;
    if (locale == const Locale('ro')) {
      return months
          .firstWhere((m) => (m.name == name) || m.romanianName == name)
          .romanianName;
    } else {
      return months
          .firstWhere((m) => (m.name == name) || m.romanianName == name)
          .name;
    }
  }

  String parseLastMonth(double lastMonthDiff) {
    if (lastMonthDiff == 0) {
      return '0';
    } else if (lastMonthDiff > 0) {
      return '+${lastMonthDiff.toStringAsFixed(2)}';
    } else {
      return lastMonthDiff.toStringAsFixed(2);
    }
  }

  const BillCard(this.bill, {super.key});

  @override
  Widget build(BuildContext context) {
    if (bill.unit.isEmpty) {
      bill.unit = 'unit';
    }
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 2, 6, 16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                          '${bill.name} - ${getMonth(context, bill.month)} ${bill.from.toDate().year}',
                          style: const TextStyle(
                              fontSize: GlobalThemeVariables.h2,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 35,
                        child: IconButton(
                            iconSize: GlobalThemeVariables.h2,
                            onPressed: () {
                              DatabaseService db = DatabaseService();
                              db.removeBill(context, bill);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ),
                      SizedBox(
                          width: 35,
                          child: IconButton(
                              iconSize: GlobalThemeVariables.h1,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditBillFormPage(
                                            billToEdit: bill)));
                              },
                              icon: const Icon(
                                Icons.edit,
                              )))
                    ],
                  ),
                ],
              ),
              Text('Total: ${bill.total.toStringAsFixed(2)} ${bill.currency}'),
              bill.quantity.toStringAsFixed(0) != '0'
                  ? Text(
                      '${AppLocalizations.of(context)!.quantity}${bill.quantity.toStringAsFixed(0)}')
                  : Container(),
              bill.quantity.toStringAsFixed(0) != '0'
                  ? Text(
                      '${AppLocalizations.of(context)!.pricePerUnit(bill.unit)}${bill.pricePerUnit.toStringAsFixed(2)} ${bill.currency}')
                  : Container(),
              Text(
                  '${AppLocalizations.of(context)!.nrOfPeople}${bill.nrOfPeople.toStringAsFixed(0)}'),
              Text(
                  '${AppLocalizations.of(context)!.pricePerPerson}${bill.pricePerPerson.toStringAsFixed(2)} ${bill.currency}'),
              bill.lastMonthDiff == null
                  ? Container()
                  : Text(
                      '${AppLocalizations.of(context)!.lastMonthDiff}${parseLastMonth(bill.lastMonthDiff ?? 0)} ${bill.currency}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  !bill.isPaid
                      ? PrimaryButton(AppLocalizations.of(context)!.setToPaid,
                          () {
                          DatabaseService db = DatabaseService();
                          db.togglePaid(context, bill);
                        })
                      : Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
