import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';
import 'package:telkom_apps/pages/dashboard/dashboard.dart';
import 'package:telkom_apps/pages/map/map.dart';
import 'package:telkom_apps/pages/photo/photo.dart';

class TaskPage extends StatefulWidget {
  const TaskPage(
      {Key? key,
      required this.outletId,
      required this.latitude,
      required this.longitude})
      : super(key: key);
  final outletId;
  final latitude;
  final longitude;
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
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
    startTime();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                      title: const Text("Peringatan !",
                          style: TextStyle(color: Colors.red)),
                      content: const Text(
                          'Keluar dari page ini akan menyebabkan reset terhadap waktu anda\n\nLanjut keluar?'),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
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
              title: Text('Kerjakan Kegiatan Berikut!'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
                child: Container(
                    width: size.width,
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              buildTime(),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MapPage(
                                                  outletid: widget.outletId,
                                                  latitude: widget.latitude,
                                                  longitude: widget.longitude,
                                                )));
                                  },
                                  child: Text(
                                    "Check - In Posisi",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(size.width * 0.8, 50),
                                      primary: Color(0xFFFF4949),
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w700))),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoPage(id: 1)));
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
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.w700)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoPage(id: 2)));
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
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.w700)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoPage(id: 3)));
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
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.w700)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoPage(id: 4)));
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
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.w700)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoPage(id: 5)));
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
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )))));
  }

  Widget buildTime() {
    return Text('$minute : $seconds',
        style: TextStyle(
            color: Color(0xFFFF4949),
            fontSize: 24,
            fontWeight: FontWeight.bold));
  }

  resetData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    var id = prefs.get('checkin_id');
    var data = {'checkin_id': id};
    var reset = CallAPI().checkRadius(token, 'checkin/out-radius', data);
    if (reset.statusCode == 200) {
      prefs.remove('checkin_id');
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
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    } else {
      Widget okButton = TextButton(
        child: Text("Close"),
        onPressed: () {
          Navigator.pop(context, false);
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
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }
}
