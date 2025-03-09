import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BillsInput extends StatelessWidget {
  final String title;
  final TextEditingController _controller;
  final bool autofocus;
  final bool numbersOnly;
  final bool required;

  const BillsInput(this.title, this._controller,
      {this.autofocus = false,
      this.numbersOnly = false,
      this.required = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      autofocus: autofocus,
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return '$title required';
              }
              return null;
            }
          : null,
      keyboardType: numbersOnly ? TextInputType.number : null,
      textInputAction: TextInputAction.next,
      decoration:
          InputDecoration(border: const OutlineInputBorder(), labelText: title),
      inputFormatters: numbersOnly
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null, // Only numbers can be entered
    );
  }
}
