import 'package:bills_calculator/basic_components/button.dart';
import 'package:bills_calculator/core/database_service.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/pages/edit_bill_page.dart';
import 'package:bills_calculator/theme/theme.dart';
import 'package:flutter/material.dart';

class BillCard extends StatelessWidget {
  final Bill bill;

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
                          '${bill.name} - ${bill.month} ${bill.from.toDate().year}',
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
              Text('Total: ${bill.total.toStringAsFixed(2)}'),
              Text('Quantity: ${bill.quantity.toStringAsFixed(0)}'),
              Text(
                  'Price per ${bill.unit}: ${bill.pricePerUnit.toStringAsFixed(2)}'),
              Text('Nr. of people: ${bill.nrOfPeople.toStringAsFixed(0)}'),
              Text(
                  'Price per person: ${bill.pricePerPerson.toStringAsFixed(2)}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !bill.isPaid
                      ? PrimaryButton('Set to paid', () {
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
