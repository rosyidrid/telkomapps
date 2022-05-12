import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage(
      {Key? key,
      required this.outletid,
      required this.latitude,
      required this.longitude})
      : super(key: key);
  final outletid;
  final latitude;
  final longitude;
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var lat = widget.latitude;
    var long = widget.longitude;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF4949),
          title: Text(
            'Lihat Peta',
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
                mapType: MapType.normal,
                circles: Set.from([
                  Circle(
                      circleId: CircleId('Outlet'),
                      center: LatLng(lat, long),
                      radius: 10,
                      strokeColor: Colors.red,
                      strokeWidth: 1)
                ]),
                markers: {
                  Marker(
                      markerId: MarkerId('Outlet'),
                      position: LatLng(lat, long),
                      icon: BitmapDescriptor.defaultMarker)
                },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (controller) => _controller.complete(controller),
                initialCameraPosition:
                    CameraPosition(target: LatLng(lat, long), zoom: 25)),
          ],
        ));
  }
}
