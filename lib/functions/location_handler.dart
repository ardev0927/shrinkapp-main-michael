import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationHandler {
  double latitude = 1.3521;
  double longitude = 103.8198;
  Geolocator geolocator;

  LocationHandler() {
    geolocator = Geolocator();
  }

  void update() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
    debugPrint("loc update" + latitude.toString());
  }
}
