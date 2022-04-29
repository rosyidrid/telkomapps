import 'package:flutter/material.dart';
import 'package:telkom_apps/pages/task/components/tasks.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF4949),
          title: Text('Kerjakan Kegiatan Berikut!'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                width: size.width,
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Column(
                  children: <Widget>[
                    Tasks(),
                  ],
                ))));
  }
}
