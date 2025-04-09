import 'package:bills_calculator/core/auth.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/core/bills_provider.dart';
import 'package:bills_calculator/models/months.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const BILLS_COLLECTION_REF = 'billsPerUser';

class DatabaseService {
  var db = FirebaseFirestore.instance;
  final User? user = Auth().currentUser;
  late final CollectionReference _billsRef;

  Future<List<Bill>> getBills(context) {
    List<Bill> billsPerUser = [];
    print(user?.uid);
    if (user?.uid != null) {
      return db
          .collection(BILLS_COLLECTION_REF)
          .where(FieldPath.documentId, isEqualTo: user?.uid)
          .get()
          .then((event) {
        for (var doc in event.docs) {
          var allBillsPerUser = doc.data()['bills'];
          print('grabbed data ${allBillsPerUser.length}');
          for (var bill in allBillsPerUser) {
            Bill b = Bill.fromJson(bill);
            if (b.pricePerPerson.isInfinite) {
              b.pricePerPerson = 0;
              b.pricePerUnit = 0;
            }
            billsPerUser.add(b);
          }
        }

        billsPerUser = billsPerUser.reversed.toList();
        billsPerUser = updatePreviousMonthBills(billsPerUser);
        Provider.of<BillsProvider>(context, listen: false).bills = billsPerUser;
        Provider.of<BillsProvider>(context, listen: false).loading = false;
        return Future.value(billsPerUser);
      });
    }
    return Future.value(billsPerUser);
  }

  List<Bill> updatePreviousMonthBills(List<Bill> bills) {
    for (var i = 0; i < bills.length; i++) {
      Bill currentBill = bills[i];
      Month month = months
          .where((m) => (m.name == currentBill.month ||
              m.romanianName == currentBill.month))
          .first;
      Month prevMonth = months[month.index - 1];

      for (var j = 0; j < bills.length; j++) {
        Bill billToCompare = bills[j];
        Month monthToCompare = months
            .where((m) => (m.name == billToCompare.month ||
                m.romanianName == billToCompare.month))
            .first;

        if (billToCompare.name == currentBill.name &&
            monthToCompare.index == prevMonth.index) {
          currentBill.lastMonthDiff = currentBill.total - billToCompare.total;
        }
      }

      // //find prev bills that fit
      // List<Bill> sameNameBills =
      //     bills.where((b) => b.name == bills[i].name).toList();
      // for (var j = 0; j < sameNameBills.length; i++) {
      //   Bill snBill = sameNameBills[j];
      //   Month snMonth = months
      //       .where((m) =>
      //           (m.name == snBill.month || m.romanianName == snBill.month))
      //       .first;
      //   print(snBill.name + ' - ' + snMonth.name);
      //   if (snMonth.index == prevMonth.index) {
      //     currentBill.lastMonthDiff = snBill.total - currentBill.total;
      //   }
      // }
    }
    return bills;
  }

  findPrevBills(List<Bill> bills, Bill curentBill) {}

  void togglePaid(context, bill) {
    List<Bill> oldBills =
        Provider.of<BillsProvider>(context, listen: false).bills;
    int index = oldBills.indexWhere((b) => b.id == bill.id);
    if (index > -1) {
      oldBills[index].isPaid = !oldBills[index].isPaid;
      setBills(context, oldBills).then((v) {
        showSnackbar(context, 'Changes saved');
      }).onError((e, _) {
        showSnackbar(context, 'Error! $e');
      });
    }
  }

  void addBill(context, Bill bill) {
    List<Bill> oldBills =
        Provider.of<BillsProvider>(context, listen: false).bills;
    oldBills.add(bill);
    setBills(context, oldBills).then((v) {
      showSnackbar(context, 'Bill added!');
      Navigator.pop(context);
    }).onError((e, _) {
      showSnackbar(context, 'Error! $e');
    });
  }

  void removeBill(context, Bill bill) {
    List<Bill> oldBills =
        Provider.of<BillsProvider>(context, listen: false).bills;
    oldBills.removeWhere((b) => b.id == bill.id);
    setBills(context, oldBills).then((v) {
      showSnackbar(context, 'Bill removed!');
    }).onError((e, _) {
      showSnackbar(context, 'Error! $e');
    });
  }

  void updateBill(context, Bill bill) {
    List<Bill> oldBills =
        Provider.of<BillsProvider>(context, listen: false).bills;
    int index = oldBills.indexWhere((b) => b.id == bill.id);
    if (index > -1) {
      oldBills[index] = bill;
      setBills(context, oldBills).then((v) {
        showSnackbar(context, 'Changes saved!');
        Navigator.pop(context);
      }).onError((e, _) {
        showSnackbar(context, 'Error! $e');
      });
    }
  }

  Future<void> setBills(context, List<Bill> newBills) {
    Provider.of<BillsProvider>(context, listen: false).bills = newBills;
    return db.collection(BILLS_COLLECTION_REF).doc(user!.uid).set({
      "bills": newBills.map((item) {
        return item.toMap();
      }).toList()
    });
  }

  showSnackbar(context, String description) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(description),
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
