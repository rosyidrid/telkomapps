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
import 'package:telkom_apps/pages/photo/photo.dart';

class TaskPage extends StatefulWidget {
  const TaskPage(
      {Key? key,
      required this.outletid,
      required this.latitude,
      required this.longitude})
      : super(key: key);
  final outletid;
  final latitude;
  final longitude;
  @override
  State<TaskPage> createState() => _TaskPageState();
}

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
    location.requestService().then((value) {
      location.serviceEnabled().then((value) {
        location.requestPermission().then((value) {
          if (value == PermissionStatus.granted) {
            location.onLocationChanged.listen((value) {
              if (value != null) {
                if (!_locationController.isClosed) {
                  _locationController.add(UserLocation(
                      latitude: value.latitude, longitude: value.longitude));
                }
              }
            });
          }
        });
      });
    });
  }
  void dispose() => _locationController.close();
}

class _TaskPageState extends State<TaskPage> {
  late GoogleMapController _controller;
  double totalDistance = 0;
  List<LatLng> _loc = [];
  Set<Marker> markers = {};
  LocationService locationService = LocationService();
  var lat;
  var long;
  bool check = false;
  static const maxSeconds = 59;
  static const maxMinute = 19;
  int seconds = maxSeconds;
  int minute = maxMinute;
  Timer? timer;
  void startTime() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
        if (seconds == 0) {
          if (minute > 0) {
            setState(() {
              minute--;
            });
            seconds = maxSeconds;
          }
        }
      } else {
        setState(() {
          timer?.cancel();
          _checkout();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    NotificationAPI.init();
    check = false;
    startTime();
    locationService.locationStream.listen((event) {
      setState(() {
        lat = event.latitude;
        long = event.longitude;

        markers.add(Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          markerId: MarkerId('User'),
          infoWindow: InfoWindow(
            title: 'User',
          ),
          position: LatLng(lat, long),
        ));

        _loc.add(LatLng(lat, long));
        _loc.add(LatLng(widget.latitude, widget.longitude));

        for (var i = 0; i < _loc.length - 1; i++) {
          totalDistance = calculateDistance(_loc[i].latitude, _loc[i].longitude,
              _loc[i + 1].latitude, _loc[i + 1].longitude);
        }

        if (check == false) {
          if (totalDistance < 20.0) {
            checkin(lat, long, check);
            check = true;
          }
        }
        print(totalDistance);

        if (totalDistance > 20.0) {
          setState(() {
            checkRadius();
            timer?.cancel();
            locationService.dispose();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    locationService.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    markers.add(
      Marker(
          infoWindow: InfoWindow(
            title: 'Outlet',
          ),
          markerId: MarkerId('Outlet'),
          position: LatLng(widget.latitude, widget.longitude),
          icon: BitmapDescriptor.defaultMarker),
    );
    return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                      title: const Text("Peringatan !",
                          style: TextStyle(color: Colors.red)),
                      content: const Text(
                          'Keluar dari page ini akan menyebabkan reset terhadap waktu dan checkin anda\n\nLanjut keluar?'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              resetData();
                              willLeave = true;
                              Navigator.pop(context, true);
                            },
                            child: const Text('Yes'),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFF4949),
                            )),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('No',
                              style: TextStyle(color: Colors.green)),
                        )
                      ]));
          return willLeave;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFF4949),
            title: Text(
              'Task Page',
            ),
            centerTitle: true,
          ),
          body: Column(children: <Widget>[
            Container(
              height: size.height / 3,
              child: GoogleMap(
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
                      zoom: 18.5)),
            ),
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: buildTime(),
            ),
            Expanded(
                child: Container(
              width: size.width * 0.8,
              child: ListView(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhotoPage(id: 1)));
                    },
                    child: Text(
                      "Ambil Foto di Outlet",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: Color(0xFFFF4949),
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhotoPage(id: 2)));
                    },
                    child: Text(
                      "Ambil Foto Stok Digipos",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: Color(0xFFFF4949),
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhotoPage(id: 3)));
                    },
                    child: Text(
                      "Ambil Foto Nota Penjualan",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: Color(0xFFFF4949),
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhotoPage(id: 4)));
                    },
                    child: Text(
                      "Ambil Foto Promo Comp",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: Color(0xFFFF4949),
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhotoPage(id: 5)));
                    },
                    child: Text(
                      "Ambil Foto Harga EUP",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: Color(0xFFFF4949),
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            ))
          ]),
        ));
  }

  Future resetData() async {
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
    }
  }

  Widget buildTime() {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Text('$minute : $seconds',
          style: TextStyle(
              color: Color(0xFFFF4949),
              fontSize: 24,
              fontWeight: FontWeight.bold)),
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
      Widget okButton = TextButton(
        child: Text("Kembali ke Dashboard"),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => DashboardPage()),
              (route) => false);
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
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }

  checkin(lat, long, check) async {
    if (check == false) {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.get('token');
      var data = {
        "outlet_id": widget.outletid,
        "latitude": lat,
        "longitude": long
      };
      var checkin = await CallAPI().checkin(token, "checkin/radius", data);
      var body = json.decode(checkin.body);
      var message = body['message'];
      if (checkin.statusCode == 200) {
        prefs.setInt('checkin_id', body['data']['id']);

        Widget okButton = TextButton(
          child: Text("Tutup"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        );
        AlertDialog alert = AlertDialog(
          title: Text("Berhasil"),
          content: Text("$message"),
          actions: [
            okButton,
          ],
        );
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return alert;
            });
      }
    }
  }

  Future _checkout() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    var data = {
      "checkin_id": prefs.get('checkin_id'),
    };

    var checkout = await CallAPI().checkout(token, 'checkin/checkout', data);
    var body = json.decode(checkout.body);
    var message = body['message'];
    if (checkout.statusCode == 200) {
      prefs.remove('checkin_id');
      Widget okButton = TextButton(
        child: Text("Back to Dashboard"),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => DashboardPage()),
              (route) => false);
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
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    } else {
      Widget okButton = TextButton(
        child: Text("Back to Dashboard"),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => DashboardPage()),
              (route) => false);
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text("Failed"),
        content: Text("$message"),
        actions: [
          okButton,
        ],
      );

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }
}
