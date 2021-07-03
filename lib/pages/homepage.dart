import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:whose_doc/functions/api_manager.dart';
import 'package:whose_doc/functions/clinic_detail_widget.dart';
import 'package:whose_doc/variables/globalvar.dart';
import '../variables/globalvar.dart';
import '../variables/routes.dart';
import '../functions/tab_widget.dart';
import 'package:geolocator/geolocator.dart';
import '../Utils/CartItemData.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClinicDetail extends ChangeNotifier {
  bool clinicDetail = false;

  bool get getClinicDetail {
    return clinicDetail;
  }

  toggleDetail() {
    clinicDetail = !clinicDetail;
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  Geolocator geolocator = Geolocator();
  double _latitude;
  double _longitude;
  //MapController mapController = MapController();
  List coorArr = [];
  bool _isGettingLocation = true, _isAssigning = true;
  String fullName = 'default', proPicURL = 'default';
  int i = 0;
  int companyID = 0;
  int totalCartItems = 0;
  bool _clinic_detail =
      false; //true: clinic details; false: promos and products;

  // google map
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(1.0, 103.0), zoom: 7);

  CameraPosition _kLake;

  // TODO: use this variable to switch between tab_widget and clinic_detail_widget in the slide up panel

  @override
  void initState() {
    getCurrentLocation();
    //print("total item in cart data at init stage === ${cartData.totalItems}");
    debugPrint(":: 1");
    checkProgress().then((value) {
      updateMeta();
      //getCurrentLocation();
    });
    debugPrint(":: 2");
    getCompanyPages(context);

    super.initState();
  }

  CartItemdata cartData = new CartItemdata();

  getCurrentLocation() async {
    debugPrint("called");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("getloc setstate ${position.latitude}");
    _latitude = position.latitude;
    _longitude = position.longitude;
    _isGettingLocation = false;
    _kLake = CameraPosition(target: LatLng(_latitude, _longitude), zoom: 10);
    //mapController.move(LatLng(_latitude, _longitude), 15);
  }

  updateMeta() async {
    debugPrint("update meta");
    List tempArr = [];
    int totalCompanies = 0;
    totalCompanies = await getCompanyMeta(context);

    for (int i = 0; i < totalCompanies; i++) {
      tempArr = await getIndexCompanyBasicInfo(context, i + 1);
      debugPrint(tempArr.toString());
      coorArr.add(tempArr);
    }
    print(coorArr);
    setState(() {
      _isAssigning = false;
    });
  }

  Future<void> checkProgress() async {
    numProducts = 0;
    sessionID = '';
    await getBasicUserInfo(context); //profile pic, name
    getCartMeta(context).then((int count) {
      setState(() {
        this.totalCartItems = count;
        cartData.cartItemCount = count;
      });
    });
    debugPrint(":: checkProgress - 3 " + DateTime.now().toString());

    debugPrint("loop start " + DateTime.now().toString());
    //int totalItems = 0;lib/pages/landingPage.dart

    // for (int i = 0; i < totalItems; i++) {
    //   List tempArr = [];
    //   tempArr = await getIndexCompanyBasicInfo(context, i + 1);
    //   debugPrint(tempArr.toString());
    //   coorArr.add(tempArr);
    // }

    debugPrint("loop end " + DateTime.now().toString());
    setState(() {
      if (givenName.isNotEmpty && lastName == null) {
        fullName = givenName;
      } else if (givenName == null && lastName.isNotEmpty) {
        fullName = lastName;
      } else {
        fullName = givenName + ' ' + lastName;
      }
      proPicURL = webTemp + profilePicLink;
      debugPrint(":: checkProgress - 4 " + DateTime.now().toString());
    });
    return;
  }

  Future<void> _goToTheLake() async {
    sleep(Duration(seconds: 3));
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("id-1"),
        position: LatLng(_latitude, _longitude),
        infoWindow: InfoWindow(title: "PICK UP HERE", snippet: ""),
      ));
    });

    _controller.complete(controller);

    _goToTheLake();
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;

    return (_isAssigning == false)
        ? Scaffold(
            //appBar: AppBar(title: Text('Home Page'),),
            drawer: Drawer(
              child: Container(
                color: global_color_5_blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  proPicURL,
                                  width: 95,
                                  height: 95,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                fullName,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15),
                          child: TextButton(
                            child: Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed("/homePage");
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                child: Text(
                                  'My Profile',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("/profilePage");
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Delivery Address',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("/deliveryaddressPage");
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Receipt',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('/receiptList');
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Insurance',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("/insurancePage");
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Favourites',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("/favouritesPage");
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'History',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("/historyPage");
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                child: Text(
                                  'Sign Out',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                onPressed: () {
                                  resetButton();
                                  deleteToken(context);
                                  Navigator.pushReplacementNamed(
                                      context, '/loginUser');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    /*Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: TextButton(
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        onPressed: () {
                          resetButton();
                          Navigator.pushReplacementNamed(context, '/loginUser');
                        },
                      ),
                    )*/
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: SlidingUpPanel(
                maxHeight: totalHeight,
                renderPanelSheet: false,
                parallaxEnabled: true,
                parallaxOffset: 0.6,
                panelBuilder: (homeScrollController) => (_isAssigning == true)
                    ? Center(child: CircularProgressIndicator())
                    : buildSlidePanel(
                        homeScrollController: homeScrollController),
                body: Stack(
                  children: <Widget>[
                    _isGettingLocation == true
                        ? SizedBox()
                        : GoogleMap(
                            initialCameraPosition: _kGooglePlex,
                            onMapCreated: _onMapCreated,
                            markers: _markers,
                          ),
                    // : FlutterMap(
                    //     mapController: mapController,
                    //     options: MapOptions(
                    //         zoom: 15,
                    //         minZoom: 10.0,
                    //         center: LatLng(_latitude, _longitude)),
                    //     layers: [
                    //       TileLayerOptions(
                    //         urlTemplate: mapboxURL,
                    //         additionalOptions: {
                    //           'accessToken': mapBoxToken,
                    //           'id': mapBoxID
                    //         },
                    //       ),
                    //       MarkerLayerOptions(markers: getMarkers()),
                    //     ],
                    //   ),
                    Positioned(
                        bottom: 110,
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          width: totalWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Builder(
                                builder: (context) => ClipOval(
                                  child: Material(
                                    color: Colors.white,
                                    child: InkWell(
                                      splashColor: Colors.red[200],
                                      child: SizedBox(
                                        width: 56,
                                        height: 56,
                                        child: Icon(
                                          Icons.menu,
                                          size: 30,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      onTap: () {
                                        Scaffold.of(context).openDrawer();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
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
                                              // _goToTheLake();
                                              Navigator.pushNamed(
                                                  context, '/cartPage');
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
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        child: Text(
                                          cartData.cartItemCount.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ClipOval(
                                    child: Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        splashColor: Colors.red[200],
                                        child: SizedBox(
                                          width: 56,
                                          height: 56,
                                          child: Icon(
                                            Icons.search,
                                            size: 35,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        onTap: () {}, //Missing Search function
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            body: Container(
              height: totalHeight * 1,
              width: totalWidth * 1,
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
            ),
          );
  }

  Widget buildSlidePanel({
    @required ScrollController homeScrollController,
  }) {
    return _clinic_detail
        ? Clinic_Detail_Widget(
            scrollController: homeScrollController,
            companyID: companyID,
          )
        : TabWidget(scrollController: homeScrollController);
  }

  // List<Marker> getMarkers() {
  //   if (coorArr.isEmpty) {
  //     debugPrint("empty");
  //     List<Marker> list = [];
  //     list.add(Marker(
  //         width: 45,
  //         height: 45,
  //         point: LatLng(_latitude, _longitude),
  //         builder: (context) => Container(
  //               child: IconButton(
  //                   //hoverColor: Colors.grey,
  //                   icon: Icon(Icons.circle),
  //                   color: global_color_3_blue,
  //                   iconSize: 30,
  //                   onPressed: () {
  //                     print("Marker tapped"); //test marker function
  //                   }),
  //             )));
  //     return list;
  //   } else {
  //     debugPrint("not");
  //     List<Marker> list = [];
  //     list.add(Marker(
  //         width: 45,
  //         height: 45,
  //         point: LatLng(_latitude, _longitude),
  //         builder: (context) => Container(
  //               child: IconButton(
  //                   //hoverColor: Colors.grey,
  //                   icon: Icon(Icons.circle),
  //                   color: global_color_3_blue,
  //                   iconSize: 30,
  //                   onPressed: () {
  //                     print("Marker tapped"); //test marker function
  //                   }),
  //             )));
  //     for (int i = 0; i < coorArr.length; i++) {
  //       list.add(
  //         Marker(
  //             width: 45,
  //             height: 45,
  //             point: LatLng(coorArr[i][1], coorArr[i][2]),
  //             builder: (context) => Container(
  //                   child: IconButton(
  //                       icon: Icon(Icons.location_on),
  //                       color: Colors.red,
  //                       iconSize: 45,
  //                       onPressed: () {
  //                         setState(() {
  //                           companyID = coorArr[i][0];
  //                           if (_clinic_detail == true) {
  //                             setState(() {
  //                               _clinic_detail = false;
  //                             });
  //                           } else {
  //                             setState(() {
  //                               _clinic_detail = true;
  //                             });
  //                           }
  //                         });
  //                       }),
  //                 )),
  //       );
  //     }
  //     return list;
  //   }
  // }
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
