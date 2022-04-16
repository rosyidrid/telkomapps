import 'package:flutter/material.dart';
import 'package:telkom_apps/map/components/maps.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF4949),
        title: Text(
          'Lihat Peta',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: size.width,
              height: size.height * 0.6,
              child: MapScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
