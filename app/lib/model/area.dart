import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class AreaInfo {
  num? id, radius;
  String? name, address;
  LatLng? center;

  AreaInfo(
      {this.id = 0,
      this.name = "",
      this.address = "",
      this.radius = 0,
      this.center = const LatLng(0, 0)});

  AreaInfo.fromJson(Map<String, dynamic> item) {
    id = item["ID"];
    name = item["Name"];
    address = item["Address"];
    radius = item["Radius"];
    center = LatLng(item["Latitude"], item["Longitude"]);
  }
}

class Area with ChangeNotifier {
  AreaInfo? _selectedArea;
  List<AreaInfo> areas = [];

  AreaInfo? get selectedArea => _selectedArea;

  set selectedArea(AreaInfo? area) {
    if (area != null) {
      _selectedArea = area;
      notifyListeners();
    }
  }

  void getArea(String city) async {
    debugPrint("Fetching Areas");
    try {
      var response = await http
          .get(Uri.parse("${dotenv.get("SERVER")}/api/area/get/$city"));
      if (response.statusCode == 202) {
        List<AreaInfo> areaInfo = (json.decode(response.body) as List)
            .map((area) => AreaInfo.fromJson(area))
            .toList();
        areas = areaInfo;
        notifyListeners();
      }
    } on Exception {
      debugPrint("Error Fetching Areas");
    }
  }

  // Distance in KMs
  num distanceBetween(LatLng userLocation, LatLng area) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((area.latitude - userLocation.latitude) * p) / 2 +
        cos(userLocation.latitude * p) *
            cos(area.latitude * p) *
            (1 - cos((area.longitude - userLocation.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<bool> isInRange(AreaInfo area) async {
    Geolocator.requestPermission();
    Position userLocation = await getCurrentPosition();
    LatLng user = LatLng(userLocation.latitude, userLocation.longitude);
	debugPrint("${user.latitude} ${user.longitude} to ${area.center!.latitude} ${area.center!.longitude}");
    num distance = distanceBetween(user, area.center!) * 1000; // to meters;
    debugPrint("Distance: $distance, Radius: ${area.radius!}");
    return distance < area.radius!;
  }
}
