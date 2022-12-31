import 'dart:async';

import 'package:app/model/area.dart';
import 'package:app/partials/areaCard.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition defaultCameraPosition =
      const CameraPosition(target: LatLng(23.1815, 79.9864), zoom: 15);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Area area = Provider.of<Area>(context, listen: false);
      area.getArea("jabalpur");
    });
  }

  @override
  Widget build(BuildContext context) {
    final PageController pcontroller = PageController();
    Area area = Provider.of<Area>(context);
    return Stack(children: [
      GoogleMap(
        rotateGesturesEnabled: false,
        zoomGesturesEnabled: false,
        scrollGesturesEnabled: false,
        initialCameraPosition: area.selectedArea != null
            ? CameraPosition(target: area.selectedArea!.center!, zoom: 15)
            : defaultCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(area.areas.map((e) =>
            Marker(markerId: MarkerId(e.id.toString()), position: e.center!))),
        circles: area.selectedArea != null
            ? <Circle>{
                Circle(
                    circleId: const CircleId(""),
                    radius: area.selectedArea!.radius!.toDouble(),
                    center: area.selectedArea!.center!,
					strokeWidth: 3,
					strokeColor: Colors.blueAccent,
					fillColor: Colors.blueAccent.withOpacity(0.2)
					)
              }
            : {},
      ),
      Positioned(
        bottom: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 204,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(),
          child: PageView(
            controller: pcontroller,
            onPageChanged: ((value) async {
              AreaInfo newArea = area.areas[value];
			  area.selectedArea = newArea;
              final GoogleMapController mapController =
                  await _controller.future;
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: newArea.center!, zoom: 15)));
            }),
			children: area.areas.map((e) => AreaCard(area: e)).toList(),
          ),
        ),
      )
    ]);
  }
}
