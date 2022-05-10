import 'package:flutter/material.dart';
import 'package:telkom_apps/pages/outlet/components/performansi.dart';
import 'package:telkom_apps/pages/task/checkin_task.dart';

class OutletPage extends StatefulWidget {
  const OutletPage({Key? key, required this.outlet}) : super(key: key);
  final outlet;
  @override
  State<OutletPage> createState() => _OutletPageState();
}

class _OutletPageState extends State<OutletPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Outlet'),
        backgroundColor: Color(0xFFFF4949),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 5, color: Color(0xFFE5E5E5)))),
              width: size.width,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on,
                          color: Color(0xFFFF4949), size: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${widget.outlet['outlet_id']}",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 20),
                          ),
                          Text("${widget.outlet['namaoutlet']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20)),
                        ],
                      )
                    ],
                  ),
                  OutlineButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    borderSide: BorderSide(color: Color(0xFFFF4949)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TaskPage(outletId: widget.outlet['outlet_id']),
                          ));
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
            ),
            Performansi()
          ],
        ),
      ),
    );
  }
}
