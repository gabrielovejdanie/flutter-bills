import 'package:flutter/material.dart';

class BillCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final VoidCallback callback;

  const BillCard(this.title, this.subtitle, this.amount, this.callback,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: SizedBox(
        width: double.infinity,
        height: 130,
        child: Column(
          children: [
            Text(title),
            Text(subtitle),
            Text(amount),
          ],
        ),
      ),
    );
  }
}
