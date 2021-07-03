import 'package:flutter/material.dart';
import 'package:whose_doc/variables/globalvar.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key key}) : super(key: key);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: global_color_6_blue,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
        ),
        title: Text(
          "Add New Payment",
        ),
      ),
      body: Container(),
    );
  }
}
