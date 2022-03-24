import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Head extends StatelessWidget {
  const Head({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.5,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/image/jpeg/MASTER.png"),
        fit: BoxFit.values[0],
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50,),
            child: Text(
              "SELAMAT DATANG",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SvgPicture.asset(
            "assets/image/svg/head.svg",
          )
        ],
      ),
    );
  }
}
