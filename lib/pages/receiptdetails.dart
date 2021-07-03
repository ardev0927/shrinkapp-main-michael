import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:whose_doc/functions/receipt_detail_slide.dart';
import '../variables/routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whose_doc/functions/api_manager.dart';
import 'package:whose_doc/variables/models.dart';

class ReceiptDetailPage extends StatefulWidget {
  final String title;
  final int receiptID;
  ReceiptDetailPage({Key key, this.title, @required this.receiptID})
      : super(key: key);

  @override
  _MyReceiptDetailPageState createState() =>
      _MyReceiptDetailPageState(receiptID);
}

class _MyReceiptDetailPageState extends State<ReceiptDetailPage> {
  List recArr = [];
  int receiptID;
  double totalAmt = 0;
  _MyReceiptDetailPageState(this.receiptID);
  Geolocator geolocator = Geolocator();
  double _latitude;
  double _longitude;
  bool _isGettingLocation = true;
  bool _isLoadingReceipt = true;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    loadReceipt();
  }

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _isGettingLocation = false;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  loadReceipt() async {
    List tempArr = await getIndexReceiptCartItems(context, receiptID);
    for (int i = 0; i < tempArr.length; i++) {
      extractInfo(tempArr[i]);
    }
    setState(() {
      _isLoadingReceipt = false;
    });
  }

  extractInfo(ReceiptCartArr array) {
    List arr = [];
    ReceiptCartLinks recLinks = array.links;
    totalAmt += (array.totalAmt / 100);

    arr.add(webTemp + recLinks.featurePic);
    arr.add(array.brand + ' ' + array.model);
    arr.add(array.amount / 100);
    arr.add(array.quantity);

    recArr.add(arr);
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return ((_isGettingLocation == false) && (_isLoadingReceipt == false))
        ? Scaffold(
            body: SafeArea(
                child: SlidingUpPanel(
              maxHeight: totalHeight,
              renderPanelSheet: false,
              parallaxEnabled: true,
              parallaxOffset: 0.6,
              panelBuilder: (homeScrollController) =>
                  buildSlidePanel(homeScrollController: homeScrollController),
              body: FlutterMap(
                options: MapOptions(
                    zoom: 15,
                    minZoom: 10.0,
                    center: LatLng(_latitude, _longitude)),
                layers: [
                  TileLayerOptions(
                    urlTemplate: mapboxURL,
                    additionalOptions: {
                      'accessToken': mapBoxToken,
                      'id': mapBoxID
                    },
                  ),
                  MarkerLayerOptions(markers: [
                    Marker(
                        width: 45,
                        height: 45,
                        point: LatLng(_latitude, _longitude),
                        builder: (context) => Container(
                              child: IconButton(
                                  icon: Icon(Icons.location_on),
                                  color: Colors.red,
                                  iconSize: 45,
                                  onPressed: () {
                                    print(
                                        "Marker tapped"); //test marker function
                                  }),
                            )),
                  ]),
                ],
              ),
            )),
          )
        : Container(
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
          );
  }

  Widget buildSlidePanel({
    @required ScrollController homeScrollController,
  }) {
    return ReceiptSlide_Widget(
      scrollController: homeScrollController,
      receiptArr: recArr,
      totalAmt: totalAmt,
    );
  }
}
