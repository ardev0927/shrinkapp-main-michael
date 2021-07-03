import 'package:flutter/material.dart';
import 'package:whose_doc/Utils/CartItemData.dart';
import 'package:whose_doc/Utils/MoneyConvert.dart';
import 'package:whose_doc/pages/cart.dart';
import 'package:whose_doc/variables/globalvar.dart';
import 'package:whose_doc/functions/api_manager.dart';
import '../Widgets/ShimmerCard.dart';

// ignore: must_be_immutable
class ProductPage extends StatefulWidget {
  int cost, proID;
  String picURL, proName;
  ProductPage({Key key, this.cost, this.proID, this.picURL, this.proName})
      : super(key: key);

  @override
  _ProductPageState createState() =>
      _ProductPageState(cost, proID, picURL, proName);
}

class _ProductPageState extends State<ProductPage> {
  List indexArr;
  int _amount = 1;
  int cost, proID;
  String picURL, proName, description;
  bool _isLoading = true;
  int totalItems;
  _ProductPageState(this.cost, this.proID, this.picURL, this.proName);

  @override
  void initState() {
    super.initState();
    getTotalItem();
    print("Product page");
    checkProgress();

    print("total item count  $totalItems");
  }

  CartItemdata cartData = new CartItemdata();

  checkProgress() async {
    description = await getProductDescription(context, proID);
    if (description == null) {
      description = '';
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getTotalItem() async {
    int temp = await getCartMeta(context);
    print("temp ==== $temp");
    setState(() {
      totalItems = temp;
    });
    print("total items now is $totalItems");
  }

  @override
  Widget build(BuildContext context) {
    double price = MoneyConvert().centToDollar(widget.cost);
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? Scaffold(
            backgroundColor: global_color_12_litegrey,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 3.0,
                    ),
                    Row(
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
                                Navigator.pushNamed(context, '/homePage');
                              },
                            ),
                          ),
                        ),
                        Stack(
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CartPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: global_color_12_litegrey,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: totalHeight * 0.13,
                      ),
                      Image.network(
                        picURL,
                        width: totalWidth,
                        height: totalWidth * 0.6,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              proName,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              '\$ $price',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: totalHeight * 0.02,
                            ),
                            Text(
                              description,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Quantity",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>((states) {
                                            return Color.fromRGBO(
                                                200, 200, 200, 1);
                                          }),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.all(0)),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ))),
                                      onPressed: () {
                                        setState(() {
                                          if (_amount > 0) {
                                            _amount -= 1;
                                          }
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
                                  _amount.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
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
                                            return Color.fromRGBO(
                                                200, 200, 200, 1);
                                          }),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.all(0)),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ))),
                                      onPressed: () {
                                        setState(() {
                                          _amount += 1;
                                        });
                                      },
                                      child: Text(
                                        "+",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      r"$  ",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      (cost / 100).toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "  / pack",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: totalWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 300,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        int _exist = await checkProductInCart(
                                            context, proID, userID);
                                        (_exist == null)
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : increasePath(proID, _exist);
                                      },
                                      child: Text(
                                        'Add to Cart',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          return global_color_2_blue;
                                        }),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Future.delayed(
                                          Duration(milliseconds: 0),
                                        ).then((value) => {
                                              Navigator.pushNamed(
                                                  context, '/cartPage')
                                            });
                                      },
                                      child: Text('CHECKOUT',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 30),
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
                              Navigator.pushNamed(context, '/homePage');
                            },
                          ),
                        ),
                      ),
                      Stack(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CartPage(),
                                    ),
                                  );
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
                              child: Text(
                                totalItems.toString(),
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  increasePath(int productID, int cartItemID) async {
    // loadingDialog(context, 'Busy Working', 'We are adding to cart...');

    if (cartItemID != -1) {
      // Future.delayed(Duration(microseconds: 1500)).then((value) => {});
      setState(
        () {
          totalItems += _amount;
          cartData.cartItemCount += _amount;
        },
      );
      final snackBar2 = SnackBar(
        content: Text(
          'Successfully added !',
          style: TextStyle(
            color: Colors.greenAccent,
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      await putItemToCart(context, productID, _amount);

      // Navigator.pop(context);
    } else {
      //   Future.delayed(Duration(microseconds: 1500)).then((value) => {});

      // await putItemToCart(context, newCartID, _amount);

      setState(
        () {
          totalItems += _amount;
          cartData.cartItemCount += _amount;
        },
      );
      final snackBar2 = SnackBar(
        content: Text(
          'Successfully added !',
          style: TextStyle(
            color: Colors.greenAccent,
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      int newCartID = await putItemAndIncrease(context, productID, _amount);
      // Navigator.pop(context);
    }

    //popUpDialog(context, 'Add to Cart', 'Sucessfully Added to cart!');
  }
}
