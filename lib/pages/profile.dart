import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:whose_doc/functions/api_manager.dart';
import 'package:whose_doc/functions/error_handles.dart';
import 'package:whose_doc/pages/homepage.dart';
import 'package:whose_doc/variables/globalvar.dart';
import 'package:whose_doc/variables/routes.dart';
import 'package:whose_doc/variables/models.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/ShimmerCard.dart';

class PermissionsService {
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  /// Requests the users permission to read their contacts.
  Future<bool> requestStoragePermission() async {
    return _requestPermission(PermissionGroup.storage);
  }

  /// Requests the users permission to read their location when the app is in use
  // Future<bool> requestPhotoPermission() async {
  //   return _requestPermission(PermissionGroup.photos);
  // }

  Future<bool> hasStoragePermission() async {
    return hasPermission(PermissionGroup.contacts);
  }

  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus =
        await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }
}

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PickedFile image;
  File _rotatedImage = null;
  final _picker = ImagePicker();
  TextEditingController _lastname_controller;
  TextEditingController _givenname_controller;
  TextEditingController _countrycode_controller;
  TextEditingController _mobilenumber_controller;
  TextEditingController _idnumber_controller;
  TextEditingController _allergy_controller;
  TextEditingController _conditions_controller;
  String _designation_value;
  String _idtype_value;
  String _nationality_value;
  String fullName = 'default';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadInitialValues();
    PermissionsService().requestStoragePermission();
  }

  // Future getImage() async {
  //   final image = await _picker.getImage(source: ImageSource.gallery);
  //   if (image != null && image.path != null) {
  //     File rotatedImage =
  //         await FlutterExifRotation.rotateImage(path: image.path);

  //     if (image != null) {
  //       setState(() {
  //         _rotatedImage = rotatedImage;
  //       });
  //     }
  //   }
  // }

  loadInitialValues() async {
    DetailedUserInfo detailedUserInfo = await getDetailedUserInfo(context);

    if (detailedUserInfo.lastName.isNotEmpty) {
      _lastname_controller =
          TextEditingController(text: detailedUserInfo.lastName);
    } else {
      _lastname_controller = TextEditingController(text: "");
    }

    if (detailedUserInfo.givenName.isNotEmpty) {
      _givenname_controller =
          TextEditingController(text: detailedUserInfo.givenName);
    } else {
      _givenname_controller = TextEditingController(text: "");
    }

    if (detailedUserInfo.countryCode.isNotEmpty) {
      _countrycode_controller =
          TextEditingController(text: detailedUserInfo.countryCode);
    } else {
      _countrycode_controller = TextEditingController(text: "");
    }

    if (detailedUserInfo.phoneNo.isNotEmpty) {
      _mobilenumber_controller =
          TextEditingController(text: detailedUserInfo.phoneNo.substring(3));
    } else {
      _mobilenumber_controller = TextEditingController(text: "");
    }

    if (detailedUserInfo.idReg.isNotEmpty) {
      _idnumber_controller =
          TextEditingController(text: detailedUserInfo.idReg);
    } else {
      _idnumber_controller = TextEditingController(text: "");
    }

    if (detailedUserInfo.allergies.isNotEmpty) {
      _allergy_controller =
          TextEditingController(text: detailedUserInfo.allergies);
    } else {
      _allergy_controller = TextEditingController(text: "");
    }

    if (detailedUserInfo.preExisitngCon.isNotEmpty) {
      _conditions_controller =
          TextEditingController(text: detailedUserInfo.preExisitngCon);
    } else {
      _conditions_controller = TextEditingController(text: "");
    }

    if (detailedUserInfo.designation.isNotEmpty) {
      _designation_value = detailedUserInfo.designation;
    } else {
      _designation_value = "Select Designation";
    }

    if (detailedUserInfo.idType.isNotEmpty) {
      _idtype_value = detailedUserInfo.idType;
    } else {
      _idtype_value = "Select ID Type";
    }

    if (detailedUserInfo.nationality != null) {
      _nationality_value = detailedUserInfo.nationality;
    } else {
      _nationality_value = "Select Nationality";
    }

    if (detailedUserInfo.givenName.isNotEmpty &&
        detailedUserInfo.lastName == null) {
      fullName = detailedUserInfo.givenName;
    } else if (detailedUserInfo.givenName == null &&
        detailedUserInfo.lastName.isNotEmpty) {
      fullName = detailedUserInfo.lastName;
    } else {
      fullName = detailedUserInfo.givenName + ' ' + detailedUserInfo.lastName;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: global_color_6_blue,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
        ),
        title: Text(
          "My Profile",
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: totalWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    image == null
                        ? ClipOval(
                            child: Image.network(
                              webTemp + profilePicLink,
                              width: 95,
                              height: 95,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(
                            child: Image.file(
                              _rotatedImage,
                              width: 95,
                              height: 95,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () async {
                            image = await _picker.getImage(
                              imageQuality: 20,
                              source: ImageSource.gallery,
                            );
                            image != null
                                ? imageDialog(
                                    context,
                                    File(image.path),
                                  )
                                : null;

                            if (image != null) {
                              setState(() {
                                _rotatedImage = File(image.path);
                              });
                            }
                          },
                          child: ClipOval(
                            child: Container(
                              color: global_color_1_blue,
                              width: 30,
                              height: 30,
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                fullName,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: () {},
                  child: Text('Change Password',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold))),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "Personal Info",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text(
                          "Designation",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownButton<String>(
                    value: _designation_value,
                    isExpanded: true,
                    icon: Row(
                      children: [
                        Transform.translate(
                          offset: Offset(0, -10),
                          child: Transform.rotate(
                            angle: -pi / 2,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: global_color_1_blue,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                    elevation: 16,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    underline: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      height: 1,
                      color: Colors.grey,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _designation_value = newValue;
                      });
                    },
                    items: <String>[
                      'Select Designation',
                      'Mr',
                      'Ms',
                      'Mrs',
                      'Miss'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text(
                          "Last Name",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _lastname_controller,
                      autofocus: false,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                      decoration: InputDecoration(hintText: "Enter Last Name"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text(
                          "Given Name",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _givenname_controller,
                      autofocus: false,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                      decoration: InputDecoration(hintText: "Enter Given Name"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: totalWidth * 0.3,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                                  Text(
                                    "Country Code",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                  /*Text(
                                    " *",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red),
                                  ),*/
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextFormField(
                                controller: _countrycode_controller,
                                autofocus: false,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                                decoration: InputDecoration(hintText: "+65"),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Mobile Number",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                                Text(
                                  " *",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: TextFormField(
                                controller: _mobilenumber_controller,
                                autofocus: false,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                    hintText: "Enter Mobile Number"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text(
                          "ID Type. (Government Issued)",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownButton<String>(
                    value: _idtype_value,
                    isExpanded: true,
                    icon: Row(
                      children: [
                        Transform.translate(
                          offset: Offset(0, -10),
                          child: Transform.rotate(
                            angle: -pi / 2,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: global_color_1_blue,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                    elevation: 16,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    underline: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      height: 1,
                      color: Colors.grey,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _idtype_value = newValue;
                      });
                    },
                    items: <String>['Select ID Type', 'NRIC']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text(
                          "ID No. (Government Issued)",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _idnumber_controller,
                      autofocus: false,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                      decoration: InputDecoration(hintText: "Enter ID No."),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text(
                          "Nationality",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownButton<String>(
                    value: _nationality_value,
                    isExpanded: true,
                    icon: Row(
                      children: [
                        Transform.translate(
                          offset: Offset(0, -10),
                          child: Transform.rotate(
                            angle: -pi / 2,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: global_color_1_blue,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                    elevation: 16,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    underline: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      height: 1,
                      color: Colors.grey,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _nationality_value = newValue;
                      });
                    },
                    items: <String>[
                      'Select Nationality',
                      'Singaporean',
                      'Malaysian',
                      'Indonesian'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "Health Declaration",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text(
                          "Allergy",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _allergy_controller,
                      autofocus: false,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                      decoration: InputDecoration(hintText: "Enter Allergy"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text(
                          "Pre-Existing Medical Condition",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _conditions_controller,
                      autofocus: false,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                      decoration:
                          InputDecoration(hintText: "Enter Medical Condition"),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            if (checkEmpty() == false) {
                              updateProfile();
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                                borderRadius: BorderRadius.circular(5),
                              ))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool checkEmpty() {
    bool _isEmpty = false;
    int i = 0;
    List errorArr = [];

    if (_designation_value.contains('Select')) {
      i++;
      errorArr.add('designation');
    }
    if ((_lastname_controller.text).trim().isEmpty) {
      i++;
      errorArr.add('last name');
    }
    if ((_givenname_controller.text).trim().isEmpty) {
      i++;
      errorArr.add('given name');
    }
    if (((_countrycode_controller.text).trim().isEmpty) ||
        (num.tryParse(_countrycode_controller.text) == null)) {
      i++;
      errorArr.add('country code');
    }
    if (((_mobilenumber_controller.text).trim().isEmpty) ||
        (num.tryParse(_mobilenumber_controller.text) == null)) {
      i++;
      errorArr.add('mobile number');
    }
    if (_idtype_value.contains('Select')) {
      i++;
      errorArr.add('ID type');
    }
    if ((_idnumber_controller.text).trim().isEmpty) {
      i++;
      errorArr.add('ID number');
    }
    if (_nationality_value.contains('Select')) {
      i++;
      errorArr.add('nationality');
    }
    if ((_allergy_controller.text).trim().isEmpty) {
      i++;
      errorArr.add('allergy');
    }
    if ((_conditions_controller.text).trim().isEmpty) {
      i++;
      errorArr.add('pre-exisitng conditions');
    }

    if (i != 0) {
      _isEmpty = true;
      popUpDialog(context, 'Invalid Fields',
          ('These fields are invalid; ' + errorArr.join(', ')));
    }

    return _isEmpty;
  }

  updateProfile() async {
    Map data = <String, String>{
      //"about_me": null,
      //"address": null,
      "allergies": (_allergy_controller.text).trim(),
      "pre_existing": (_conditions_controller.text).trim(),
      //"building": null,
      //"country": null,
      "country_code": (_countrycode_controller.text).trim(),
      "designation": _designation_value,
      "given_name": (_givenname_controller.text).trim(),
      "id_reg": (_idnumber_controller.text).trim(),
      "id_type": _idtype_value,
      "last_name": (_lastname_controller.text).trim(),
      "nationality": _nationality_value, //never updates
      "phone": '+' +
          (_countrycode_controller.text).trim() +
          (_mobilenumber_controller.text).trim(),
      //"unit_num": null,
      //"username": "yasha",
      //"zip_code": null
    };

    String jsonData = jsonEncode(data);
    var updateURL = Uri.parse(userInfoTemp + userID.toString());
    var response = await http.put(updateURL,
        headers: <String, String>{
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
        },
        body: jsonData);

    if (response.statusCode == 200) {
      updatingDialog(context);
    } else {
      errorDialog(context, 'Could not update profile info');
    }
  }
}
