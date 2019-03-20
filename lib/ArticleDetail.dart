import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
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
              onTap: () {},
              child: Icon(
                Icons.favorite_border,
                color: widget.isCollection ? Colors.red : Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
