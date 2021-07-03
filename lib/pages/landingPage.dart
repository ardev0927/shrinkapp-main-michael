import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whose_doc/pages/register.dart';
import 'package:whose_doc/variables/globalvar.dart';
import 'package:custom_fade_animation/custom_fade_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whose_doc/functions/api_manager.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class LandingPage extends StatefulWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    //LocationHandler().update();
    debugPrint("in landingPage initState");
    print("api called at ${DateTime.now()}");
    SharedPreferences.getInstance().then(
      (prefs) {
        if (prefs.containsKey("isLogged")) {
          if (prefs.getBool("isLogged")) {
            setState(() {
              isReturningUser = true;
            });
            debugPrint("trying login....");
            String encryptedUsername = prefs.getString("data1");
            String encryptedPassword = prefs.getString("data2");
            final key = encrypt.Key.fromUtf8(autoLoginEncKey);
            final iv = encrypt.IV.fromLength(16);
            final encrypter = encrypt.Encrypter(encrypt.AES(key));
            loginUser(context, encrypter.decrypt64(encryptedUsername, iv: iv),
                encrypter.decrypt64(encryptedPassword, iv: iv));
            print("api call ends ${DateTime.now()}");
          }
        }
      },
    );
  }

  getCurrentLocation() async {
    debugPrint("called");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("getloc setstate ${position.latitude}");
  }

  bool isLoading = false;
  bool isReturningUser = false;
  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    return isLoading == true
        ? Container(
            height: _screen_size.height * 1,
            width: _screen_size.width * 1,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.amber,
              ),
            ),
          )
        : isReturningUser == true
            ? Scaffold(
                body: Container(
                height: _screen_size.height * 1,
                width: _screen_size.width * 1,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
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
                    SizedBox(
                      height: 10.0,
                    ),
                    // AnimatedTextKit(
                    //   animatedTexts: [
                    //     TypewriterAnimatedText(
                    //       "Please",
                    //       textStyle: TextStyle(
                    //         fontSize: 18.0,
                    //         color: Colors.amber,
                    //       ),
                    //     ),
                    //     TypewriterAnimatedText(
                    //       "Wait",
                    //       textStyle: TextStyle(
                    //         fontSize: 18.0,
                    //         color: Colors.amber,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ))
            : Scaffold(
                body: SizedBox(
                  width: _screen_size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: _screen_size.height * 0.3,
                      ),
                      FadeAnimation(
                        1,
                        Image.asset(
                          "assets/images/logo_2.png",
                          width: _screen_size.width * 0.5,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Column(
                        children: [
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterUserPage(),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>((states) {
                                      return global_color_2_blue;
                                    }),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ))),
                                child: Text(
                                  'Register',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            1.8,
                            SizedBox(
                              height: 60,
                              width: 300,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Navigator.pushNamed(context, '/loginUser');
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>((states) {
                                      return Colors.white;
                                    }),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(
                                          color: global_color_2_blue),
                                    ))),
                                child: Text(
                                  'Log In',
                                  style: TextStyle(
                                      fontSize: 20, color: global_color_2_blue),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              );
  }
}
