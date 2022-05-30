import 'package:flutter/material.dart';
import 'package:telkom_apps/pages/login/components/head.dart';
import 'package:telkom_apps/pages/login/components/form.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[Head(), FormPage()],
    )));
  }
}
