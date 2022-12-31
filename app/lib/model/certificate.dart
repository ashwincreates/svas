import 'dart:convert';
import 'dart:io';

import 'package:app/UI/new_certificate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum Status { verified, applied, notApplied }

class Info {
  String firstName = "";
  String middleName = "";
  String lastName = "";
  String bussinessName = "";
}

class Certificate with ChangeNotifier {
  num? certificateId;
  Status status = Status.notApplied;
  Info info = Info();

  Future<void> getCertificate(num? id) async {
    debugPrint("Fetching Certificate");
    try {
      var response = await http.get(
          Uri.parse("${dotenv.get("SERVER")}/api/certificate/retrieve/$id"));
      if (response.statusCode == HttpStatus.accepted) {
        Map<String, dynamic> data = json.decode(response.body);
        certificateId = data["id"];
        debugPrint("certificateId: $certificateId");
        if (data["status"] == "SIGNED") {
          status = Status.verified;
        } else {
          status = Status.applied;
        }
        info.firstName = data["firstName"];
        info.middleName = data["middleName"];
        info.lastName = data["lastName"];
        info.bussinessName = data["bussinessName"];
		notifyListeners();
      }
    } on Exception {
      debugPrint("Network Error occured");
    }
  }

  Future<void> submitCertificate(CertificateInfo cert) async {
    try {
      var response = await http.post(
          Uri.parse("${dotenv.get("SERVER")}/api/certificate/create"),
          body: jsonEncode(cert.toMap()));
      if (response.statusCode == HttpStatus.accepted) {
        Map<String, dynamic> data = json.decode(response.body);
        certificateId = data["id"];
        info.firstName = cert.firstName;
        info.middleName = cert.middleName ?? "";
        info.lastName = cert.lastName ?? "";
        info.bussinessName = cert.bussinessName;
        status = Status.applied;
        notifyListeners();
      }
    } on Exception {
      debugPrint("Failed to submit certificate");
    }
  }
}
