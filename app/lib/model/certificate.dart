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
  String? certificateId;
  Status status = Status.notApplied;
  Info info = Info();

  Future<void> getCertificate(String id) async {
    try {
		var response = await http
          .get(Uri.parse("${dotenv.get("SERVER")}/api/get_certificate/$id"));
		if (response.statusCode == HttpStatus.ok) {
			Map<String, dynamic> data = json.decode(response.body);
			certificateId = data["certificate_id"];
			debugPrint("certificateId: $certificateId");
			if (data["status"] == "SIGNED") {
				status = Status.verified;
			} else {
				status = Status.applied;
			}
			info.firstName = data["first_name"];
        	info.middleName = data["middle_name"];
        	info.lastName = data["last_name"];
        	info.bussinessName = data["bussiness_name"];
		}
    } on Exception {
		debugPrint("Network Error occured");
    }
  }

  Future<void> submitCertificate(CertificateInfo cert) async {
    try {
        var response = await http
                .post(Uri.parse("${dotenv.get("SERVER")}/api/create_ceritificate"), body: jsonEncode(cert.toMap()));
        if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
            Map<String, dynamic> data = json.decode(response.body);
            certificateId = data["certificate_id"];
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

