import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:whose_doc/pages/homepage.dart';
import 'package:whose_doc/pages/landingPage.dart';
import 'package:whose_doc/pages/profile.dart';
import 'package:whose_doc/variables/globalvar.dart';
import 'package:whose_doc/functions/api_manager.dart';

errorDialog(BuildContext context, String errorMsg) {
  //May have a bug
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text('Error!'),
            content: Text(errorMsg),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('Okay'))
                ],
              )
            ],
          ));
}

final RoundedLoadingButtonController _btnController =
    RoundedLoadingButtonController();
popUpDialog(BuildContext context, String title, String errorMsg) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(errorMsg),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('Okay'))
                ],
              )
            ],
          ));
}

deleteDialog(BuildContext context, int cartItemID) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text('Remove Item'),
            content: Text('Remove item from cart?'),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextButton(
                        onPressed: () => Navigator.pop(context, 'No'),
                        child: Text('No')),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: TextButton(
                        onPressed: () => removeItemFromCart(context, cartItemID)
                                .then((result) {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .popAndPushNamed('/cartPage');
                            }),
                        child: const Text('Yes')),
                  )
                ],
              )
            ],
          ));
}

registerDialog(BuildContext context) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text('Invalid Email and/or Password'),
            content: Text('Do you want to register?'),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: TextButton(
                            onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LandingPage(),
                                  ),
                                ),
                            child: Text('No')),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/registerUser')
                                    .then((result) {
                                  Navigator.of(context).pop();
                                }),
                            child: const Text('Yes')),
                      ),
                    ],
                  )
                ],
              )
            ],
          ));
}

loadingDialog(BuildContext context, String title, String errorMsg) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(errorMsg),
          ));
}

updatingDialog(BuildContext context) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text('Success!'),
            content: Text('Successfully updated!'),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed("/homePage"),
                      child: const Text('Okay'))
                ],
              )
            ],
          ));
}

sessionExpiredDialog(BuildContext context) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text('Session Expired!'),
            content: Text('Your session has expired, please login again.'),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        resetButton();
                        Navigator.of(context).pushNamed('/landingPage');
                      },
                      child: const Text('Okay'))
                ],
              )
            ],
          ));
}

void _doSomething(RoundedLoadingButtonController controller) async {
  Timer(Duration(seconds: 2), () {
    controller.success();
  });
}

imageDialog(BuildContext context, File file) async {
  File rotatedImage = await FlutterExifRotation.rotateImage(path: file.path);
  showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    height: 200,
                    padding: EdgeInsets.fromLTRB(60, 50, 60, 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'How does this look?',
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 50,
                            width: 160,
                            child: RoundedLoadingButton(
                              child: Text(
                                'Good !',
                                style: TextStyle(color: Colors.white),
                              ),
                              controller: _btnController,
                              onPressed: () {
                                _doSomething(_btnController);
                                putProfilePic(
                                  context,
                                  rotatedImage,
                                );
                              },
                            ))
                      ],
                    )),
                Positioned(
                  top: -100,
                  child: ClipOval(
                    child: Image.file(
                      file,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ));
}

resetButton() {
  token = '';
  userID = 0;
  givenName = '';
  lastName = '';
  phoneNum = '';

  cartLink = '';
  ordersLink = '';
  receiptsLink = '';
  selfLink = '';
  profilePicLink = '';

  numProducts = 0;
  sessionID = '';
  publicKey = '';
  cartID = 0;
}
