import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/login/login.dart';
import 'dart:convert';
import 'API/api.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  "Selamat Datang!",
                  style: TextStyle(
                      color: Color(0xFFF12030),
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    this._doLogout(context);
                  },
                  child: Text("Logout"))
            ]),
      ),
    );
  }

  Future _doLogout(BuildContext context) async {
    //ambil fungsi sharePreferences
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokenUser =
        localStorage.getString('token'); //ambil token dari localstorage
    var resUser = await CallAPI()
        .getDataUser(tokenUser, 'logout'); //panggil function REST API logout
    var bodyUser = json.decode(resUser.body);
    //pengecekan apakah token berhasil di hapus dari database
    if (bodyUser['success'] == true) {
      //jika iya maka
      //page beralih ke halaman login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return LoginPage();
        }),
      );
    } else {
      //jika tidak maka muncul pop up gagal log out
      var message = "Logout Gagal";
      Widget okButton = TextButton(
        child: Text("Close"),
        onPressed: () {
          Navigator.pop(context, false);
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text("Error Login"),
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
