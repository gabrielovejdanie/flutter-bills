import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  String currency;
  Timestamp from;
  String name;
  num nrOfPeople;
  int pricePerPerson;
  double pricePerUnit;
  num quantity;
  Timestamp to;
  int total;
  String unit;
  String id;

  Bill({
    required this.currency,
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
  });

  Bill.fromJson(Map<String, Object?> json)
      : this(
          currency: json['currency']! as String,
          from: json['from']! as Timestamp,
          name: json['name']! as String,
          nrOfPeople: json['nrOfPeople']! as num,
          pricePerPerson: json['pricePerPerson']! as int,
          pricePerUnit: json['pricePerUnit']! as double,
          quantity: json['quantity']! as num,
          to: json['to']! as Timestamp,
          total: json['total']! as int,
          unit: json['unit']! as String,
          id: json['id']! as String,
        );

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'from': from.millisecondsSinceEpoch, // Convert Timestamp to milliseconds
      'name': name,
      'nrOfPeople': nrOfPeople,
      'pricePerPerson': pricePerPerson,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
      'to': to.millisecondsSinceEpoch, // Convert Timestamp to milliseconds
      'total': total,
      'unit': unit,
      'id': id,
    };
  }

  Bill copyWith({
    String? currency,
    Timestamp? from,
    String? name,
    num? nrOfPeople,
    int? pricePerPerson,
    double? pricePerUnit,
    num? quantity,
    Timestamp? to,
    int? total,
    String? unit,
    String? id,
  }) {
    return Bill(
      currency: currency ?? this.currency,
      from: from ?? this.from,
      name: name ?? this.name,
      nrOfPeople: nrOfPeople ?? this.nrOfPeople,
      pricePerPerson: pricePerPerson ?? this.pricePerPerson,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      quantity: quantity ?? this.quantity,
      to: to ?? this.to,
      total: total ?? this.total,
      unit: unit ?? this.unit,
      id: id ?? this.id,
    );
  }
}
