import 'package:bills_calculator/models/bill.dart';
import 'package:flutter/material.dart';

class BillsProvider with ChangeNotifier {
  List<Bill> _bills = [];
  bool _loading = false;
  List<Bill> get bills => _bills;
  bool get loading => _loading;

  set bills(List<Bill> bills) {
    _bills = bills;
    notifyListeners();
  }

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}
