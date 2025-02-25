import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const PrimaryButton(this.text, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: callback,
      child: Text(
        text,
      ),
    );
  }
}
