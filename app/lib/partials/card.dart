import 'package:app/model/area.dart';
import 'package:app/model/license.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LicenseCard extends StatefulWidget {
  final LicenseInfo license;
  const LicenseCard({super.key, required this.license});

  @override
  State<LicenseCard> createState() => _LicenseCardState();
}

class _LicenseCardState extends State<LicenseCard> {
  bool expanded = false;
  bool inArea = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.license.activated == true) {
        expanded = true;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.license.activated) {
        Area area = Provider.of<Area>(context, listen: false);
        area.isInRange(widget.license.area!).then((inRange) {
          setState(() {
            debugPrint("Changing Range State to $inRange");
            inArea = inRange;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    License lic = Provider.of<License>(context);
    return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 5,
            child: ExpansionTile(
              tilePadding: const EdgeInsets.fromLTRB(0, 0, -32, 0),
              backgroundColor: widget.license.activated
                  ? Colors.blue.shade100
                  : Colors.grey.shade100,
              collapsedBackgroundColor: widget.license.activated
                  ? Colors.blue.shade100
                  : Colors.grey.shade100,
              trailing: const SizedBox.shrink(),
              title: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
                height: 175,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "V",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic,
                              color: Colors.blueGrey),
                        ),
                        Text(
                          "sva${(widget.license.licenseId! + 100000).toString()}",
                          style: GoogleFonts.robotoMono(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.6),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Address",
                              style: GoogleFonts.robotoMono(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.6),
                            ),
                            SizedBox(
                              width: 150,
                              child: Text(
                                widget.license.area!.address!,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "valid till",
                              style: GoogleFonts.robotoMono(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.6),
                            ),
                            SizedBox(
                                width: 150,
                                child: Text(
                                  widget.license.validTill!
                                      .toIso8601String()
                                      .substring(0, 10),
                                  textAlign: TextAlign.right,
                                )),
                            widget.license.activated
                                ? Text(
                                    inArea ? "Permitted" : "No Permit",
                                    style: GoogleFonts.robotoMono(
                                        color: inArea
                                            ? Colors.green
                                            : Colors.redAccent,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.6),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                              onPressed: () =>
                                  lic.activateLicense(widget.license.licenseId),
                              child: const Text("Activate"))),
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
                              child: const Text("Renew"))),
                    ],
                  ),
                )
              ],
            )));
  }
}
