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
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => new MyApp()),
          (route) => false);
    });
    return Container(
      child: FadeInImage.memoryNetwork(
          fit: BoxFit.cover,
          placeholder: kTransparentImage,
          image:
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552559552698&di=f958e8880fc69367a4e3f06b76dd527d&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171119%2F49db11adf45a4fcaa3a3907a00fdc611.jpeg'),
    );
  }
}
