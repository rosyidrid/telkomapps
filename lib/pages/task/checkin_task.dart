import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';
import 'package:telkom_apps/pages/dashboard/dashboard.dart';
import 'package:telkom_apps/pages/login/login.dart';
import 'package:telkom_apps/pages/photo/photo.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key, required this.outletId}) : super(key: key);
  final int outletId;
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with TickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _controller;
  int levelClock = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF4949),
          title: Text('Kerjakan Kegiatan Berikut!'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                width: size.width,
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Countdown(
                            animation: StepTween(
                              begin: levelClock,
                              end: 0,
                            ).animate(_controller),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _checkin();
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
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w700)),
                          ),
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
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(size.width * 0.8, 50),
                                primary: Colors.grey[350],
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w700)),
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
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(size.width * 0.8, 50),
                                primary: Colors.grey[350],
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w700)),
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
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(size.width * 0.8, 50),
                                primary: Colors.grey[350],
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w700)),
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
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(size.width * 0.8, 50),
                                primary: Colors.grey[350],
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w700)),
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
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(size.width * 0.8, 50),
                                primary: Colors.grey[350],
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _checkout();
                            },
                            child: Text(
                              "Check - Out Posisi",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(size.width * 0.8, 50),
                                primary: Colors.grey[350],
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              logOut();
                            },
                            child: Text(
                              "Log Out",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(size.width * 0.8, 50),
                                primary: Colors.grey[350],
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }

  Future _checkin() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    var data = {
      "outlet_id": widget.outletId,
      "latitude": -12033881,
      "longitude": 1168837414
    };
    var checkin = await CallAPI().checkin(token, "checkin/radius", data);
    var body = json.decode(checkin.body);
    if (checkin.statusCode == 200) {
      prefs.setInt('checkin_id', body['data']['id']);
      var message = body['message'];
      Widget okButton = TextButton(
        child: Text("Close"),
        onPressed: () {
          Navigator.pop(context, false);
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
      var message = body['message'];
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

  Future _checkout() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    var data = {
      "checkin_id": prefs.get('checkin_id'),
    };

    var checkout = await CallAPI().checkout(token, 'checkin/checkout', data);
    var body = json.decode(checkout.body);
    if (checkout.statusCode == 200) {
      prefs.remove('checkin_id');
      var message = body['message'];
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
      var message = body['message'];
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

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token"); //mengambil token
    var logout = await CallAPI()
        .logout(token, 'logout'); //melakukan post token ke api logout
    if (logout.statusCode == 200) {
      //jika status code logout 200 maka akan  diarahkan ke halaman login
      prefs.clear(); //menghapus semua data di shared preferences
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 30,
        color: Color(0xFFFF4949),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
