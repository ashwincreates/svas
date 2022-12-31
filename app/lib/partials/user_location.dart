import 'dart:async';

import 'package:app/model/area.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocation extends StatefulWidget {
  final AreaInfo area;
  const UserLocation({Key? key, required this.area}) : super(key: key);

  @override
  State<UserLocation> createState() => UserLocationState();
}

class UserLocationState extends State<UserLocation> {
  final Completer<GoogleMapController> gcontroller =
      Completer<GoogleMapController>();
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: widget.area.center!, zoom: 15),
          onMapCreated: ((controller) {
            gcontroller.complete(controller);
          }),
		  myLocationButtonEnabled: true,
        ));
  }
}
