import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class SlideImage extends StatefulWidget {
  const SlideImage({Key? key}) : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
    Size size = MediaQuery.of(context).size;
    return ImageSlideshow(
      width: size.width,
      height: size.height * 0.35,
      children: <Widget>[
        Image.asset("assets/image/jpeg/outlet.JPG", fit: BoxFit.cover),
        Image.asset("assets/image/jpeg/etalase.jpg", fit: BoxFit.cover),
      ],
      autoPlayInterval: 10000,
      isLoop: true,
    );
  }
}
