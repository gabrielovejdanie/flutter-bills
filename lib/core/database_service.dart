import 'dart:convert';

import 'package:bills_calculator/core/auth.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/theme/bills_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const BILLS_COLLECTION_REF = 'billsPerUser';

class DatabaseService {
  var db = FirebaseFirestore.instance;
  final User? user = Auth().currentUser;
  late final CollectionReference _billsRef;
  DatabaseService() {
    // _billsRef = db
    //     .collection(BILLS_COLLECTION_REF)
    //     .where(FieldPath.documentId, isEqualTo: user?.uid)
    //     .withConverter<List<Bill>>(
    //         fromFirestore: (snapshots, _) =>
    //             parseJsonToBillsList(snapshots.data()),
    //         toFirestore: (bill, _) => parseBillsToJson(bill)).;
  }

  // List<Bill> parseJsonToBillsList(Map<String, dynamic>? json) {
  //   List<Bill> billsPerUser = [];
  //   return billsPerUser;
  // }

  // Map<String, dynamic> parseBillsToJson(List<Bill> bills) {
  //   Map<String, dynamic> billsPerUser = {'zero': 0, 'one': 1, 'two': 2};
  //   return billsPerUser;
  // }

  // Stream<QuerySnapshot> getBillsStream() {
  //   return _billsRef.snapshots();
  // }

  // void addBill(Bill bill) async {
  //   _billsRef.(bill);
  // }

  List<Bill> getBills(context) {
    List<Bill> billsPerUser = [];
    if (user?.uid != null) {
      db
          .collection(BILLS_COLLECTION_REF)
          .where(FieldPath.documentId, isEqualTo: user?.uid)
          .get()
          .then((event) {
        for (var doc in event.docs) {
          var allBillsPerUser = doc.data()['bills'];
          print(allBillsPerUser);
          for (var bill in allBillsPerUser) {
            Bill b = Bill.fromJson(bill);
            billsPerUser.add(b);
          }
        }
        Provider.of<BillsProvider>(context, listen: false).bills = billsPerUser;
      });
    }
    return billsPerUser;
  }

  void addBill(context, Bill bill) {
    List<Bill> oldBills = Provider.of<BillsProvider>(context).bills;
    oldBills.add(bill);

    db
        .collection("$BILLS_COLLECTION_REF/${user!.uid}")
        .add({"bills": jsonEncode(oldBills)}).then((event) {
      print(event);
    });
  }
}
