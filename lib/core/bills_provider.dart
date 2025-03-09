import 'package:bills_calculator/models/bill.dart';
import 'package:flutter/material.dart';

class BillsProvider with ChangeNotifier {
  List<Bill> _bills = [];
  String _billsFilter = 'all';
  String _monthFilter = 'all';
  bool _loading = true;

  List<Bill> get bills => _bills;
  bool get loading => _loading;
  List<Bill> get selectedBills {
    if (_billsFilter == 'all') {
      return orderByDate(_bills);
    } else if (_billsFilter == 'paid') {
      return orderByDate(_bills.where((b) => b.isPaid).toList());
    } else if (_billsFilter == 'unpaid') {
      return orderByDate(_bills.where((b) => !b.isPaid).toList());
    } else {
      return orderByDate(_bills);
    }
  }

  List<Bill> get selectedBillsForMonth {
    if (_monthFilter == 'Filter by month') {
      return selectedBills;
    } else {
      return selectedBills.where((b) {
        return b.month == _monthFilter;
      }).toList();
    }
  }

  set bills(List<Bill> bills) {
    _bills = bills;
    notifyListeners();
  }

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  changeSelectedBills(filter) {
    _billsFilter = filter;
    notifyListeners();
  }

  changeMonthFilter(filter) {
    _monthFilter = filter;
    notifyListeners();
  }

  List<Bill> orderByDate(List<Bill> bills) {
    bills.sort((a, b) {
      return b.from.compareTo(a.from);
    });
    return bills;
  }
}
