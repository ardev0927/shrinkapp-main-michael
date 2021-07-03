import 'dart:math';
import 'package:flutter/material.dart';
import 'package:whose_doc/functions/api_manager.dart';
import 'package:whose_doc/variables/globalvar.dart';
import 'package:whose_doc/variables/models.dart';
import 'package:whose_doc/variables/routes.dart';

class ReceiptSlide_Widget extends StatefulWidget {
  final ScrollController scrollController;
  final List receiptArr;
  final double totalAmt;
  const ReceiptSlide_Widget(
      {Key key,
      @required this.scrollController,
      @required this.receiptArr,
      @required this.totalAmt})
      : super(key: key);

  @override
  _ReceiptSlide_WidgetState createState() =>
      _ReceiptSlide_WidgetState(receiptArr, totalAmt);
}

class _ReceiptSlide_WidgetState extends State<ReceiptSlide_Widget> {
  List receiptArr;
  double totalAmt;
  _ReceiptSlide_WidgetState(this.receiptArr, this.totalAmt);
  Map<String, dynamic> _sample_data = {
    "date": "31 May 2021",
    "time": "8:30am",
    "type": "Teleconsult",
    "image": "assets/images/logo_1.png",
    "title": "Rails Family\nClinic & Surgery",
    "building": "Paragon Shopping Centre",
    "address": "290 Orchard Road",
    "country": "Singapore",
    "postalcode": "Singapore 229954",
    "phone": "+65 68832883",
    "favourit": true
  }; //TODO: adapt the data according to what you want to show

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.only(top: 20),
            width: _screen_size.width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    'Receipt',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: global_color_6_blue),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Issued By: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    Expanded(child: SizedBox()),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      _sample_data["image"],
                      width: 61,
                      height: 61,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _sample_data["title"],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          _sample_data["building"],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        Text(
                          _sample_data["address"],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        Text(
                          _sample_data["country"] +
                              ", " +
                              _sample_data["postalcode"],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              _sample_data["phone"],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: _screen_size.width * 0.35,
                            ),
                            Transform.translate(
                              offset: Offset(60, -5),
                              child: IconButton(
                                onPressed: () {},
                                icon: Transform.translate(
                                  offset: Offset(-20, 10),
                                  child: Transform.rotate(
                                    angle: pi / 2,
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: global_color_1_blue,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _sample_data["favourit"] =
                                !_sample_data["favourit"];
                          });
                        },
                        icon: Icon(
                          _sample_data["favourit"]
                              ? Icons.star
                              : Icons.star_border,
                          color: global_color_1_blue,
                          size: 35,
                        ))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    height: _screen_size.height * 0.35,
                    //width: _screen_size.width,
                    child: buildReceiptList(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: _screen_size.width - 30,
                        height: 40,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Subtotal",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                            Expanded(
                                child: SizedBox(
                              width: 10,
                            )),
                            Text(
                              r"$" + totalAmt.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: _screen_size.width - 30,
                        height: 40,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Delivery",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                            Expanded(
                                child: SizedBox(
                              width: 10,
                            )),
                            Text(
                              r"$5.00",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: _screen_size.width - 30,
                        height: 40,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Expanded(
                                child: SizedBox(
                              width: 10,
                            )),
                            Text(
                              r"$" + (totalAmt + 5).toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReceiptList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: receiptArr.length * 2,
        itemBuilder: (BuildContext context, int widgetIndex) {
          if (widgetIndex.isOdd) {
            return Divider(
              color: Colors.transparent,
            );
          }

          final itemIndex = widgetIndex ~/ 2;

          return buildRow(receiptArr[itemIndex][0], receiptArr[itemIndex][1],
              receiptArr[itemIndex][2], receiptArr[itemIndex][3]);
        });
  }

  Widget buildRow(String picURL, String proName, double proCost, int quantity) {
    return Container(
      color: Colors.white,
      height: 90,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Image.network(picURL),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proName,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r"$" + proCost.toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      'Qty:  ' + quantity.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
