import 'package:flutter/material.dart';
import 'package:whose_doc/Utils/CartItemData.dart';
import 'package:whose_doc/pages/homepage.dart';
import 'package:whose_doc/variables/globalvar.dart';
import 'package:whose_doc/functions/api_manager.dart';
import 'package:whose_doc/variables/models.dart';
import 'package:whose_doc/variables/routes.dart';
import '../Widgets/ShimmerCard.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List cartArr = [];
  double totalCost = 0;
  bool _isLoadingCart = true;
  int totalItems = 0;
  List<int> isSet = [];
  Map<int, int> cartAmmount = Map();
  int totalAmmount = 0;
  CartItemdata cartData = new CartItemdata();
  //int _amount = null;
  bool isCartEmpty = false;
  @override
  void initState() {
    checkProgress();
    super.initState();
  }

  Future<void> checkProgress() async {
    List tempArr = [];
    totalItems = await getCartMeta(context);
    tempArr = await getCartInfo(context, userID);
    extractCartItems(tempArr);
  }

  extractCartItems(List arr) {
    CartItemsArr cartItemsArr;
    CartLinks cartLinks;

    for (int i = 0; i < arr.length; i++) {
      List tempArr = [];
      cartItemsArr = arr[i];
      cartLinks = cartItemsArr.links;
      tempArr.add(webTemp + cartLinks.featurePic);
      tempArr.add(cartItemsArr.brand + " " + cartItemsArr.model);
      tempArr.add(cartItemsArr.amount / 100);
      tempArr.add(cartItemsArr.id);

      tempArr.add(cartItemsArr.quantity);
      cartArr.add(tempArr);
      totalCost += (cartItemsArr.amount / 100) * cartItemsArr.quantity;
    }
    setState(() {
      _isLoadingCart = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: global_color_12_litegrey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        splashColor: Colors.red[200],
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  isCartEmpty == false
                      ? Stack(
                          children: [
                            ClipOval(
                              child: Material(
                                color: Colors.white,
                                child: InkWell(
                                  splashColor: Colors.red[200],
                                  child: SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Icon(
                                      Icons.shopping_cart,
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/cartPage');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: 18,
                              height: 18,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(9)),
                              child: totalAmmount == 0
                                  ? Text(
                                      totalItems.toString(),
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      totalAmmount.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                            )
                          ],
                        )
                      : ClipOval(
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              splashColor: Colors.red[200],
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/cartPage');
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "SHOPPING CART",
                style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: totalHeight * 0.45,
              //width: _screen_size.width,
              child:
                  _isLoadingCart == true ? productShimmerCard() : buildList(),
            ),
            SizedBox(
              width: totalWidth,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    width: totalWidth - 30,
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
                          r"$" + totalCost.toStringAsFixed(2),
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
                    width: totalWidth - 30,
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
                    width: totalWidth - 30,
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
                          r"$" + (totalCost + 5).toStringAsFixed(2),
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
                  SizedBox(
                    height: 60,
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () async {
                        await getSessionID(context);
                        ((sessionID == '') && (publicKey == ''))
                            ? Center(child: CircularProgressIndicator())
                            : Navigator.pushNamed(context, '/paymentPage');
                      },
                      child: Text(
                        'Checkout',
                        style: TextStyle(fontSize: 20),
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: cartArr.length * 2,
        itemBuilder: (BuildContext context, int widgetIndex) {
          if (widgetIndex.isOdd) {
            return Divider(
              color: Colors.transparent,
            );
          }

          final itemIndex = widgetIndex ~/ 2;

          if (itemIndex >= cartArr.length) {
            dataGenerator(itemIndex);
          }

          return buildRow(
              widgetIndex,
              cartArr[itemIndex][0],
              cartArr[itemIndex][1],
              cartArr[itemIndex][2],
              cartArr[itemIndex][3],
              cartArr[itemIndex][4]);
        });
  }

  dataGenerator(int index) {
    List arr = [];

    arr = cartArr[index];
    cartArr.add(arr);
  }

  Widget buildRow(int index, String picURL, String proName, double proCost,
      int cartItemID, int quantity) {
    debugPrint("index $index");
    //print("isSet is now ${isSet[index]}");

    if (!isSet.contains(index)) {
      // _amount = quantity;
      totalAmmount += quantity;
      cartAmmount[index] = quantity;
      isSet.add(index);
    }

    debugPrint(cartAmmount.toString());

    return GestureDetector(
      onTap: () {
        // deleteDialog(context, cartItemID);
      },
      child: (cartAmmount[index]) == 0
          ? Divider()
          : Container(
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
                            SizedBox(
                                width: 20,
                                height: 20,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        return Color.fromRGBO(200, 200, 200, 1);
                                      }),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(0)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                      ))),
                                  onPressed: () {
                                    setState(() {
                                      if (quantity > 0) {
                                        cartAmmount[index] -= 1;
                                        totalCost -= proCost;
                                        totalAmmount--;
                                        cartData.cartItemCount -= 1;
                                        if (totalAmmount == 0) {
                                          isCartEmpty = true;
                                        }
                                      }
                                      subtractAmountToCart(context, cartItemID);
                                      // Navigator.of(context)
                                      //     .popAndPushNamed('/cartPage');
                                    });
                                  },
                                  child: Text(
                                    "-",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              cartAmmount[index].toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                                width: 20,
                                height: 20,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        return Color.fromRGBO(200, 200, 200, 1);
                                      }),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(0)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                      ))),
                                  onPressed: () {
                                    setState(
                                      () {
                                        cartAmmount[index] += 1;
                                        totalCost += proCost;
                                        totalAmmount++;
                                        cartData.cartItemCount -= 1;
                                      },
                                    );
                                    addAmountToCart(context, cartItemID);
                                    // Navigator.of(context)
                                    //     .popAndPushNamed('/cartPage');
                                  },
                                  child: Text(
                                    "+",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )),
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
            ),
    );
  }
}
