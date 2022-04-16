import 'package:flutter/material.dart';
import 'package:telkom_apps/outlet/outlet.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  List<Container> list = [];
  List<Container> _list() {
    for (int i = 0; i < 3; i++) {
      var content = Container(
        width: MediaQuery.of(context).size.width * .8,
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OutletPage()));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("192192192 - SHIFT MALAM",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on, color: Colors.grey, size: 14),
                  Text(" Balikpapan Utara",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                ],
              )
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              minimumSize: Size(MediaQuery.of(context).size.width, 100)),
        ),
      );
      list.add(content);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _list(),
    );
  }
}
