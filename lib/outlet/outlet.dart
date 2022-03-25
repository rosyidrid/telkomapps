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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[SlideImage(), Details(), Performansi()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFFF4949),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.white),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
