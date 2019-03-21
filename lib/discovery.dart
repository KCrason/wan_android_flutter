import 'package:flutter/material.dart';
import 'article_detail.dart';

class Discovery extends StatefulWidget {
  @override
  _DiscoveryState createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          child: Text(
            'Discovery',
            textScaleFactor: 5,
          ),
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return ArticleDetail(url: 'www.baidu.com');
            }));
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
