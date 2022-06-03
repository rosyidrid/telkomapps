import 'package:flutter/material.dart';
import 'package:telkom_apps/API/api.dart';
import 'package:telkom_apps/pages/dashboard/dashboard.dart';
import 'package:telkom_apps/pages/login/login.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  doLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    var checkinId = prefs.get('checkin_id');
    if (checkinId != null) {
      resetData(checkinId, token);
    }
    if (token != null) {
      return true;
    } else {
      prefs.clear();
      return false;
    }
  }

  Future resetData(checkinId, token) async {
    final prefs = await SharedPreferences.getInstance();

    var data = {
      "checkin_id": checkinId,
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return SplashScreen(
      navigateAfterSeconds: FutureBuilder(
        future: doLogin(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return DashboardPage();
          } else {
            return LoginPage();
          }
        },
      ),
      loaderColor: Color(0xFFFF4949),
      loadingText: Text(
        "Version 1.0",
        style: TextStyle(color: Colors.grey),
      ),
      useLoader: true,
      seconds: 4,
      photoSize: 70.0,
      image: Image.asset(
        "assets/icons/icon_telkom.png",
      ),
      title: Text(
        "PLAYBOOK\nSALES FORCE",
        textAlign: TextAlign.center,
        style: TextStyle(
            height: 1.0,
            fontSize: 32,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: <Color>[Colors.yellow, Colors.red],
              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
