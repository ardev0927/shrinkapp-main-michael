import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:whose_doc/functions/api_manager.dart';
//import 'package:whose_doc/functions/error_handles.dart';
import 'package:whose_doc/pages/productpage.dart';
import 'package:whose_doc/variables/globalvar.dart';
import 'package:whose_doc/variables/models.dart';
import 'package:whose_doc/variables/routes.dart';
//import 'package:whose_doc/variables/models.dart';
import '../Utils/MoneyConvert.dart';
import 'package:http/http.dart' as http;

class TabWidget extends StatefulWidget {
  const TabWidget({Key key, @required this.scrollController}) : super(key: key);

  final ScrollController scrollController;

  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  List dataArr = [];
  List promoArr = [];
  List dataTruthTable = []; //if loading, then true
  List promoTruthTable = [];
  List compArr = [];

  @override
  void initState() {
    super.initState();
    //getAuthorDetails();
    callAuthor();
    callGetPosts();
    getPosts(context);
    getProductInfo(context);
    productGenerator();
    promoGenerator();

    // getCompanyPages(context).then((value) => getComp());
  }

  // Future<void> getComp() async {
  //   debugPrint("wefiyfkgwkefvhway called");
  //   debugPrint("numproj " + numProducts.toString());
  //   for (int i = 1; i <= 2; i++) {
  //     debugPrint(":: " + i.toString());
  //     var data = await getIndexCompanyDetailedInfo(context, i);
  //     setState(() {
  //       compArr.add(data);
  //       debugPrint(":: data " + data.toString());
  //     });
  //   }
  // }

  callAuthor() async {
    Response response = await getAuthorDetails();
  }

  Map<String, dynamic> data;
  int totalPosts;
  callGetPosts() async {
    Response response = await getPosts(context);

    //print("RESPONCE  IN TAB IS    ++++  ${response.body.toString()}");
    setState(() {
      data = json.decode(response.body);
      totalPosts = data['_meta']['total_items'];
      isFetching = false;
    });

    //print("persed data is .... ${data.toString()}");
    // print("total posts are $totalPosts");

    //print("BODY TEST ....  ${data['items'][0]}");
  }

  getAuthorDetails() async {
    //await http.get(data['items'][widgetIndex]['_links']['author']);
  }

  productGenerator() async {
    List tempArr = await getProductArr(context);
    for (int i = 0; i < tempArr.length; i++) {
      dataTruthTable.add(true);
      extractInfo('product', tempArr[i], i);
    }
  }

  promoGenerator() async {
    List tempArr = await getPromoArr(context);
    for (int i = 0; i < tempArr.length; i++) {
      promoTruthTable.add(true);
      extractInfo('promo', tempArr[i], i);
    }
  }

  extractInfo(String mode, ProductArr array, int index) {
    List tempArr = [];
    tempArr.add(array.productID);
    if (array.brand == null) {
      if (array.model == null) {
        tempArr.add('');
      } else {
        tempArr.add(array.model);
      }
    } else {
      tempArr.add(array.brand);
    }

    tempArr.add(webTemp + array.links.featurePic);
    tempArr.add(array.amount);
    if (mode == 'product') {
      dataArr.add(tempArr);
      setState(() {
        dataTruthTable[index] = false;
      });
    } else {
      promoArr.add(tempArr);
      setState(() {
        promoTruthTable[index] = false;
      });
    }
  }

