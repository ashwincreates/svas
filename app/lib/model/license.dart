import 'dart:convert';
import 'dart:io';

import 'package:app/UI/location.dart';
import 'package:app/model/area.dart';
import 'package:app/model/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LicenseInfo {
  num? licenseId;
  DateTime? validTill;
  AreaInfo? area;
  bool activated = false;

  LicenseInfo({this.licenseId, this.area});

  LicenseInfo.fromJson(Map<String, dynamic> json) {
    licenseId = json["Id"];
    validTill = DateTime.parse(json["ValidTill"]);
    area = AreaInfo(
        id: json["AreaId"],
        name: json["Name"],
        address: json["Address"],
        center: LatLng(json["Latitude"], json["Longitude"]),
		radius: json["Radius"]);
  }
}

class License with ChangeNotifier {
  num? _activatedLicenseId; // should be assigned while logging in
  List<LicenseInfo> licenses = [];
  LicenseInfo? activatedLicense;
  Auth? auth;

  License({this.auth});

  set activatedLicenseId(num? id) {
    debugPrint(id.toString());
    _activatedLicenseId = id;
    notifyListeners();
  }

  get activeId => _activatedLicenseId;

  Future<void> getLicenses() async {
    debugPrint("Fetching Licenses");
    try {
      var response = await http.get(
          Uri.parse("${dotenv.get("SERVER")}/api/license/retrieve/${auth!.id}"));
      if (response.statusCode == HttpStatus.ok) {
        List<LicenseInfo> licenseInfo = (json.decode(response.body) as List)
            .map((license) => LicenseInfo.fromJson(license))
            .toList();
        updateValues(licenseInfo);
      }
    } on Exception {
      debugPrint("Error Fetching Licenses");
    }
  }

  void updateValues(List<LicenseInfo> licenseinfo) {
    licenses = licenseinfo
        .where((element) => element.licenseId != _activatedLicenseId)
        .toList();
    try {
      activatedLicense = licenseinfo
          .where((element) => element.licenseId == _activatedLicenseId)
          .first;
    } catch (e) {
      activatedLicense = null;
    }
    if (activatedLicense != null) {
      activatedLicense!.activated = true;
    }
    notifyListeners();
  }

  Future<void> activateLicense(num? licenseId) async {
    debugPrint("Activating License Id: $licenseId");
    try {
      var response = await http.post(
          Uri.parse("${dotenv.get("SERVER")}/api/license/activate/$licenseId"));
      if (response.statusCode == HttpStatus.accepted) {
        _activatedLicenseId = licenseId;
        if (activatedLicense != null) {
          licenses.add(activatedLicense!);
        }
        updateValues(licenses);
        debugPrint("License Activated Id: $_activatedLicenseId");
      }
    } on Exception {
      debugPrint("Error on Activating License");
    }
  }

  Future<void> createLicense(num? areaId) async {
    debugPrint("Getting License Id: $areaId");
    try {
      var response = await http.post(
          Uri.parse("${dotenv.get("SERVER")}/api/license/create"),
          body: json.encode({'vendor_id': auth!.id, 'area_id': areaId, 'valid_till': 1}));
      if (response.statusCode == HttpStatus.ok) {
        getLicenses();
      }
    } on Exception {
      debugPrint("Failed to get license");
    }
  }
}
