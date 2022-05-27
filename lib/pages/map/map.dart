import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';
import 'package:telkom_apps/API/notification.dart';
import 'package:telkom_apps/pages/dashboard/dashboard.dart';

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

class UserLocation {
  UserLocation({required this.latitude, required this.longitude});
  final latitude;
  final longitude;
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;
  var long;
  var lat;
  double totalDistance = 0;
  List<LatLng> _loc = [];
  Set<Marker> markers = {};
  Location location = Location();
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;
  _MapPageState() {
    location.requestService().then((value) {
      location.serviceEnabled().then((value) {
        location.requestPermission().then((value) {
          if (value == PermissionStatus.granted) {
            location.onLocationChanged.listen((value) {
              if (value != null) {
                _locationController.add(UserLocation(
                    latitude: value.latitude, longitude: value.longitude));
                // lat = value.latitude;
                // long = value.longitude;
                // _loc.add(LatLng(lat, long));
                // _loc.add(LatLng(widget.latitude, widget.longitude));
                // for (var i = 0; i < _loc.length - 1; i++) {
                //   totalDistance = calculateDistance(
                //       _loc[i].latitude,
                //       _loc[i].longitude,
                //       _loc[i + 1].latitude,
                //       _loc[i + 1].longitude);
                // }

                checkin(value.latitude, value.longitude);
                // print(totalDistance);
                // if (totalDistance > 5.0) {
                //   checkRadius();
                // }
              }
            });
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    NotificationAPI.init();
  }

  @override
  Widget build(BuildContext context) {
    markers.add(
      Marker(
          infoWindow: InfoWindow(
            title: 'Outlet',
          ),
          markerId: MarkerId('Outlet'),
          position: LatLng(widget.latitude, widget.longitude),
          icon: BitmapDescriptor.defaultMarker),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF4949),
        title: Text(
          'Lihat Peta',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<UserLocation>(
          stream: locationStream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              markers.add(Marker(
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
                markerId: MarkerId('User'),
                infoWindow: InfoWindow(
                  title: 'User',
                ),
                position:
                    LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
              ));
            }
            return GoogleMap(
                mapType: MapType.normal,
                circles: Set.from([
                  Circle(
                      circleId: CircleId('Outlet'),
                      center: LatLng(widget.latitude, widget.longitude),
                      radius: 20,
                      fillColor: Color.fromARGB(82, 138, 138, 138),
                      strokeColor: Colors.red,
                      strokeWidth: 1)
                ]),
                markers: markers,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (controller) => _controller = controller,
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 19));
          }),
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 1000 * 12742 * asin(sqrt(a));
  }

  Future checkRadius() async {
    final prefs = await SharedPreferences.getInstance();

    var token = prefs.get('token');
    var id = prefs.get('checkin_id');
    var data = {
      "checkin_id": id,
    };

    var check = await CallAPI().checkRadius(token, 'checkin/out-radius', data);
    var body = json.decode(check.body);
    var message = body['message'];
    if (check.statusCode == 200) {
      prefs.remove('checkin_id');
      // NotificationAPI.showNotification(title: 'Alert!', body: message);
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => DashboardPage()),
      //     (route) => false);
      Widget okButton = TextButton(
        child: Text("Kembali ke Outlet"),
        onPressed: () {
          Navigator.pop(context, false);
          Navigator.pop(context, false);
          Navigator.pop(context, false);
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text("Peringatan !"),
        content: Text("$message"),
        actions: [
          okButton,
        ],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }

  checkin(latitude, longitude) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    var data = {
      "outlet_id": widget.outletid,
      "latitude": latitude,
      "longitude": longitude
    };

    var checkin = await CallAPI().checkin(token, "checkin/radius", data);
    var body = json.decode(checkin.body);
    var message = body['message'];
    if (checkin.statusCode == 200) {
      prefs.setInt('checkin_id', body['data']['id']);
      NotificationAPI.showNotification(title: 'Berhasil', body: message);

      // Widget okButton = TextButton(
      //   child: Text("Tutup"),
      //   onPressed: () {
      //     Navigator.pop(context, false);
      //   },
      // );
      // AlertDialog alert = AlertDialog(
      //   title: Text("Berhasil"),
      //   content: Text("$message"),
      //   actions: [
      //     okButton,
      //   ],
      // );
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return alert;
      //     });

    }
  }
}
