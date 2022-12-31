import 'dart:ui';

import 'package:app/model/license.dart';
import 'package:app/partials/card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Licenses extends StatefulWidget {
  const Licenses({super.key});

  @override
  State<Licenses> createState() => _LicensesState();
}

class _LicensesState extends State<Licenses> {
  @override
  Widget build(BuildContext context) {
    List<LicenseInfo> lic = Provider.of<License>(context).licenses;
    LicenseInfo? activateLic = Provider.of<License>(context).activatedLicense;
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            activateLic != null
                ? LicenseCard(license: activateLic)
                : const SizedBox.shrink(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                flex: 1,
                child: ListView.separated(
                    itemBuilder: ((context, index) => LicenseCard(license: lic[index])),
                    separatorBuilder: ((context, index) => const SizedBox(height: 8)),
                    itemCount: lic.length))
          ],
        ));
  }
}
