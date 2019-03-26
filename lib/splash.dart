import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'main.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new SplashWidget(),
  ));
}

class SplashWidget extends StatelessWidget {
  _intentPage(BuildContext context) async {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => MyApp()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    _intentPage(context);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage('https://source.unsplash.com/random'),
              fit: BoxFit.cover)),
    );
  }
}
