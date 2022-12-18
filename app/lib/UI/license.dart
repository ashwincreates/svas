import 'dart:ui';

import 'package:app/partials/card.dart';
import 'package:flutter/material.dart';

class License extends StatefulWidget {
  const License({super.key});

  @override
  State<License> createState() => _LicenseState();
}

class _LicenseState extends State<License> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
            LicenseCard()
        ],
      ),
    );
  }
}
