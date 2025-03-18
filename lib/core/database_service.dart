import 'package:bills_calculator/core/auth.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/core/bills_provider.dart';
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
            print(b.pricePerUnit);
            billsPerUser.add(b);
          }
        }

        billsPerUser = billsPerUser.reversed.toList();
        Provider.of<BillsProvider>(context, listen: false).bills = billsPerUser;
        Provider.of<BillsProvider>(context, listen: false).loading = false;
        return Future.value(billsPerUser);
      });
    }
    return Future.value(billsPerUser);
  }

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
