import 'package:flutter/material.dart';
import 'package:whose_doc/variables/globalvar.dart';
import 'package:whose_doc/functions/api_manager.dart';
import 'package:whose_doc/variables/models.dart';
import 'package:whose_doc/pages/receiptdetails.dart';

class ReceiptList extends StatefulWidget {
  const ReceiptList({Key key}) : super(key: key);

  @override
  _ReceiptListState createState() => _ReceiptListState();
}

class _ReceiptListState extends State<ReceiptList> {
  List receiptArr = [];
  int currentPage = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkProgress();
  }

  checkProgress() async {
    currentPage = await getMetaReceiptInfo(context);
    _isLoading = true;
    await extractBasicReceiptInfo();
    currentPage -= 1;
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? Scaffold(
            backgroundColor: global_color_8_white,
            appBar: AppBar(
              backgroundColor: global_color_6_blue,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              title: Text(
                "Receipts",
              ),
            ),
            body: Column(
              children: [
                Container(
                  height: totalHeight * 0.1,
                  width: totalWidth * 1,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: global_color_8_white,
            appBar: AppBar(
              backgroundColor: global_color_6_blue,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              title: Text(
                "Receipts",
              ),
            ),
            body: SizedBox(height: totalHeight, child: buildList()),
          );
  }

  extractBasicReceiptInfo() async {
    List tempArr = await getIndexReceiptList(context, currentPage);
    for (int i = 0; i < tempArr.length; i++) {
      BasicIndexReceipt basicIndexReceipt = tempArr[tempArr.length - i - 1];
      List dateTimeArr = timestampToDateTime('${basicIndexReceipt.timestamp}');
      receiptArr
          .add([basicIndexReceipt.receiptID, dateTimeArr[0], dateTimeArr[1]]);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget buildList() {
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

          if (((itemIndex + 1) >= receiptArr.length) && (currentPage > 0)) {
            currentPage -= 1;
            _isLoading = true;
            extractBasicReceiptInfo();
          }

          return _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : buildContainer(receiptArr[itemIndex][0],
                  receiptArr[itemIndex][1], receiptArr[itemIndex][2]);
        });
  }

  Widget buildContainer(int receiptID, String date, String time) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ReceiptDetailPage(receiptID: receiptID)));
        },
        child: Container(
          margin: EdgeInsets.all(10),
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(1, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 13,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 7),
                    child: Text(
                      'Receipt ID: ' + receiptID.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: global_color_5_blue),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 5,
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.grey,
                height: 1,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        'Created on:',
                        style: TextStyle(fontSize: 20),
                      ),
                      Flexible(
                        child: Text(
                          "   " + date + ' on ' + time,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 5,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Text(
                      'View More >>',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
