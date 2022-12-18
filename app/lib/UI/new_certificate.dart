import 'package:app/model/auth.dart';
import 'package:app/model/certificate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const docList = ["Aadhar", "Pan"];
const bussType = ["Food", "Merchant"];

class CertificateInfo {
    String vendorId = "";
  String firstName = "";
  String? middleName;
  String? lastName;
  String docType = "";
  String docId = "";
  String nominee1 = "";
  String? nominee2;
  String city = "";
  String state = "";
  String bussinessType = "";
  String bussinessName = "";

  Map<String, String> toMap() {
    Map<String, String> info = {
      "vendor_id": vendorId,
      "first_name": firstName,
      "middle_name": middleName ?? "",
      "last_name": lastName ?? "",
      "doc_type": docType,
      "doc_id": docId,
      "nominee1": nominee1,
      "nominee2": nominee2 ?? "",
      "address_line1": city,
      "address_line2": state,
      "address_line3": "",
      "bussiness_type": bussinessType,
      "bussiness_name": bussinessName
    };
    return info;
  }
}

class NewCertificate extends StatefulWidget {
  const NewCertificate({super.key});

  @override
  State<NewCertificate> createState() => _NewCertificateState();
}

class _NewCertificateState extends State<NewCertificate> {
  int _currentIndex = 0;
  CertificateInfo info = CertificateInfo();
  String idType = docList.first;
  String venType = bussType.first;

  var keyList = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  @override
  Widget build(BuildContext context) {
      Auth auth = Provider.of<Auth>(context);
      info.vendorId = auth.id;
      Certificate cert = Provider.of<Certificate>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apply for a new certificate"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Theme(
        data: ThemeData(
            primaryColor: Colors.blue,
            colorScheme:
                Theme.of(context).colorScheme.copyWith(primary: Colors.blue)),
        child: Stepper(
          onStepContinue: () {
            if (_currentIndex > 1 ||
                !keyList[_currentIndex].currentState!.validate()) {
              keyList[_currentIndex].currentState!.save();
              if (_currentIndex > 1) {
                cert.submitCertificate(info);
                Navigator.pop(context);
              }
              return;
            }
            keyList[_currentIndex].currentState!.save();
            setState(() {
              _currentIndex += 1;
            });
          },
          onStepCancel: () {
            if (_currentIndex <= 0) return;
            setState(() {
              _currentIndex -= 1;
            });
          },
          type: StepperType.horizontal,
          steps: [
            Step(
                title: const SizedBox.shrink(),
                content: Form(
                    key: keyList[0],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          onSaved: (value) => info.firstName = value!,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a valid name";
                            }
                            return null;
                          }),
                          decoration:
                              const InputDecoration(hintText: "First name"),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        TextFormField(
                          onSaved: (value) => info.middleName = value!,
                          decoration:
                              const InputDecoration(hintText: "Middle name"),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        TextFormField(
                          onSaved: (value) => info.lastName = value!,
                          decoration:
                              const InputDecoration(hintText: "Last name"),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text("Address"),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          onSaved: (value) => info.city = value!,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a valid city";
                            }
                            return null;
                          }),
                          decoration: const InputDecoration(hintText: "City"),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        TextFormField(
                          onSaved: (value) => info.state = value!,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a valid state";
                            }
                            return null;
                          }),
                          decoration: const InputDecoration(hintText: "State"),
                        ),
                      ],
                    ))),
            Step(
                title: const SizedBox.shrink(),
                content: Form(
                    key: keyList[1],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: DropdownButtonFormField<String>(
                                  onSaved: (newValue) =>
                                      info.docType = newValue!,
                                  value: idType,
                                  items: docList
                                      .map((String e) =>
                                          DropdownMenuItem<String>(
                                              value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (value) => {
                                    setState(() {
                                      idType = value!;
                                    })
                                  },
                                  elevation: 8,
                                )),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                onSaved: (newValue) => info.docId = newValue!,
                                validator: ((value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a valid ID";
                                  }
                                  return null;
                                }),
                                decoration:
                                    InputDecoration(hintText: "$idType Card"),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text("Nominees"),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          onSaved: (newValue) => info.nominee1 = newValue!,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a valid name";
                            }
                            return null;
                          }),
                          decoration:
                              const InputDecoration(hintText: "Nominee Name"),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        TextFormField(
                          onSaved: (newValue) => info.nominee2 = newValue!,
                          decoration:
                              const InputDecoration(hintText: "Nominee Name"),
                        ),
                      ],
                    ))),
            Step(
                title: const SizedBox.shrink(),
                content: Form(
                    key: keyList[2],
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: DropdownButtonFormField<String>(
                                  onSaved: (newValue) =>
                                      info.bussinessType = newValue!,
                                  value: venType,
                                  items: bussType
                                      .map((String e) =>
                                          DropdownMenuItem<String>(
                                              value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (value) => {
                                    setState(() {
                                      venType = value!;
                                    })
                                  },
                                  elevation: 8,
                                )),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                onSaved: (newValue) =>
                                    info.bussinessName = newValue!,
                                validator: ((value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a valid Bussiness Name";
                                  }
                                  return null;
                                }),
                                decoration: const InputDecoration(
                                    hintText: "Bussiness Name"),
                              ),
                            )
                          ],
                        ),
                      ],
                    )))
          ],
          currentStep: _currentIndex,
        ),
      ),
    );
  }
}
