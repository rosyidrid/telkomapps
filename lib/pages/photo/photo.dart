import 'package:flutter/material.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF4949),
          title: Text('Task Photo'),
          centerTitle: true,
        ),
        body: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(top: 40, bottom: 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: size.width * 0.8,
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Image.asset(
                                  "assets/image/jpeg/foto_1.jpg",
                                  width: size.width * 0.3,
                                ),
                                Text(
                                  "SALAH",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Image.asset("assets/image/jpeg/foto_2.jpg",
                                    width: size.width * 0.3),
                                Text(
                                  "BENAR",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                          ]),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          width: size.width * 0.8,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Ketentuan :",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                              Text(
                                  "1. Posisi hp dimiringkan\n2. Wajah dan Outlet terlihat jelas",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14)),
                            ],
                          )),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Ambil Foto"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFF4949),
                    minimumSize: Size(size.width * 0.8, 40),
                  ),
                )
              ]),
        ));
  }
}
