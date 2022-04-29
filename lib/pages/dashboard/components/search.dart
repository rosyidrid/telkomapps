import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';
import 'package:telkom_apps/pages/login/login.dart';
import 'dart:convert';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
            width: size.width * .8,
            child: FutureBuilder(
              future: getUser(),
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
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
            )),
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          width: size.width * .8,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(1, 1),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  hintText: "PJP",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 5,
                thickness: 1,
                indent: 5,
                endIndent: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.apartment),
                  hintText: "Nama Outlet",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  logOut();
                },
                child: Text(
                  "Search",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width * 0.8, 40),
                    primary: Color(0xFFFF4949),
                    textStyle: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        )
      ],
    );
  }
  //function mengambil data user
  Future<Map<String, dynamic>> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token"); //mengambil token
    var dataUser = await CallAPI().getDataUser(token, 'user'); //mengambil data user
    var user = json.decode(dataUser.body)["data"] as Map<String, dynamic>; //mengubah data user menjadi map
    return user; //mengembalikan data user
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token"); //mengambil token
    var logout = await CallAPI().logout(token, 'logout'); //melakukan post token ke api logout
    if (logout.statusCode == 200) { //jika status code logout 200 maka akan diarahkan ke halaman login
      prefs.remove("token");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return LoginPage();
        }),
      );
    }
  }
}
