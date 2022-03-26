import 'package:flutter/material.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  List<Container> list = [];
  List<Container> _list() {
    for (int i = 0; i < 5; i++) {
      var content = Container(
        margin: EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width * .8,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(1, 1),
            )
          ],
        ),
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
