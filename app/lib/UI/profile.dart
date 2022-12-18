import 'package:app/UI/new_certificate.dart';
import 'package:app/model/auth.dart';
import 'package:app/model/certificate.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Certificate certificateId = Provider.of<Certificate>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(certificateId.info.bussinessName),
              const SizedBox(height: 4),
              Text(
                "${certificateId.info.firstName} ${certificateId.info.middleName} ${certificateId.info.lastName}",
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue.shade100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text("Certificate Status"),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.verified,
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          certificateId.status == Status.verified ? "Verified" : certificateId.status == Status.applied ? "Applied - Inprogress" : "Not Applied",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    certificateId.status == Status.verified ? TextButton(
                      onPressed: () => {},
                      style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 16)),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      child: const Text("Download"),
                    ) : TextButton(
                      onPressed: certificateId.status == Status.notApplied ? apply : () => {},
                      style: ButtonStyle(
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 16)),
                        backgroundColor: MaterialStatePropertyAll(certificateId.status != Status.applied ? Colors.blue: Colors.blueGrey.shade200),
                        foregroundColor: const MaterialStatePropertyAll(Colors.white),
                      ),
                      child: certificateId.status != Status.applied ? const Text("Apply"): const Text("In progress"),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void apply() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const NewCertificate()));
  }
}
