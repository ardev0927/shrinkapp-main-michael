import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import '../variables/globalvar.dart';
import 'error_handles.dart';
import '../variables/routes.dart';
import '../variables/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';

Future<void> loginUser(
    BuildContext context, String username, String password) async {
  String credentials = username + ":" + password;
  String encodedCred = base64Url.encode(utf8.encode(credentials));
  String b64BAHeader = "Basic " + encodedCred;

  var response = await http.post(loginURL, headers: <String, String>{
    'Authorization': b64BAHeader,
  });
  if (response.statusCode == 401) {
    registerDialog(context);
  } else if (response.statusCode == 200) {
    LoginInfo user = LoginInfo.fromJson(jsonDecode(response.body));
    userID = user.userID;
    token = user.token;

    //SAVING ENCRYPTED LOGIN INFO FOR AUTOLOGIN

    final key =
        encrypt.Key.fromUtf8(autoLoginEncKey); // key used for encryption
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encryptedUsername = encrypter.encrypt(username, iv: iv);
    final encryptedPassword = encrypter.encrypt(password, iv: iv);

    debugPrint("encrypted - " + encryptedUsername.base64);
    debugPrint("encrypted - " + encryptedPassword.base64);

    SharedPreferences.getInstance().then((prefs) {
      debugPrint("setting isLogged true");
      prefs.setBool("isLogged", true);
      prefs.setString("data1", encryptedUsername.base64);
      prefs.setString("data2", encryptedPassword.base64);
    });
    Navigator.pushReplacementNamed(context, '/homePage');
  } else {
    errorDialog(context, 'Failed to connect');
  }
}

Future<void> deleteToken(BuildContext context) async {
  SharedPreferences.getInstance().then((prefs) {
    debugPrint("setting isLogged false");
    prefs.setBool("isLogged", false);
  });

  // INFO: THIS ENDPOINT BELOW DOESNT WORK, MOVE THE SHAREDPREF CALL TO THE END AFTER FIXIN
  var response = await http.delete(loginURL, headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
  } else {
    errorDialog(context, 'Unable to delete token');
  }
}

Future<void> getBasicUserInfo(BuildContext context) async {
  var userInfoURL = Uri.parse(userInfoTemp + userID.toString());
  var response = await http.get(userInfoURL, headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    BasicUserInfo userInfo = BasicUserInfo.fromJson(jsonDecode(response.body));
    givenName = userInfo.givenName;
    lastName = userInfo.lastName;
    if (givenName == null && lastName == null) {
      givenName = userInfo.username;
    }
    phoneNum = userInfo.phoneNum;
    if (phoneNum == null) {
      phoneNum = 'No phone number';
    }
    cartLink = userInfo.userLinks.cartLink;
    ordersLink = userInfo.userLinks.ordersLink;
    receiptsLink = userInfo.userLinks.receiptsLink;
    selfLink = userInfo.userLinks.selfLink;
    profilePicLink = userInfo.userLinks.profilePicLink;
  } else {
    sessionExpiredDialog(context);
  }
}

Future<DetailedUserInfo> getDetailedUserInfo(BuildContext context) async {
  DetailedUserInfo detailedUserInfo;

  var userInfoURL = Uri.parse(userInfoTemp + userID.toString());
  var response = await http.get(userInfoURL, headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    detailedUserInfo = DetailedUserInfo.fromJson(jsonDecode(response.body));
  } else {
    errorDialog(context, 'Unable to retrieve detailed user info');
  }

  return detailedUserInfo;
}

Future<void> getProductInfo(BuildContext context) async {
  var response =
      await http.get(Uri.parse(productsTemp), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    ProductInfo productInfo = ProductInfo.fromJson(jsonDecode(response.body));
    numProducts = productInfo.metaData.totalItems;
  } else {
    // errorDialog(context, 'No Product Info');
  }
}

Future<http.Response> getPosts(BuildContext context) async {
  print("get posts  is called");
  var response = await http
      .get(Uri.parse(webTemp + '/api/posts'), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    //print("response is ====== ${response.body.toString()}");

    return response;
  } else {
    print("ERROR ERROR ERROR ERROR ");
    return null;
  }
}

