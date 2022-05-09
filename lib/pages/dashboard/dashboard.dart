import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telkom_apps/pages/dashboard/components/listview.dart';
import 'package:telkom_apps/pages/dashboard/components/search.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
          Container(
            child: ListViewPage(),
          )
        ],
      ),
    ));
  }
}
