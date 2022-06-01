import 'dart:io';
import 'package:flutter/material.dart';
import 'package:telkom_apps/pages/photo/camera.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  @override
  void initState() {
    super.initState();
  }

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
                                  "BENAR",
                                  style: TextStyle(
                                      color: Colors.green,
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
                                  "SALAH",
                                  style: TextStyle(
                                      color: Colors.red,
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
                                  "1. Posisi hp dalam keadalaan potrait/berdiri tegak\n" +
                                      "2. Objek harus terlihat jelas\n" +
                                      "3. Hindari Backlight/membelakangi cahaya",
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
                  onPressed: () {
                    Navigator.push<File>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraPage(id: widget.id)));
                  },
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