Future<http.Response> getAuthorDetails(BuildContext context) async {
  print("get authod called");
  var response = await http
      .get(Uri.parse(webTemp + '/api/posts'), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    //print("response is ====== ${response.body.toString()}");
    Map<String, dynamic> data = json.decode(response.body);

    var response2 = await http.get(Uri.parse(data['items']['_links']['author']),
        headers: <String, String>{
          'Authorization': 'Bearer ' + token,
        });
    print(
        "authod responce ........  ### \n \n \n \n \n \n \n \n \n${response2.body.toString()}");
    return response2;
  } else {
    print("ERROR ERROR ERROR ERROR ");
    return null;
  }
}

Future<List> getProductArr(BuildContext context) async {
  List dataArr = [];
  var response =
      await http.get(Uri.parse(productsTemp), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    ProductInfo productInfo = ProductInfo.fromJson(jsonDecode(response.body));
    dataArr = productInfo.itemArr;
  } else {
    // errorDialog(context, 'No Product Info');
  }
  return dataArr;
}

Future<List> getIndexProductInfo(BuildContext context, int index) async {
  List dataArr = [0, ' ', ' ', 0];

  var indexProductURL = Uri.parse(productsTemp + "/" + index.toString());
  var response = await http.get(indexProductURL, headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    ProductArr indexInfo = ProductArr.fromJson(jsonDecode(response.body));
    dataArr[0] = indexInfo.productID;
    dataArr[1] = indexInfo.brand;
    dataArr[2] = webTemp + indexInfo.links.featurePic;
    dataArr[3] = indexInfo.amount;
  } else {
    // errorDialog(context, 'Unable to get Product Info');
  }

  return dataArr;
}

Future<String> getProductDescription(BuildContext context, int index) async {
  String string = '';

  var indexProductURL = Uri.parse(productsTemp + "/" + index.toString());
  var response = await http.get(indexProductURL, headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    ProductArr indexInfo = ProductArr.fromJson(jsonDecode(response.body));
    string = indexInfo.description;
  } else {
    //  errorDialog(context, 'Unable to get description');
  }

  return string;
}

Future<int> getCartMeta(BuildContext context) async {
  int totalItems = 0;

  String cartURl = webTemp + '/api/carts/' + userID.toString();
  var response = await http.get(Uri.parse(cartURl), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });

  if (response.statusCode == 200) {
    CartUserInfo cartUserInfo =
        CartUserInfo.fromJson(jsonDecode(response.body));
    totalItems = cartUserInfo.cartItemsCount;
  } else {
    // popUpDialog(context, 'Cart Empty', 'Your cart is empty');
  }

  return totalItems;
}

Future<List> getCartInfo(BuildContext context, int index) async {
  List dataArr = [];
  String cartURl = webTemp + '/api/carts/' + userID.toString() + '/cart_items';
  var response = await http.get(Uri.parse(cartURl), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });

  if (response.statusCode == 200) {
    CartInfo cartInfo = CartInfo.fromJson(jsonDecode(response.body));
    dataArr = cartInfo.itemsArr;
  } else {
    //popUpDialog(context, 'Cart Empty', 'Your cart is empty');
  }

  return dataArr;
}

Future<void> putItemToCart(
    BuildContext context, int productID, int amountToAdd) async {
  String addURL = productsTemp + '/' + productID.toString() + '/add_item';
  var jsonData = jsonEncode({
    'quantity': amountToAdd,
  });
  var response = await http.put(
    Uri.parse(addURL),
    headers: <String, String>{
      'Authorization': 'Bearer ' + token,
    },
    body: jsonData,
  );
  if (response.statusCode == 200) {
    print("ADDING ITEM SUCCESS");
  } else {
    //  errorDialog(context, 'Unable to add item to cart');
    print(response.body);
  }
}

