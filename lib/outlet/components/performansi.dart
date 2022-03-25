import 'package:flutter/material.dart';

class Performansi extends StatefulWidget {
  const Performansi({Key? key}) : super(key: key);

  @override
  State<Performansi> createState() => _PerformansiState();
}

class _PerformansiState extends State<Performansi> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("PERFORMANSI",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        ],
      ),
    );
  }
}
