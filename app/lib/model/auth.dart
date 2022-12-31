import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  // String? _token = "token";
  num? _id;
  num? _activatedLicenseId;

  Auth(String? token) {
    if (token != null) {
      // _token = token;
      // notifyListeners();
    }
  }

  // get token => _token;

  num? get activateLicenseId => _activatedLicenseId;

  num? get id => _id;

  Future<num?> login(String email, String password) async {
    var response = await http.post(
        Uri.parse("${dotenv.get("SERVER")}/api/vendor/login"),
        body: jsonEncode({"email": email, "password": password}));
    debugPrint(response.body);
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 202) {
      Map<String, dynamic> data = json.decode(response.body);
      // _token = data["jwt"];
      _id = data["id"];
      _activatedLicenseId = data["licenseId"];
      notifyListeners();
      return data["licenseId"];
    }
    return null;
  }
}
