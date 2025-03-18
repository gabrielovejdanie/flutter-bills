import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Bill {
  String currency;
  Timestamp from;
  String name;
  double nrOfPeople;
  double pricePerPerson;
  double pricePerUnit;
  double quantity;
  Timestamp to;
  double total;
  String unit;
  String id;
  String month;
  bool isPaid;

  Bill(
      {required this.currency,
      required this.from,
      required this.name,
      required this.nrOfPeople,
      required this.pricePerPerson,
      required this.pricePerUnit,
      required this.quantity,
      required this.to,
      required this.total,
      required this.unit,
      required this.id,
      required this.isPaid,
      required this.month});

  Map<String, dynamic> toMap() {
    return {
      'currency': currency,
      'from': from.toDate(),
      'name': name,
      'nrOfPeople': nrOfPeople,
      'pricePerPerson': pricePerPerson,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
      'to': to.toDate(),
      'total': total,
      'unit': unit,
      'id': id,
      'isPaid': isPaid,
      'month': month,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'from': from,
      'name': name,
      'nrOfPeople': nrOfPeople,
      'pricePerPerson': pricePerPerson,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
      'to': to,
      'total': total,
      'unit': unit,
      'id': id,
      'isPaid': isPaid,
      'month': month,
    };
  }

  Bill.fromJson(Map<String, Object?> json)
      : this(
            currency: json['currency']! as String,
            from: json['from']! as Timestamp,
            name: json['name']! as String,
            nrOfPeople: (json['nrOfPeople'] != null)
                ? (json['nrOfPeople'] as num).toDouble()
                : 0.0,
            pricePerPerson:
                (json['pricePerPerson'] as num).toDouble().isInfinite
                    ? 0.0
                    : (json['pricePerPerson'] as num).toDouble(),
            pricePerUnit: (json['pricePerUnit'] as num).toDouble().isInfinite
                ? 0.0
                : (json['pricePerUnit'] as num).toDouble(),
            quantity: (json['quantity'] as num).toDouble(),
            to: json['to']! as Timestamp,
            total: (json['total'] as num).toDouble(),
            unit: json['unit']! as String,
            id: json['id']! as String,
            month: json['month']! as String,
            isPaid: json['isPaid'] as bool);

  Bill clone() {
    var uuid = const Uuid();

    return Bill(
      currency: this.currency,
      from: this.from,
      name: this.name,
      nrOfPeople: this.nrOfPeople,
      pricePerPerson: this.pricePerPerson,
      pricePerUnit: this.pricePerUnit,
      quantity: this.quantity,
      to: this.to,
      total: this.total,
      unit: this.unit,
      id: uuid.v4(),
      isPaid: false,
      month: this.month,
    );
  }
}
