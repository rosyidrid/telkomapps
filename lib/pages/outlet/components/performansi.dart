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
              style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 18)),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(
                color: Colors.grey
              )
            ),
            children: [
              TableRow(children: [
                Text("TAP", style:TextStyle(color: Colors.red)),
                Text(": Value"),
              ]),
              TableRow(children: [
                Text("rs_register_active", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
              TableRow(children: [
                Text("rs_pjp_active", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
              TableRow(children: [
                Text("rs_productive_all", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
              TableRow(children: [
                Text("rs_productive_nsb", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
              TableRow(children: [
                Text("rs_productive_omni", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
              TableRow(children: [
                Text("rs_productive_cvm", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
              TableRow(children: [
                Text("rs_productive_games", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
              TableRow(children: [
                Text("rs_productive_dls", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
              TableRow(children: [
                Text("rs_productive_voice", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
              TableRow(children: [
                Text("seltru_sp", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
              TableRow(children: [
                Text("seltru_vf", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
              TableRow(children: [
                Text("Usim", style:TextStyle(color: Colors.red)),
                Text(": value"),
              ]),
            ],
          )
        ],
      ),
    );
  }
}
