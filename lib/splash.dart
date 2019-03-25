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
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (context) =>
                   MyApp()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    _intentPage(context);
    return Container(
      child: FadeInImage.memoryNetwork(
          fit: BoxFit.cover,
          placeholder: kTransparentImage,
          image:
              'https://i.pinimg.com/originals/1d/ac/ad/1dacad5d6eab950f547b693ca975c6db.jpg'),
    );
  }
}
