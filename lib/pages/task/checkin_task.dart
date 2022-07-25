import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';
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
            location.changeSettings(
                accuracy: LocationAccuracy.high, interval: 1000);
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
  var checkin = false;
  var checkout = false;
  var e = false;
  var tombol_0;
  var tombol_1;
  var tombol_2;
  var tombol_3;
  var tombol_4;
  var tombol = [];
  var tutup;
  static const maxSeconds = 59;
  static const maxMinute = 14;
  int seconds = maxSeconds;
  int minute = maxMinute;
  Timer? timer;

  void checkTombol() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tombol_0 = prefs.get('tombol_0').toString() == 'true' ? true : false;
      tombol_1 = prefs.get('tombol_1').toString() == 'true' ? true : false;
      tombol_2 = prefs.get('tombol_2').toString() == 'true' ? true : false;
      tombol_3 = prefs.get('tombol_3').toString() == 'true' ? true : false;
      tombol_4 = prefs.get('tombol_4').toString() == 'true' ? true : false;
      tutup = prefs.get('tutup');
      tombol = [tombol_0, tombol_1, tombol_2, tombol_3, tombol_4];
    });
  }

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
          checkout = true;
        });
      }
      checkTombol();
      checkService();
    });
  }

  void checkService() {
    if (e == false) {
      locationService.location.serviceEnabled().then((value) {
        if (value != true) {
          setState(() {
            e = true;
          });
          locationService.location.requestService().then((value) {
            if (value == true) {
              setState(() {
                e = false;
              });
            } else {
              setState(() {
                e = false;
              });
            }
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkin = false;
    checkout = false;
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

        if (checkin == false) {
          if (totalDistance < 20.0) {
            _checkin(lat, long, checkin);
            checkin = true;
          }
        }

        if (totalDistance > 100.0) {
          setState(() {
            if (checkin == true) {
              checkRadius();
            }
          });
        }
        if (tutup == true) {
          setState(() {
            seconds = 0;
            minute = 0;
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
                        radius: checkin == true ? 100 : 20,
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
                      if (tombol_0 != true &&
                          checkin == true &&
                          tutup != true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoPage(id: 0)));
                      }
                    },
                    child: Text(
                      "Ambil Foto di Outlet",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: tombol_0 == false &&
                                checkin == true &&
                                tutup != true
                            ? Color(0xFFFF4949)
                            : Colors.grey[350],
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (tombol_1 != true &&
                          checkin == true &&
                          tutup != true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoPage(id: 1)));
                      }
                    },
                    child: Text(
                      "Ambil Foto Etalase",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: tombol_1 == false &&
                                checkin == true &&
                                tutup != true
                            ? Color(0xFFFF4949)
                            : Colors.grey[350],
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (tombol_2 != true &&
                          checkin == true &&
                          tutup != true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoPage(id: 2)));
                      }
                    },
                    child: Text(
                      "Ambil Foto Promo Telkomsel",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: tombol_2 == false &&
                                checkin == true &&
                                tutup != true
                            ? Color(0xFFFF4949)
                            : Colors.grey[350],
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (tombol_3 != true &&
                          checkin == true &&
                          tutup != true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoPage(id: 3)));
                      }
                    },
                    child: Text(
                      "Ambil Foto Promo Comp",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: tombol_3 == false &&
                                checkin == true &&
                                tutup != true
                            ? Color(0xFFFF4949)
                            : Colors.grey[350],
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (tombol_4 != true &&
                          checkin == true &&
                          tutup != true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoPage(id: 4)));
                      }
                    },
                    child: Text(
                      "Ambil Foto Harga EUP",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: tombol_4 == false &&
                                checkin == true &&
                                tutup != true
                            ? Color(0xFFFF4949)
                            : Colors.grey[350],
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (tutup != true &&
                          checkin == true &&
                          !tombol.contains(true)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoPage(id: 5)));
                      }
                    },
                    child: Text(
                      "Outlet Tutup",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: tutup != true &&
                                checkin == true &&
                                !tombol.contains(true)
                            ? Color(0xFFFF4949)
                            : Colors.grey[350],
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (checkout == true) {
                        _checkout();
                      }
                    },
                    child: Text(
                      "Checkout",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                        primary: checkout == true
                            ? Color(0xFFFF4949)
                            : Colors.grey[350],
                        textStyle: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 40,
                  ),
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
    if (check.statusCode == 200) {
      prefs.remove('checkin_id');
      prefs.remove('tombol_0');
      prefs.remove('tombol_1');
      prefs.remove('tombol_2');
      prefs.remove('tombol_3');
      prefs.remove('tombol_4');
      prefs.remove('tutup');
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
      timer?.cancel();
      locationService.dispose();
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

  _checkin(lat, long, check) async {
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
        startTime();
        setState(() {
          checkin = true;
        });
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
      prefs.remove('tombol_0');
      prefs.remove('tombol_1');
      prefs.remove('tombol_2');
      prefs.remove('tombol_3');
      prefs.remove('tombol_4');
      prefs.remove('checkin_id');
      prefs.remove('tutup');
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
          resetData();
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
