import 'package:flutter/material.dart';
import 'package:whose_doc/variables/globalvar.dart';

class DeliveryAddress extends StatefulWidget {
  const DeliveryAddress({Key key}) : super(key: key);

  @override
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  List<Map<String, dynamic>> _sample_data = [
    {
      "building": "Orchard Scotts Residence",
      "address": "5 Anthonly Road, Tower 3",
      "unit": "#38-132",
      "city": "Singapore",
      "country": "Singapore",
      "postalcode": "Singapore 229954",
      "default": true,
    },
    {
      "building": "Orchard Scotts Residence",
      "address": "5 Anthonly Road, Tower 3",
      "unit": "#38-132",
      "city": "Singapore",
      "country": "Singapore",
      "postalcode": "Singapore 229954",
      "default": false,
    },
    {
      "building": "Orchard Scotts Residence",
      "address": "5 Anthonly Road, Tower 3",
      "unit": "#38-132",
      "city": "Singapore",
      "country": "Singapore",
      "postalcode": "Singapore 229954",
      "default": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final _screen_size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: global_color_8_white,
      appBar: AppBar(
        backgroundColor: global_color_6_blue,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
        ),
        title: Text(
          "Delivery Address",
        ),
      ),
      body: SizedBox(
        height: _screen_size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (Map<String, dynamic> i in _sample_data)
                  DeliveryAddressElement(
                    data: i,
                  ),
                SizedBox(
                  height: 100,
                ),
              ],
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 60,
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed("/adddeliveryaddressPage");
                      },
                      child: Text(
                        'Add New Address',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                            borderRadius: BorderRadius.circular(5),
                          ))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryAddressElement extends StatefulWidget {
  Map<String, dynamic> data;
  DeliveryAddressElement({Key key, this.data}) : super(key: key);

  @override
  _DeliveryAddressElementState createState() => _DeliveryAddressElementState();
}

class _DeliveryAddressElementState extends State<DeliveryAddressElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.data["default"] = !widget.data["default"];
                    });
                  },
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    widget.data["default"]
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: global_color_1_blue,
                  )),
              SizedBox(
                width: 5,
              ),
              Text(
                'Set default address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              Expanded(
                child: SizedBox(
                  width: 5,
                ),
              ),
              IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.edit,
                    color: global_color_1_blue,
                  )),
              SizedBox(
                width: 0,
              ),
              IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.grey,
                  )),
              SizedBox(
                width: 5,
              ),
            ],
          ),
          Container(
            color: Colors.grey,
            height: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    widget.data["building"],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    widget.data["address"],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    widget.data["unit"],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    widget.data["city"] + "  " + widget.data["country"],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    widget.data["postalcode"],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
