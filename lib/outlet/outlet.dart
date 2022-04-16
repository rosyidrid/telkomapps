import 'package:flutter/material.dart';
import 'package:telkom_apps/outlet/components/details.dart';
import 'package:telkom_apps/outlet/components/image.dart';
import 'package:telkom_apps/outlet/components/performansi.dart';

class OutletPage extends StatefulWidget {
  const OutletPage({Key? key}) : super(key: key);

  @override
  State<OutletPage> createState() => _OutletPageState();
}

class _OutletPageState extends State<OutletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Outlet'),
        backgroundColor: Color(0xFFFF4949),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[Details(), Performansi()],
        ),
      ),
    );
  }
}
