import 'package:cloud_firestore/cloud_firestore.dart';

class Month {
  final int index;
  final String name;
  final String romanianName;
  final Timestamp startDate;
  final Timestamp endDate;

  Month({
    required this.index,
    required this.name,
    required this.romanianName,
    required this.startDate,
    required this.endDate,
  });
}

List<Month> months = [
  Month(
      index: 0,
      name: 'Filter by month',
      romanianName: 'Selectează o lună',
      startDate: Timestamp.fromDate(DateTime.now()),
      endDate: Timestamp.fromDate(DateTime.now())),
  for (var i = 1; i <= 12; i++)
    Month(
      index: i,
      name: _monthNames[i - 1],
      romanianName: _romanianMonthNames[i - 1],
      startDate: Timestamp.fromDate(DateTime(DateTime.now().year, i, 1)),
      endDate: Timestamp.fromDate(DateTime(DateTime.now().year, i + 1, 0)),
    )
];

const List<String> _monthNames = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

const List<String> _romanianMonthNames = [
  "Ianuarie",
  "Februarie",
  "Martie",
  "Aprilie",
  "Mai",
  "Iunie",
  "Iulie",
  "August",
  "Septembrie",
  "Octombrie",
  "Noiembrie",
  "Decembrie"
];
