import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:custom_fade_animation/custom_fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:whose_doc/functions/api_manager.dart';
import 'package:whose_doc/functions/error_handles.dart';
import 'package:whose_doc/pages/cart.dart';
import 'package:whose_doc/pages/landingPage.dart';
import 'package:whose_doc/pages/LoginPage.dart';
import 'package:whose_doc/variables/globalvar.dart';
//import 'pages/orders.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String _errorMsg = '';

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //appBar: AppBar(title: Text('Login Page')),
      body: isLoading == true
          ? Container(
              height: totalHeight * 1,
              width: totalWidth * 1,
              color: Colors.white,
              child: Center(
                child: AnimatedTextKit(
                  totalRepeatCount: 4,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "Fetching Details...",
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FadeAnimation(
                              0.2,
                              Row(
                                children: [
                                  Text(
                                    'Email ',
                                    style: TextStyle(
                                      color: Colors.black, //Colors.yellow[200],
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    '*',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FadeAnimation(
                          0.4,
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: TextField(
                              controller: usernameController,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: "Enter Email here"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          0.6,
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    'Password ',
                                    style: TextStyle(
                                      color: Colors.black, //Colors.yellow[200],
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '*',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FadeAnimation(
                          0.8,
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: TextField(
                              controller: passwordController,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: "Enter Password here"),
                              obscureText: true,
                              obscuringCharacter: '*',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeAnimation(
                    1.0,
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.transparent),
                      child: Text(
                        'Forgot Password?',
                        style:
                            TextStyle(color: global_color_2_blue, fontSize: 16),
                      ),
                      onPressed: () {}, //Missing press function (Forgot)
                    ),
                  ),
                  FadeAnimation(
                    1.2,
                    SizedBox(
                      height: 60,
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // isLoading = true;
                          });
                          if (checkEmpty() == true) {
                            setState(() {
                              isLoading = false;
                            });
                            errorDialog(context, _errorMsg);
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            print(
                                "username is ++++++ ${usernameController.value.text.toString()}");
                            print(
                                "password is ++++++ ${passwordController.value.text.toString()}");
                            loginUser(
                              context,
                              usernameController.value.text.toString(),
                              passwordController.value.text.toString(),
                            );
                          }
                        },
                        child: Text(
                          'Login',
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
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                    1.4,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "No Account yet?",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/registerUser');
                            },
                            child: Text('Register',
                                style: TextStyle(fontSize: 16)))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
    );
  }

  bool checkEmpty() {
    bool emptyFlag = false;

    if (usernameController.text.trim() == '' &&
        passwordController.text.trim() == '') {
      emptyFlag = true;
      setState(() {
        _errorMsg = 'Enter empty fields';
      });
      return emptyFlag;
    } else if (usernameController.text.trim() == '') {
      emptyFlag = true;
      setState(() {
        _errorMsg = 'Enter username';
      });
      return emptyFlag;
    } else if (passwordController.text.trim() == '') {
      emptyFlag = true;
      setState(() {
        _errorMsg = 'Enter password';
      });
      return emptyFlag;
    }

    return emptyFlag;
  }
}
