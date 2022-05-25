import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width * .8,
        child: FutureBuilder(
          future: getUser(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.account_circle_rounded,
                      color: Colors.white, size: 60),
                  Flexible(
                      child: Text("${snapshot.data?['name']}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)))
                ]);
          },
        ));
  }

  //function mengambil data user
  Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token"); //mengambil token
    var dataUser =
        await CallAPI().getDataUser(token, 'user'); //mengambil data user
    var user = json.decode(dataUser.body)["data"]
        as Map<String, dynamic>; //mengubah data user menjadi map
    return user; //mengembalikan data user
  }
}
