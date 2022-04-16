import 'package:flutter/material.dart';
import 'package:telkom_apps/map/map.dart';

class Tasks extends StatefulWidget {
  const Tasks({
    Key? key,
  }) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> with TickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _controller;
  int levelClock = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Countdown(
            animation: StepTween(
              begin: levelClock,
              end: 0,
            ).animate(_controller),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MapPage()));
            },
            child: Text(
              "Check - In Posisi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.8, 50),
                primary: Color(0xFFFF4949),
                textStyle: TextStyle(fontWeight: FontWeight.w700)),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              "Ambil Foto di Outlet",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.8, 50),
                primary: Colors.grey[350],
                textStyle: TextStyle(fontWeight: FontWeight.w700)),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              "Ambil Foto Stok Digipos",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.8, 50),
                primary: Colors.grey[350],
                textStyle: TextStyle(fontWeight: FontWeight.w700)),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              "Ambil Foto Nota Penjualan",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.8, 50),
                primary: Colors.grey[350],
                textStyle: TextStyle(fontWeight: FontWeight.w700)),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              "Ambil Foto Promo Comp",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.8, 50),
                primary: Colors.grey[350],
                textStyle: TextStyle(fontWeight: FontWeight.w700)),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              "Ambil Foto Harga EUP",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.8, 50),
                primary: Colors.grey[350],
                textStyle: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 30,
        color: Color(0xFFFF4949),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
