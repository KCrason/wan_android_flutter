import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class ArticleDetail extends StatefulWidget {
  final String title;
  final String url;
  final isCollection;

  ArticleDetail(
      {Key key, this.title, @required this.url, this.isCollection: false})
      : super(key: key);

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  FlutterWebviewPlugin _flutterWebviewPlugin = new FlutterWebviewPlugin();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _talkStrs = '你还看';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> toMoreBottomSheet() async {
    String talkStrs;
    try {
      final channel = const MethodChannel('channel:KCrason');
      print('--------------------------------------------------');
      final String nativeSay =
          await channel.invokeMethod('MoreBottomSheet', '你好natvie,我是flutter');
      setState(() {
        print(nativeSay);
        _talkStrs = nativeSay;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      key: _scaffoldKey,
      url: widget.url,
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
      appBar: AppBar(
        title: Text('${widget.title}'),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            child: GestureDetector(
              onTap: () {
//                _flutterWebviewPlugin.hide();
//                showModalBottomSheet(
//                    context: context,
//                    builder: (BuildContext context) {
//                      return Column(
//                        mainAxisSize: MainAxisSize.min,
//                        children: <Widget>[
//                          ListTile(
//                            leading: Icon(Icons.share),
//                            title: Text('分享'),
//                            onTap: () {},
//                          ),
//                          ListTile(
//                            leading: Icon(Icons.favorite_border),
//                            title: Text('收藏'),
//                            onTap: () {},
//                          ),
//                          ListTile(
//                            leading: Icon(Icons.blur_circular),
//                            title: Text('在浏览器打开'),
//                            onTap: () {},
//                          )
//                        ],
//                      );
//                    });
                toMoreBottomSheet();
              },
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
