import 'package:flutter/material.dart';
import 'package:whose_doc/variables/globalvar.dart';

class History extends StatefulWidget {
  const History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Map<String, dynamic>> _sample_data = [
    {
      "date": "31 May 2021",
      "time": "8:30am",
      "type": "Teleconsult",
      "image": "assets/images/logo_1.png",
      "title": "Rails Family\nClinic & Surgery",
      "building": "Orchard Scotts Residence",
      "address": "5 Anthonly Road, Tower 3",
      "country": "Singapore",
      "postalcode": "Singapore 229954",
      "phone": "+65 68832883",
      "favourit": true
    },
    {
      "date": "12 Jan 2021",
      "time": "8:30am",
      "type": "Teleconsult",
      "image": "assets/images/logo_1.png",
      "title": "Rails Family\nClinic & Surgery",
      "building": "Orchard Scotts Residence",
      "address": "5 Anthonly Road, Tower 3",
      "country": "Singapore",
      "postalcode": "Singapore 229954",
      "phone": "+65 68832883",
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
          "History",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          for (Map<String, dynamic> i in _sample_data)
            HistoryElement(
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

class HistoryElement extends StatefulWidget {
  Map<String, dynamic> data;
  Function(bool favourit) favourit_change;
  HistoryElement({Key key, this.data, this.favourit_change}) : super(key: key);

  @override
  _HistoryElementState createState() => _HistoryElementState();
}

class _HistoryElementState extends State<HistoryElement> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 282,
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
          onPressed: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.data["date"],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: global_color_6_blue),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.data["time"],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    widget.data["type"],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: global_color_6_blue),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
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
                        widget.data["building"],
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      Text(
                        widget.data["address"],
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      Text(
                        widget.data["country"] +
                            ", " +
                            widget.data["postalcode"],
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.data["phone"],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 0,
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
                        widget.data["favourit"]
                            ? Icons.star
                            : Icons.star_border,
                        color: global_color_1_blue,
                        size: 35,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 65),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/pdf_file.png",
                          height: 25,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text('Download E-Receipt',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/pdf_file.png",
                          height: 25,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text('Download E-Medical Certificate',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
