import 'package:flutter/material.dart';
import 'package:telkom_apps/pages/task/checkin_task.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 5, color: Color(0xFFE5E5E5)))),
      width: size.width,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "192012908",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
          ),
          Text("OUTLET SHIFT MALAM",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24)),
          Row(
            children: <Widget>[
              Icon(Icons.location_on, color: Color(0xFFFF4949)),
              Flexible(
                child: Text(
                  "Jl. MT. Haryono RT. 8 No.54 Kelurahan Gn. Samarinda Baru, Kecamatan Balikpapan Utara",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                ),
              )
            ],
          ),
          OutlineButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            borderSide: BorderSide(color: Color(0xFFFF4949)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskPage()
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Check-In "),
                Icon(Icons.login),
              ],
            ),
          )
        ],
      ),
    );
  }
}
