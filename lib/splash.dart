import 'package:flutter/material.dart';
import 'package:telkom_apps/dashboard/dashboard.dart';
import 'package:telkom_apps/login/login.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    print(token);
    if (token != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return Dashboard();
        }),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return LoginPage();
        }),
      );
    }
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      autoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Image.asset(
            "assets/icons/icon_telkom.png",
            width: 250.0,
            height: 150.0,
          )),
          Center(
            child: Text(
              "PLAYBOOK",
              style: TextStyle(
                  color: Color(0xFFF12030),
                  fontSize: 32,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Center(
            child: Text(
              "SALES FORCE",
              style: TextStyle(
                  height: 1.0,
                  fontSize: 32,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: <Color>[Colors.yellow, Colors.red],
                    ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 70.0)),
                  fontWeight: FontWeight.w700),
            ),
          ),
          Center(
            child: Text(
              "PJP & SCORE CARD & OUTLET PROFILING",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }
}
