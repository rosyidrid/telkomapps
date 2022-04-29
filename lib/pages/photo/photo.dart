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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: size.width * 0.9,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Image.asset("assets/image/jpeg/foto_1.jpg"),
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
                            Image.asset("assets/image/jpeg/foto_2.jpg"),
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
                ),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Ketentuan :",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20)),
                    Text(
                        "1. Posisi hp dimiringkan\n2. Wajah dan Outlet terlihat jelas",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 18)),
                  ],
                )),
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