  bool isFetching = true;

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return isFetching == true
        ? Container()
        : SingleChildScrollView(
            controller: widget.scrollController,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.only(top: 30),
                  color: global_color_8_white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 25, left: 10, bottom: 10),
                        child: Text(
                          'Promo',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 158.0 + 10,
                        child: buildPromos(context),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 16, left: 10, bottom: 10),
                        child: Text(
                          'Marketplace',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(height: 158.0 + 10, child: buildList(context)),
                      Container(
                        padding: EdgeInsets.only(top: 16, left: 10, bottom: 10),
                        child: Text(
                          'Medical Feed',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        children: [
                          medicalFeed(context),
                          SizedBox(
                            height: 50.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: 60,
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/clinicListPage');
                      },
                      child: Text(
                        'Teleconsult',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            return global_color_2_blue;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ))),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildPromos(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: (promoArr.length * 2),
        itemBuilder: (BuildContext context, int widgetIndex) {
          if (widgetIndex.isOdd)
            return Divider(
              color: Colors.transparent,
            );

          final promoIndex = widgetIndex ~/ 2;

          /*if ((promoIndex >= promoArr.length) &&
              (promoArr.length != promoArr.length)) {
            _isPromoLoading = true;
            promoGenerator();
          } */

          return (promoTruthTable[promoIndex] == true)
              ? Container(
                  height: totalHeight * 1,
                  width: totalWidth * 1,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Please Wait...",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      CircularProgressIndicator(
                        backgroundColor: Colors.amber,
                      ),
                    ],
                  ),
                )
              : buildContainer(
                  context,
                  promoArr[promoIndex][0],
                  promoArr[promoIndex][1],
                  promoArr[promoIndex][2],
                  promoArr[promoIndex][3]);
        });
  }

  Widget buildList(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: (dataArr.length * 2),
        itemBuilder: (BuildContext context, int widgetIndex) {
          if (widgetIndex.isOdd)
            return Divider(
              color: Colors.transparent,
            );

          final itemIndex = widgetIndex ~/ 2;

          /* if ((itemIndex >= dataArr.length) &&
              (dataArr.length != numProducts)) {
                //Need to add page number to function
            dataGenerator(context, itemIndex);
          } */

          return (dataTruthTable[itemIndex] == true)
              ? Center(child: CircularProgressIndicator())
              : buildContainer(
                  context,
                  dataArr[itemIndex][0],
                  dataArr[itemIndex][1],
                  dataArr[itemIndex][2],
                  dataArr[itemIndex][3]);
        });
  }

  Widget medicalFeed(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data['items'].length,
      itemBuilder: (BuildContext context, int widgetIndex) {
        // print("widget index === $widgetIndex");

        String name = data['items'][widgetIndex]['author_name'];
        String time = data['items'][widgetIndex]['created_on'];
        String body = data['items'][widgetIndex]['body'];
        /* if ((itemIndex >= dataArr.length) &&
              (dataArr.length != numProducts)) {
            _isLoading = true;
            dataGenerator(context, itemIndex);
          } */
        //print(widgetIndex);
        //return buildRow(compArr[widgetIndex][1], compArr[widgetIndex][0],
        // print("first company name ... ${compArr[widgetIndex][0]}");
        // print("first company pic ... ${compArr[widgetIndex][1]}");
        // print("see if there is anything else ${compArr[widgetIndex][2]}");
        // print("${data['items'][widgetIndex]} \n \n ");
        return Column(
          children: [
            SizedBox(
              // height: totalHeight * 0.3,
              width: totalWidth * 0.95,
              child: Card(
                elevation: 5.0,
                child: Wrap(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "   $name",
                        style: TextStyle(
                          fontSize: totalHeight * 0.02,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "   ${time.characters.take(10)}",
                        style: TextStyle(
                          fontSize: totalHeight * 0.017,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      height: 03,
                    ),
                    Center(
                      child: SizedBox(
                        height: totalHeight * 0.2,
                        width: totalWidth * 0.9,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.network(
                            "https://www.whosedoctor.com/${data['items'][widgetIndex]['_links']['picto_file']}",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 05,
                    ),
                    Text(
                      "   $body",
                      style: TextStyle(
                        fontSize: totalHeight * 0.018,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 7.0,
            ),
          ],
        );
      },
    );
  }

  Widget buildRow(String imgUrl, String text1, String text2, String imgUrl2) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 184,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: () {},
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/images/logo_1.png",
                    width: 41,
                    height: 41,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lee Chong Ming",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      Text(
                        "3hrs",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
              Image.asset(
                "assets/images/logo_2.png",
                height: 112,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainer(BuildContext context, int proID, String proName,
      String picURL, int cost) {
    double price = MoneyConvert().centToDollar(cost);
    return Container(
      margin: EdgeInsets.all(5.0),
      width: 127,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductPage(
                cost: cost,
                proID: proID,
                picURL: picURL,
                proName: proName,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Image.network(
              picURL,
              width: 108,
              height: 100,
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 35,
              child: Text(
                proName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            Text(
              "\$$price",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
