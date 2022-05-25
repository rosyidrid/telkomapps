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
  TextEditingController nama_outlet = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
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
        FutureBuilder(
            future: _search(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  heightFactor: 8,
                  child: CircularProgressIndicator(color: Color(0xFFFF4949)),
                );
              }
              List<Container> array = [];
              if (snapshot.data != null) {
                for (var i = 0; i < snapshot.data.length; i++) {
                  var content = Container(
                    width: MediaQuery.of(context).size.width * .8,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OutletPage(outlet: snapshot.data[i])));
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

                if (snapshot.data.length == 0) {
                  return Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.search_off, color: Colors.grey, size: 60),
                        Text(
                          "Tidak ada data",
                        )
                      ],
                    ),
                  );
                }
              } else {
                return Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.signal_wifi_bad_outlined,
                          color: Color.fromARGB(255, 235, 2, 2), size: 40),
                      Text(
                        "No Connection\nPlease turn on your data",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
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

  Future _search() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    var url = 'detail-data/';
    var search = await CallAPI().getDataOutletPJP(token, url);
    var body = json.decode(search.body);
    var data = [];
    for (var i in body['data']) {
      data.add(i);
    }
    var filterData;
    if (pjp.text != "") {
      filterData = data
          .where(
              (element) => element['hari'].toString().toLowerCase() == pjp.text)
          .toList();
    } else {
      filterData = data
          .where((element) =>
              element['namaoutlet'].toString().toLowerCase() ==
              nama_outlet.text)
          .toList();
    }
    return filterData;
  }
}
