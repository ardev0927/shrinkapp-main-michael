import 'package:flutter/material.dart';
import 'package:whose_doc/pages/selectclinic.dart';
import 'package:whose_doc/variables/globalvar.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<Map<String, dynamic>> _sample_data = [
    {
      "image": "assets/images/logo_1.png",
      "title": "Rails Family\nClinic & Surgery",
      "accepts": "Rail Insure",
      "distance": 0.2,
      "favourit": true
    },
    {
      "image": "assets/images/logo_1.png",
      "title": "Tan & Tang\nFamily Practice",
      "accepts": "Credentials",
      "distance": 0.2,
      "favourit": true
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: global_color_8_white,
      appBar: AppBar(
        backgroundColor: global_color_6_blue,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
        ),
        title: Text(
          "Favourites",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          for (Map<String, dynamic> i in _sample_data)
            SelectClinicElement(
              data: i,
              favourit_change: (data) {
                if (!data) {
                  setState(() {
                    _sample_data.remove(i);
                  });
                }
              },
            ),
        ]),
      ),
    );
  }
}
