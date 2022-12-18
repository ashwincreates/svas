import 'package:flutter/material.dart';

class LicenseCard extends StatefulWidget {
  const LicenseCard({super.key});

  @override
  State<LicenseCard> createState() => _LicenseCardState();
}

class _LicenseCardState extends State<LicenseCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 5,
            child: ExpansionTile(
              tilePadding: const EdgeInsets.fromLTRB(0, 0, -32, 0),
              backgroundColor: Colors.blue.shade100,
              collapsedBackgroundColor: Colors.blue.shade100,
              trailing: const SizedBox.shrink(),
              title: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
                height: 175,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "V",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey),
                        ),
                        Text("License Id")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Addresss of location \nwhere license is valid in"),
                        Text("valid till:\nDate", textAlign: TextAlign.right,)
                      ],
                    ),
                  ],
                ),
              ),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                              ),
                              onPressed: () => {},
                              child: Text("Activate"))),
                      const SizedBox(width: 8),
                      Expanded(
                          child: TextButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                              ),
                              onPressed: () => {},
                              child: Text("Renew"))),
                    ],
                  ),
                )
              ],
            )));
  }
}
