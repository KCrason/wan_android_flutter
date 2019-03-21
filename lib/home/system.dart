//体系
import 'package:flutter/material.dart';

class System extends StatefulWidget {
  @override
  _SystemState createState() => _SystemState();
}

class _SystemState extends State<System> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(
      child: Text(
        '体系',
        textScaleFactor: 5,
      ),
    ),);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
