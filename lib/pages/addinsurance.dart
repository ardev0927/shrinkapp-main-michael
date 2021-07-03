import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whose_doc/variables/globalvar.dart';
import 'package:intl/intl.dart';

class AddInsurance extends StatefulWidget {
  const AddInsurance({Key key}) : super(key: key);

  @override
  _AddInsuranceState createState() => _AddInsuranceState();
}

class _AddInsuranceState extends State<AddInsurance> {
  TextEditingController _policynumber_controller;
  TextEditingController _expirydate_controller;
  String _insurancecompany_value;
  String _insurancetype_value;

  @override
  void initState() {
    _policynumber_controller = TextEditingController();
    _expirydate_controller = TextEditingController();
    _insurancecompany_value = "Select Insurance Company";
    _insurancetype_value = "Select Insurance Type";
    super.initState();
  }

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
          "Add New Insurance",
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Insurance Company",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      Text(
                        " *",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                DropdownButton<String>(
                  value: _insurancecompany_value,
                  isExpanded: true,
                  icon: Row(
                    children: [
                      Transform.translate(
                        offset: Offset(0, -10),
                        child: Transform.rotate(
                          angle: -pi / 2,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: global_color_1_blue,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                  elevation: 16,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                  underline: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    height: 1,
                    color: Colors.grey,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      _insurancecompany_value = newValue;
                    });
                  },
                  items: <String>[
                    'Select Insurance Company',
                    'sample_2',
                    'sample_3',
                    'sample_4'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Insurance Type",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      Text(
                        " *",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                DropdownButton<String>(
                  value: _insurancetype_value,
                  isExpanded: true,
                  icon: Row(
                    children: [
                      Transform.translate(
                        offset: Offset(0, -10),
                        child: Transform.rotate(
                          angle: -pi / 2,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: global_color_1_blue,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                  elevation: 16,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                  underline: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    height: 1,
                    color: Colors.grey,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      _insurancetype_value = newValue;
                    });
                  },
                  items: <String>[
                    'Select Insurance Type',
                    'sample_2',
                    'sample_3',
                    'sample_4'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Policy Number",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      Text(
                        " *",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _policynumber_controller,
                    autofocus: false,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    decoration:
                        InputDecoration(hintText: "Enter Policy Number"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Expiry Date",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      Text(
                        " *",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    enabled: true,
                    controller: _expirydate_controller,
                    autofocus: false,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Select Expiry Date",
                      suffixIcon: IconButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          ).then((date) {
                            setState(() {
                              _expirydate_controller.text =
                                  DateFormat('dd.MM.yyyy').format(date);
                            });
                          });
                        },
                        icon: Icon(
                          Icons.calendar_today,
                          color: global_color_1_blue,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/insurancePage");
                    },
                    child: Text(
                      'Submit',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          return global_color_2_blue;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ))),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
