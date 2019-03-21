import 'package:flutter/material.dart';
import 'dart:ui';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                    ),
                  ),
                  alignment: Alignment(0, -0.5),
                ),
                Padding(
                  child: Text(
                    'KCrason',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  padding: EdgeInsets.only(top: 16),
                )
              ],
            ),
            height: 250,
          ),
          Column(
            children: <Widget>[
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
              Text('设置'),
            ],
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
