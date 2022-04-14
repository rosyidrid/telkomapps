import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          width: size.width * .8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.account_circle_rounded, color: Colors.white, size: 60),
              Flexible(
                  child: Text("SF-Robby Firdauzy-Balikpapan",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          width: size.width * .8,
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  hintText: "PJP",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 5,
                thickness: 1,
                indent: 5,
                endIndent: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.apartment),
                  hintText: "Nama Outlet",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Search",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width * 0.8, 40),
                    primary: Color(0xFFFF4949),
                    textStyle: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
