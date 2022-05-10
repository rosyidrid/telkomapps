import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';
import 'dart:convert';
import 'package:telkom_apps/pages/outlet/outlet.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController pjp = new TextEditingController();

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
                height: 8,
                thickness: 1,
                indent: 5,
                endIndent: 12,
              ),
              TextField(
                controller: pjp,
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
                  _pjp();
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
        FutureBuilder(
            future: _pjp(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              List<Container> array = [];
              for (var i = 0; i < snapshot.data.length; i++) {
                var content = Container(
                  width: MediaQuery.of(context).size.width * .8,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OutletPage(outlet: snapshot.data[i])));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "${snapshot.data[i]['outlet_id']} - ${snapshot.data[i]['namaoutlet']}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on,
                                color: Colors.grey, size: 14),
                            Text(" ${snapshot.data[i]['kota']}",
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
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 100)),
                  ),
                );
                array.add(content);
              }

              return Column(
                children: <Widget>[
                  Text("Hasil Pencarian : ",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  Column(
                    children: array,
                  )
                ],
              );
            })
      ],
    );
  }

  Future _pjp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    print(token);
    var url = 'detail-data/';
    var search = await CallAPI().getDataOutletPJP(token, url + pjp.text);
    var body = json.decode(search.body);
    var data = [];
    for (var i in body['data']) {
      data.add(i);
    }
    print(pjp.text);
    return data;
  }

  //function mengambil data user
  Future<Map<String, dynamic>> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token"); //mengambil token
    var dataUser =
        await CallAPI().getDataUser(token, 'user'); //mengambil data user
    var user = json.decode(dataUser.body)["data"]
        as Map<String, dynamic>; //mengubah data user menjadi map
    return user; //mengembalikan data user
  }
}
