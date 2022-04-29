import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telkom_apps/pages/dashboard/components/listview.dart';
import 'package:telkom_apps/pages/dashboard/components/search.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: size.width,
            padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
            decoration: BoxDecoration(
                image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage('assets/image/jpeg/dashboard.png'),
            )),
            child: Search(),
          ),
          Text("Hasil Pencarian : ",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Container(
            child: ListViewPage(),
          )
        ],
      ),
    ));
  }
}
