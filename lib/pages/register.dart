import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:whose_doc/pages/landingPage.dart';
import 'package:whose_doc/variables/globalvar.dart';
import 'package:whose_doc/variables/routes.dart';
import 'package:custom_fade_animation/custom_fade_animation.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class RegisterUserPage extends StatefulWidget {
  RegisterUserPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUserPage> {
  bool _checkBox = false;
  final userController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //appBar: AppBar(title: Text('Register')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: isLoading == true
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
              : Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    FadeAnimation(
                      0.1,
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                'Username ',
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
                      0.3,
                      Container(
                        child: TextField(
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: "Enter Username here"),
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          controller: userController,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeAnimation(
                      0.5,
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
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
                          )),
                    ),
                    FadeAnimation(
                      0.7,
                      Container(
                        child: TextField(
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: "Enter Email here"),
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          controller: emailController,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeAnimation(
                      0.9,
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                      1.1,
                      Container(
                        child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: "Enter Password here"),
                          obscureText: true,
                          obscuringCharacter: '*',
                          controller: passController,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    FadeAnimation(
                      1.3,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                              value: _checkBox,
                              onChanged: (value) {
                                setState(() {
                                  _checkBox = !_checkBox;
                                });
                              }),
                          Text(
                            'I agree to the',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          TextButton(
                              onPressed: () {}, //Missing T&C function
                              child: Text('Terms & Conditions',
                                  style: TextStyle(fontSize: 16))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    FadeAnimation(
                      1.5,
                      SizedBox(
                        height: 60,
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            if (checkStates(
                                    userController.text.trim(),
                                    emailController.text.trim(),
                                    passController.text.trim(),
                                    _checkBox) ==
                                true) {
                              print(
                                "Username is ${userController.value.text.toString()}",
                              );
                              print(
                                "Password is ++++ ${passController.value.text.toString()}",
                              );
                              print(
                                "email is ++++ ${emailController.value.text.toString()}",
                              );
                              registerUser(
                                userController.value.text.toString(),
                                emailController.value.text.toString(),
                                passController.value.text.toString(),
                              );
                            }
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 20),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                              return global_color_2_blue;
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                      1.7,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Have an account?",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/loginUser');
                              },
                              child:
                                  Text('Login', style: TextStyle(fontSize: 16)))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  bool checkStates(
      String userBox, String emailBox, String passBox, bool checkBox) {
    int i = 0;
    bool checkFlag = false;
    var errorArray = [];

    errorArray.add('Please fill in');

    if (checkBox == false) {
      i++;
      errorArray.add('checkbox');
    }
    if (userBox.isEmpty) {
      i++;
      errorArray.add('username');
    }
    if (emailBox.isEmpty ||
        ((emailBox.contains('@') && emailBox.contains('.com')) == false)) {
      i++;
      errorArray.add('valid email');
    }
    if (passBox.isEmpty) {
      i++;
      errorArray.add('password');
    }

    if (i == 0) {
      checkFlag = true;
    } else {
      popUpDialog('Missing entry', errorArray.join(" "));
    }

    return checkFlag;
  }

  registerUser(String username, String email, String password) async {
    Map data = <String, String>{
      "username": username,
      "email": email,
      "password": password
    };
    String jsonData = jsonEncode(data);
    var response = await http.post(registerURL, body: jsonData);
    if (response.statusCode == 201) {
      setState(() {
        isLoading = false;
      });
      popUpDialog('Welcome to WhoseDoc!', 'Registration Successful');
      Future.delayed(const Duration(milliseconds: 4000), () {
        //Navigator.pop(context, '/registerUser');
      });
    } else {
      setState(() {
        isLoading = false;
      });
      popUpDialog('Error!', 'An error occured. Please try again.');
    }
  }

  popUpDialog(String titleMsg, String bodyMsg) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(titleMsg),
        content: Text(bodyMsg),
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LandingPage(),
                    ),
                  );
                },
                child: const Text('Okay'),
              )
            ],
          )
        ],
      ),
    );
  }
}
