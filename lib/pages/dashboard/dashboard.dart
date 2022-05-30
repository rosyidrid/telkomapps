import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';
import 'package:telkom_apps/pages/dashboard/components/user.dart';
import 'package:telkom_apps/pages/login/login.dart';
import 'package:telkom_apps/pages/outlet/outlet.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  TextEditingController pjp = new TextEditingController();
  TextEditingController nama_outlet = new TextEditingController();
  var data = [];
  List<Container> array = [];
  var filterData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
        decoration: BoxDecoration(
            image: DecorationImage(
          alignment: Alignment.topCenter,
          image: AssetImage('assets/image/jpeg/dashboard.png'),
        )),
        child: Column(children: <Widget>[
          User(),
          Column(
            children: <Widget>[
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
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        array = [];
                        _search();
                      },
                      controller: pjp,
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
                      height: 8,
                      thickness: 1,
                      indent: 5,
                      endIndent: 12,
                    ),
                    TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        array = [];
                        _search();
                      },
                      controller: nama_outlet,
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
                        array = [];
                        _search();
                        FocusScope.of(context).unfocus();
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
              ),
            ],
          ),
          filterData.length == 0
              ? Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.search_off, color: Colors.grey, size: 60),
                      Text(
                        "Tidak ada data",
                      )
                    ],
                  ),
                )
              : Text("Hasil Pencarian : ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Expanded(
              child: Container(
            width: size.width * .8,
            child: ListView(
              children: array,
            ),
          )),
          SizedBox(height: 50)
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Widget yesButton = TextButton(
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context, false);
                logOut();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFF4949),
              ));

          Widget noButton = TextButton(
            child: Text("No", style: TextStyle(color: Colors.green)),
            onPressed: () {
              Navigator.pop(context, false);
            },
          );

          AlertDialog alert = AlertDialog(
            title: Text("Peringatan !", style: TextStyle(color: Colors.red)),
            content: Text("Apakah anda yakin ingin logout?"),
            actions: [yesButton, noButton],
          );

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              });
        },
        label: Text('Logout'),
        backgroundColor: Color(0xFFFF4949),
        icon: Icon(Icons.exit_to_app),
      ),
    );
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
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

  _search() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    var url = 'detail-data/';
    var search = await CallAPI().getDataOutletPJP(token, url);
    var body = json.decode(search.body);
    data = [];
    for (var i in body['data']) {
      data.add(i);
    }
    if (pjp.text != "") {
      filterData = data
          .where(
              (element) => element['hari'].toString().toLowerCase() == pjp.text)
          .toList();
    } else {
      if (nama_outlet.text == "") {
        filterData = [];
      } else {
        filterData = data
            .where((element) => element['namaoutlet']
                .toString()
                .toLowerCase()
                .contains(nama_outlet.text))
            .toList();
      }
    }

    setState(() {
      for (var i = 0; i < filterData.length; i++) {
        var content = Container(
          width: MediaQuery.of(context).size.width * .8,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OutletPage(outlet: filterData[i])));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    "${filterData[i]['outlet_id']} - ${filterData[i]['namaoutlet']}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on, color: Colors.grey, size: 14),
                    Text(" ${filterData[i]['kota']}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        )),
                  ],
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
                primary: Colors.white,
                minimumSize: Size(MediaQuery.of(context).size.width, 100)),
          ),
        );
        array.add(content);
      }
    });
  }
}
