import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          future: getName(),
          builder: (context, snapshot) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.account_circle_rounded,
                      color: Colors.white, size: 60),
                  Flexible(
                      child: Text("${snapshot.data}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)))
                ]);
          },
        ));
  }

  //function mengambil data user
  Future getName() async {
    final prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('name');
    return name;
  }
}
