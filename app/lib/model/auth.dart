import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token = "token";
  String? _id = "4364f47e-be44-43d9-ae4a-2227195277b5";

  Auth(String? token) {
    if (token != null) {
      _token = token;
      notifyListeners();
    }
  }

  get token => _token;

  get id => _id;

  Future<String> login(String email, String password) async {
    var response = await http.post(
        Uri.parse("${dotenv.get("SERVER")}/api/login_vendor"),
        body: jsonEncode({"email": email, "password": password}));
    Map<String, dynamic> data = json.decode(response.body);
    debugPrint(response.body);
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      _token = data["jwt"];
      _id = data["id"];
      debugPrint(data["message"]);
      notifyListeners();
      return data["message"];
    } else {
      debugPrint(data["error"]);
      return data["error"];
    }
  }
}

