import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';

class UserLocation {
  UserLocation({required this.latitude, required this.longitude});
  final latitude;
  final longitude;
}

class LocationService {
  Location location = Location();
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    location.requestPermission().then((value) {
      if (value == PermissionStatus.granted) {
        location.onLocationChanged.listen((value) {
          if (value != null) {
            _locationController.add(UserLocation(
                latitude: value.latitude, longitude: value.longitude));
          }
        });
      }
    });
  }
  bool isDisposed = false;

  void dispose() async {
    isDisposed = true;
    await _locationController.close();
  }
}

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
  late GoogleMapController _controller;
  Set<Marker> markers = {};
  LocationService locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    var isCheckin = 0;
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
          stream: locationService.locationStream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              markers.add(Marker(
                markerId: MarkerId('User'),
                infoWindow: InfoWindow(
                  title: 'User',
                ),
                position:
                    LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
              ));
              if (isCheckin == 0) {
                checkin(snapshot.data!.latitude, snapshot.data!.longitude,
                    isCheckin);
                isCheckin = 1;
              }
            }
            return GoogleMap(
                mapType: MapType.normal,
                circles: Set.from([
                  Circle(
                      circleId: CircleId('Outlet'),
                      center: LatLng(widget.latitude, widget.longitude),
                      radius: 20,
                      fillColor: Color.fromARGB(83, 221, 221, 221),
                      strokeColor: Colors.red,
                      strokeWidth: 1)
                ]),
                markers: markers,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (controller) => _controller = controller,
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 25));
          }),
      // body:
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {},
        label: Text('Syncronize'),
        backgroundColor: Color(0xFFFF4949),
        icon: Icon(Icons.location_history),
      ),
    );
  }

  checkin(latitude, longitude, isCheckin) async {
    if (isCheckin == 0) {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.get('token');
      var data = {
        "outlet_id": widget.outletid,
        "latitude": latitude,
        "longitude": longitude
      };
      var checkin = await CallAPI().checkin(token, "checkin/radius", data);
      var body = json.decode(checkin.body);
      if (checkin.statusCode == 200) {
        prefs.setInt('checkin_id', body['data']['id']);
        prefs.setBool('checkin', true);
        var message = body['message'];
        Widget okButton = TextButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.pop(context, true);
          },
        );
        AlertDialog alert = AlertDialog(
          title: Text("Success"),
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
    } else {}
  }
}
