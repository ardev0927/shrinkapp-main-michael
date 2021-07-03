/*
import 'package:flutter/material.dart';
import 'package:whose_doc/functions/error_handles.dart';
import 'package:whose_doc/variables/globalvar.dart';
import 'package:whose_doc/functions/api_manager.dart';
import 'package:whose_doc/variables/models.dart';
import 'package:whose_doc/variables/routes.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List dataArr = [];
  bool _isLoadingCart;

  @override
  void initState() {
    super.initState();
    _isLoadingCart = true;
    checkProgress();
  }

  Future<void> checkProgress() async {
    List tempArr = [];
    tempArr = await getOrderHistory(context);
    extractCartItems(tempArr);
  }

  extractCartItems(List arr) {
    OrderDetails orderDetails;
    OrderLinks orderLinks;

    for (int i = 0; i < arr.length; i++) {
      List tempArr = [];
      orderDetails = arr[i];
      orderLinks = orderDetails.orderLinks;
      tempArr.add(orderDetails.id);
      tempArr.add(orderDetails.timestamp);
      tempArr.add();
      dataArr.add(tempArr);
    }
    setState(() {
      _isLoadingCart = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingCart
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text('Cart'),
              backgroundColor: Colors.blue,
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.height) * 0.70,
                      width: MediaQuery.of(context).size.width,
                      child: buildList(),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 120,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              ElevatedButton(
                                child: Text(
                                  'Orders',
                                  style: TextStyle(fontSize: 35),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: global_color_2_blue),
                                onPressed: () {}, //Missing Orders Function
                              ),
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width) * 0.1,
                              ),
                              ElevatedButton(
                                child: Text(
                                  'Recepits',
                                  style: TextStyle(fontSize: 35),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: global_color_2_blue),
                                onPressed: () {}, //Missing Recepits Function
                              ),
                            ],
                          )))
                ],
              ),
            ));
  }

  Widget buildList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: dataArr.length * 2,
        itemBuilder: (BuildContext context, int widgetIndex) {
          if (widgetIndex.isOdd) {
            return Divider(
                //color: Colors.transparent,
                );
          }

          final itemIndex = widgetIndex ~/ 2;

          if (itemIndex >= dataArr.length) {
            dataGenerator(itemIndex);
          }

          return buildRow(dataArr[itemIndex][0], dataArr[itemIndex][1],
              dataArr[itemIndex][2], dataArr[itemIndex][3]);
        });
  }

  dataGenerator(int index) {
    List arr = [];

    arr = dataArr[index];
    dataArr.add(arr);
  }

  Widget buildRow(
      String picURL, String proName, String proCost, int cartItemID) {
    return GestureDetector(
        onTap: () {}, //Tap function
        child: Container(
            height: (MediaQuery.of(context).size.height) * 0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: (MediaQuery.of(context).size.width) * 0.2,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                        height: (MediaQuery.of(context).size.height) * 0.9,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(picURL)))),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  width: (MediaQuery.of(context).size.width) * 0.55,
                  child: Text(proName, style: TextStyle(fontSize: 24.0)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: (MediaQuery.of(context).size.width) * 0.15,
                  child: Text(proCost, style: TextStyle(fontSize: 24.0)),
                ),
              ],
            )));
  }
}
*/