import 'package:flutter/material.dart';

class FloatingNewBillButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const FloatingNewBillButton(this.text, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: callback, label: Text(text), icon: const Icon(Icons.add));
  }
}
