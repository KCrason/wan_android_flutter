import 'package:flutter/material.dart';
import 'main.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new SplashWidget(),
  ));
}

class SplashWidget extends StatelessWidget {
  _intentPage(BuildContext context) async {
    Future.delayed(Duration(seconds: 2), () {
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
              image: AssetImage('images/splash.jpg'),
              fit: BoxFit.cover)),
    );
  }
}
