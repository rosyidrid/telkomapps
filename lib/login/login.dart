import 'package:flutter/material.dart';
import 'package:telkom_apps/API/api.dart';
import 'package:telkom_apps/home.dart';
import 'package:telkom_apps/login/components/head.dart';
import 'package:telkom_apps/login/components/form.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color(0xFFFF4949),
    ));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[Head(), FormPage()],
        ));
  }

  Future _doLogin(BuildContext context) async {
    // var[array] data
    var userLogin = {
      'username': username.text,
      'password': password.text,
    };

    // response login
    var resLogin = await CallAPI().postData(userLogin, 'login');
    var bodyLogin = json.decode(resLogin.body);
    //cek apakah login berhasil
    if (resLogin.statusCode == 200) {
      //jika iya maka
      //data akan di username dan token akan di simpan di localstorage
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('username', bodyLogin['data']['name']);
      localStorage.setString('token', bodyLogin['data']['token']);
      //setelah di simpen di localstorage
      //page berganti kehalaman home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return Home();
        }),
      );
    } else {
      //jika gagal
      //akan memuncul kan pop up message
      var message = bodyLogin['message'];
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
