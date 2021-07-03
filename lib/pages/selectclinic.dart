import 'package:flutter/material.dart';
import 'package:whose_doc/variables/globalvar.dart';

class SelectClinic extends StatefulWidget {
  const SelectClinic({Key key}) : super(key: key);

  @override
  _SelectClinicState createState() => _SelectClinicState();
}

class _SelectClinicState extends State<SelectClinic> {
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
    {
      "image": "assets/images/logo_1.png",
      "title": "Healthy Way\nClinic",
      "accepts": "Farmway Co",
      "distance": 0.3,
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
              size: 45,
            ),
          ),
          title: Text(
            "Select Clinic",
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            for (Map<String, dynamic> i in _sample_data)
              SelectClinicElement(
                data: i,
                favourit_change: (data) {},
              ),
          ]),
        ));
  }
}

// ignore: must_be_immutable
class SelectClinicElement extends StatefulWidget {
  Map<String, dynamic> data;
  Function(bool favourit) favourit_change;
  SelectClinicElement({Key key, this.data, this.favourit_change})
      : super(key: key);

  @override
  _SelectClinicElementState createState() => _SelectClinicElementState();
}

class _SelectClinicElementState extends State<SelectClinicElement> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 128,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                return Colors.white;
              }),
              padding: MaterialStateProperty.all(EdgeInsets.all(5)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ))),
          onPressed: () {
            //Navigator.of(context).pushNamed("/productPage");
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                widget.data["image"],
                width: 61,
                height: 61,
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data["title"],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    "Accepts: " + widget.data["accepts"],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: global_color_1_blue,
                      ),
                      Text(
                        widget.data["distance"].toStringAsFixed(1) + " km",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.data["favourit"] = !widget.data["favourit"];
                    });
                    widget.favourit_change(widget.data["favourit"]);
                  },
                  icon: Icon(
                    widget.data["favourit"] ? Icons.star : Icons.star_border,
                    color: global_color_1_blue,
                    size: 35,
                  ))
            ],
          )),
    );
  }
}
