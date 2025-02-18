import 'package:bills_calculator/basic_components/app_bar.dart';
import 'package:flutter/material.dart';

class AddBillFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar('Add Bill'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Add Bill Form'),
          ],
        ),
      ),
    );
  }
}
