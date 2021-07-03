import 'package:flutter/material.dart';
import 'package:whose_doc/pages/adddeliveryaddress.dart';
import 'package:whose_doc/pages/addinsurance.dart';
import 'package:whose_doc/pages/addpayment.dart';
import 'package:whose_doc/pages/cart.dart';
import 'package:whose_doc/pages/deliveryaddress.dart';
import 'package:whose_doc/pages/favourites.dart';
import 'package:whose_doc/pages/history.dart';
import 'package:whose_doc/pages/insurance.dart';
import 'package:whose_doc/pages/landingPage.dart';
import 'package:whose_doc/pages/LoginPage.dart';
import 'package:whose_doc/pages/productpage.dart';
import 'package:whose_doc/pages/profile.dart';
import 'package:whose_doc/pages/receipt.dart';
import 'package:whose_doc/pages/clinic_list.dart';
import 'package:whose_doc/pages/selectclinic.dart';
import 'package:whose_doc/pages/payment_success.dart';
import 'pages/register.dart';
import 'pages/homepage.dart';
import 'pages/payment.dart';
import 'pages/receiptslist.dart';

void main() {
  runApp(WhoseDocApp());
}

class WhoseDocApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhoseDoctor',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(scaffoldBackgroundColor: Colors.white), //Colors.grey[700]),
      initialRoute: '/landingPage',
      routes: <String, WidgetBuilder>{
        '/landingPage': (context) => LandingPage(),
        '/loginUser': (context) => LoginPage(),
        '/registerUser': (context) => RegisterUserPage(),
        '/homePage': (context) => HomePage(),
        '/productPage': (context) => ProductPage(),
        '/cartPage': (context) => CartPage(),
        '/selectClinicPage': (context) => SelectClinic(),
        '/profilePage': (context) => Profile(),
        '/deliveryaddressPage': (context) => DeliveryAddress(),
        '/adddeliveryaddressPage': (context) => AddDeliveryAddress(),
        '/receiptPage': (context) => Receipt(),
        '/paymentPage': (context) => Payment(),
        '/addpaymentPage': (context) => AddPayment(),
        '/insurancePage': (context) => Insurance(),
        '/addinsurancePage': (context) => AddInsurance(),
        '/favouritesPage': (context) => Favourites(),
        '/historyPage': (context) => History(),
        '/receiptList': (context) => ReceiptList(),
        '/successPayment': (context) => SucessPaymentPage(),
        '/clinicListPage': (context) => ClinicListPage()
        //'/receiptDetails': (context) => ReceiptDetailPage()
      },
    );
  }
}
