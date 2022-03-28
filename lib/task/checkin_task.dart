import 'package:flutter/material.dart';
import 'package:telkom_apps/outlet/outlet.dart';
import 'package:telkom_apps/task/components/tasks.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF4949),
          title: Text('Kerjakan Kegiatan Berikut!'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) {
                return OutletPage();
              }),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                width: size.width,
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Column(
                  children: <Widget>[
                    Tasks(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) {
                            return OutletPage();
                          }),
                        );
                      },
                      child: Text(
                        "Check - In Posisi",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(size.width * 0.8, 50),
                          primary: Color(0xFFFF4949),
                          textStyle: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Ambil Foto di Outlet",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(size.width * 0.8, 50),
                          primary: Colors.grey[350],
                          textStyle: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Ambil Foto Stok Digipos",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(size.width * 0.8, 50),
                          primary: Colors.grey[350],
                          textStyle: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Ambil Foto Nota Penjualan",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(size.width * 0.8, 50),
                          primary: Colors.grey[350],
                          textStyle: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Ambil Foto Promo Comp",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(size.width * 0.8, 50),
                          primary: Colors.grey[350],
                          textStyle: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Ambil Foto Harga EUP",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(size.width * 0.8, 50),
                          primary: Colors.grey[350],
                          textStyle: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: size.width * 0.8,
                        child: OutlineButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          borderSide: BorderSide(color: Color(0xFFFF4949)),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) {
                                return OutletPage();
                              }),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Check-Out "),
                              Icon(Icons.logout),
                            ],
                          ),
                        ))
                  ],
                ))));
  }
}
