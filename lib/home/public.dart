//公众号

import 'package:flutter/material.dart';
import 'package:wan_android_flutter/widgets/multi_status_page_widget.dart';

class Public extends StatefulWidget {
  @override
  _PublicState createState() => _PublicState();
}

class _PublicState extends State<Public> with AutomaticKeepAliveClientMixin {
  MultiStatus _multiStatus = MultiStatus.loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiStatusPageWidget(
        multiStatus: _multiStatus,
        child: Center(
          child: Text('有数据状态'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _multiStatus = MultiStatus.notNetwork;
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
