//公众号

import 'package:flutter/material.dart';

class Public extends StatefulWidget {
  @override
  _PublicState createState() => _PublicState();
}

class _PublicState extends State<Public> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          '公众号',
          textScaleFactor: 5,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
