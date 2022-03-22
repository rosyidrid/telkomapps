import 'package:flutter/material.dart';
import 'package:telkom_apps/splash.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayBook Sales Force',
      theme: ThemeData(
        fontFamily: "Poppins",
      ),
      home: SplashScreenPage(),
    ));