Future<void> removeItemFromCart(BuildContext context, int cartItemID) async {
  String removeItemURL =
      webTemp + '/api/cart_items/' + cartItemID.toString() + '/remove_item';
  var response =
      await http.put(Uri.parse(removeItemURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
  } else {
    // errorDialog(context, 'Unable to add item to cart');
  }
}

Future<void> addAmountToCart(BuildContext context, int cartItemID) async {
  String addURL =
      webTemp + '/api/cart_items/' + cartItemID.toString() + '/add_quantity';

  var response = await http.put(
    Uri.parse(addURL),
    headers: <String, String>{
      'Authorization': 'Bearer ' + token,
    },
  );
  if (response.statusCode == 200) {
  } else {
    print(response.statusCode);
  }
}

Future<void> subtractAmountToCart(BuildContext context, int cartItemID) async {
  String addURL = webTemp +
      '/api/cart_items/' +
      cartItemID.toString() +
      '/subtract_quantity';
  var response = await http.put(Uri.parse(addURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
  } else {
    // errorDialog(context, 'Could not decrease item quantity');
  }
}

Future<int> putItemAndIncrease(
  BuildContext context,
  int productID,
  int amountToAdd,
) async {
  int newCartID;
  String addURL = productsTemp + '/' + productID.toString() + '/add_item';
  var jsonData = jsonEncode({
    'quantity': amountToAdd,
  });
  var response = await http.put(
    Uri.parse(addURL),
    headers: <String, String>{
      'Authorization': 'Bearer ' + token,
    },
    body: jsonData,
  );
  if (response.statusCode == 200) {
    newCartID = await checkProductInCart(context, productID, userID);
  } else {
    // errorDialog(context, 'Unable to add item to cart');
  }
  return newCartID;
}

Future<void> getSessionID(BuildContext context) async {
  String paymentURL = webTemp + '/api/stripe_pay';
  var response =
      await http.get(Uri.parse(paymentURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    PaymentTokens paymentTokens =
        PaymentTokens.fromJson(jsonDecode(response.body));
    cartID = paymentTokens.cartID;
    sessionID = paymentTokens.sessionID;
    publicKey = paymentTokens.publicKey;
  } else {
    errorDialog(context, 'Could not get session ID');
  }
}

Future<void> redirectToStripe(WebViewController webViewController) async {
  final redirectToCheckoutJs = '''
                              var stripe = Stripe(\'$publicKey\');
                              stripe.redirectToCheckout({sessionId: '$sessionID'}).then(function (result) {result.error.message = 'Error'});
                              ''';
  webViewController.evaluateJavascript(redirectToCheckoutJs);
}

Future<void> getSuccessPayment(BuildContext context) async {
  String successURL = webTemp + '/api/successful/' + cartID.toString();
  var response =
      await http.get(Uri.parse(successURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    //popUpDialog(context, 'Payment Outcome', 'Payment is Successful!');
  } else {
    errorDialog(context, 'Payment session Timout');
  }
}

Future<List> getOrderHistory(BuildContext context) async {
  //only 1 page of order returned
  List dataArr = [];
  String orderURl = webTemp + '/api/orders';
  var response = await http.get(Uri.parse(orderURl), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });

  if (response.statusCode == 200) {
    UserOrders userOrders = UserOrders.fromJson(jsonDecode(response.body));
    dataArr = userOrders.orderArr;
  } else {
    errorDialog(context, 'No Order Info');
  }

  return dataArr;
}

Future<List> getPromoArr(BuildContext context) async {
  List dataArr = [];

  String promoURl = webTemp + '/api/promos';
  var response = await http.get(Uri.parse(promoURl), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    ProductInfo promoInfo = ProductInfo.fromJson(jsonDecode(response.body));
    dataArr = promoInfo.itemArr;
  } else {
    //  errorDialog(context, 'No Promo Info');
  }
  return dataArr;
}

Future<List> getPromotions(BuildContext context) async {
  List dataArr = [];
  String promoURL = webTemp + '/api/promos';
  var response = await http.get(Uri.parse(promoURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });

  if (response.statusCode == 200) {
    ProductInfo productInfo = ProductInfo.fromJson(jsonDecode(response.body));
    dataArr = productInfo.itemArr;
  } else {
    // errorDialog(context, 'No Promotion Info');
  }
  return dataArr;
}

Future<int> getMetaReceiptInfo(BuildContext context) async {
  int numReceiptPages = 0;
  String receiptURL =
      webTemp + '/api/users/' + userID.toString() + '/user_receipts';
  var response =
      await http.get(Uri.parse(receiptURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    ProductInfo productInfo = ProductInfo.fromJson(jsonDecode(response.body));
    numReceiptPages = productInfo.metaData.totalPages;
  } else {
    errorDialog(context, 'Unable to get Basic Receipt Info');
  }

  return numReceiptPages;
}

Future<List> getIndexReceiptList(BuildContext context, int pageNo) async {
  List dataArr = [];

  String pageURL = webTemp +
      '/api/users/' +
      userID.toString() +
      '/user_receipts?page=' +
      pageNo.toString() +
      '&per_page=10';
  var response = await http.get(Uri.parse(pageURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    ReceiptInfo receiptInfo = ReceiptInfo.fromJson(jsonDecode(response.body));
    dataArr = receiptInfo.itemArr;
  } else {
    errorDialog(context, 'Unable to get Reciept Page');
  }
  return dataArr;
}

Future<List> getIndexReceiptCartItems(
    BuildContext context, int receiptID) async {
  List dataArr = [];
  String cartURL =
      webTemp + '/api/receipt/' + receiptID.toString() + '/receipt_cart_items';
  var response = await http.get(Uri.parse(cartURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    ReceiptCartInfo receiptCartInfo =
        ReceiptCartInfo.fromJson(jsonDecode(response.body));
    dataArr = receiptCartInfo.itemArr;
  } else {
    errorDialog(context, 'Unable to get Receipt Cart Items');
  }

  return dataArr;
}

Future<void> putProfilePic(BuildContext context, File file) async {
  String fileName = file.path.split('/').last;
  //String b64Image = base64Encode(AsyncSnapshot<)
  String profilePicURL = webTemp + '/api/users/' + 'upload_selfie';
  var jsonData = jsonEncode({
    'photo': base64Encode(File(file.path).readAsBytesSync()),
  });
  debugPrint(jsonData);
  var response = await http.put(Uri.parse(profilePicURL),
      headers: <String, String>{
        'Authorization': 'Bearer ' + token,
        //'Content-Type': 'application/x-www-form-urlencoded',
        'Content_Disposition': 'attachment: filename=$fileName'
      },
      body: jsonData);

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print(response.body);
    errorDialog(context, 'Unable to upload profile picture');
  }
}

Future<void> fixedputProfilePic(BuildContext context, File imageFile) async {
  String fileName = imageFile.path.split('/').last;
  var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();
  Map<String, String> headers = {
    'Authorization': 'Bearer ' + token,
    'Content-Type': 'image/jpeg',
    'Content_Disposition': 'attachment: filename=$fileName'
  };
  var uri =
      Uri.parse(webTemp + '/api/users/' + userID.toString() + '/upload_selfie');
  var request = new http.MultipartRequest("PUT", uri);
  var multipartFileSign = new http.MultipartFile('profile_pic', stream, length,
      filename: basename(imageFile.path));
  request.files.add(multipartFileSign);

  //add headers
  request.headers.addAll(headers);
  var response = await request.send();

  print(response.statusCode);

  // listen for response
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
}

Future<int> getCompanyMeta(BuildContext context) async {
  int totalItems = 0;

  String companyURL = webTemp + '/api/companies';
  var response =
      await http.get(Uri.parse(companyURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });

  if (response.statusCode == 200) {
    CompanyInfo companyInfo = CompanyInfo.fromJson(jsonDecode(response.body));
    totalItems = companyInfo.meta.totalItems;
  } else {
    errorDialog(context, 'Unable to get company list');
  }

  return totalItems;
}

Future<int> getCompanyPages(BuildContext context) async {
  int totalItems = 0;

  String companyURL = webTemp + '/api/companies';
  var response =
      await http.get(Uri.parse(companyURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });

  if (response.statusCode == 200) {
    CompanyInfo companyInfo = CompanyInfo.fromJson(jsonDecode(response.body));
    debugPrint("set total");
    totalItems = companyInfo.meta.totalPages;
  } else {
    errorDialog(context, 'Unable to get company list');
  }

  return totalItems;
}

Future<List> getIndexCompanyBasicInfo(
    BuildContext context, int companyID) async {
  List dataArr = [];

  String companyURL = webTemp + '/api/companies/' + companyID.toString();
  var response =
      await http.get(Uri.parse(companyURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    CompanyArr companyArr = CompanyArr.fromJson(jsonDecode(response.body));
    dataArr.add(companyArr.companyID);
    dataArr.add(companyArr.latitude);
    dataArr.add(companyArr.longitude);
  } else {
    errorDialog(context, 'Unable to get index company');
  }

  return dataArr;
}

Future<List> getIndexCompanyDetailedInfo(
    BuildContext context, int companyID) async {
  List dataArr = [];

  String companyURL = webTemp + '/api/companies/' + companyID.toString();
  var response =
      await http.get(Uri.parse(companyURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    CompanyArr companyArr = CompanyArr.fromJson(jsonDecode(response.body));
    dataArr.add(companyArr.companyName);
    dataArr.add(webTemp + companyArr.links.logoFile);
    debugPrint(":: company meta");
    debugPrint(companyArr.toString());
  } else {
    debugPrint("unable $companyID");
  }

  return dataArr;
}

Future<CompanyArr> getIndexCompanyDetailedInfo2(
    BuildContext context, int companyID) async {
  List dataArr = [];

  String companyURL = webTemp + '/api/companies/' + companyID.toString();
  var response =
      await http.get(Uri.parse(companyURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });
  if (response.statusCode == 200) {
    CompanyArr companyArr = CompanyArr.fromJson(jsonDecode(response.body));
    return companyArr;
  } else {
    debugPrint("unable $companyID");
  }
  return null;
}

Future<List> getCompanyInfo(BuildContext context) async {
  List dataArr = [];

  String companyURL = webTemp + '/api/companies';
  var response =
      await http.get(Uri.parse(companyURL), headers: <String, String>{
    'Authorization': 'Bearer ' + token,
  });

  if (response.statusCode == 200) {
    CompanyInfo companyInfo = CompanyInfo.fromJson(jsonDecode(response.body));
    dataArr = companyInfo.companyArr;
  } else {
    errorDialog(context, 'Unable to get Company Info');
  }

  return dataArr;
}

//Other Codes
List timestampToDateTime(String timestamp) {
  List dataArr = [" ", " "]; //date, time
  List dateArr = []; //year, noMonth, day, hour(24hrs), minute
  List monthsArr = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List tempArr = [];

  for (int i = 0; i < (timestamp.length - 4); i++) {
    tempArr.add(timestamp[i]);
    if (timestamp[i + 1] == '-' ||
        timestamp[i + 1] == 'T' ||
        timestamp[i + 1] == ':') {
      for (int j = 1; j < tempArr.length; j++) {
        tempArr[0] += tempArr[j];
      }
      dateArr.add(tempArr[0]);
      tempArr.clear();
      i++;
    }
  }

  dataArr[0] = dateArr[2] +
      ' ' +
      monthsArr[int.parse(dateArr[1]) - 1] +
      ' ' +
      dateArr[0];
  if (int.parse(dateArr[3]) > 12) {
    dataArr[1] =
        (int.parse(dateArr[3]) - 12).toString() + '.' + dateArr[4] + 'pm';
  } else {
    dataArr[1] = dateArr[3] + '.' + dateArr[4] + 'am';
  }

  return dataArr;
}

Future<int> checkProductInCart(
    BuildContext context, int productID, int cartID) async {
  int _exist = -1;

  List cartArr = await getCartInfo(context, cartID);
  for (int i = 0; i < cartArr.length; i++) {
    CartItemsArr cartItemsArr = cartArr[i];
    if (cartItemsArr.productID == productID) {
      _exist = cartItemsArr.id;
      break;
    }
  }
  return _exist;
}

//Unused Codes
/*
Future<void> startPayment() async {
  StripePayment.setStripeAccount(null);
  PaymentMethod paymentMethod = PaymentMethod();
  paymentMethod =
      await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
          .then((PaymentMethod paymentMethod) {
    return paymentMethod;
  }).catchError((e) {
    print(e);
  });
  startDirectCharge(paymentMethod);
}
Future<void> startDirectCharge(PaymentMethod paymentMethod) async {
  print('Payment has started');
  String paymentURL = webTemp + '/api/stripe_pay';
  var response = await http.post(Uri.parse(paymentURL));
  if (response.body != null) {
    var paymentIntent = jsonDecode(response.body);
    final status = paymentIntent['paymentIntent']['status'];
    final account = paymentIntent['stripeAccount'];
    if (status == 'succeeded') {
      print('Payment Completed!');
    } else {
      StripePayment.setStripeAccount(account);
      await StripePayment.confirmPaymentIntent(PaymentIntent(
              paymentMethodId: paymentIntent['paymentIntent']['payment_method'],
              clientSecret: paymentIntent['paymentIntent']['client_secret']))
          .then((PaymentIntentResult paymentIntentResult) async {
        var paymentStatus = paymentIntentResult.status;
        if (paymentStatus == 'succeeded') {
          print('Payment Completed!');
        }
      });
    }
  }
}
*/

/* //Just an idea
Future<bool> checkAvailable(
    String method, String authHeader, String testAppend) async {
  bool checkFlag = false;
  var testURL = Uri.parse(webTemp + testAppend);
  if (method == 'get' && authHeader == 'token') {
    var response = await http.get(testURL, headers: <String, String>{
      'Authorization': 'Bearer ' + token,
    });
    if (response.statusCode == 200) {
      checkFlag = true;
    }
  }
  return checkFlag;
}
*/
