import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'utils/app_route.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/utils/collection_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ArticleDetail extends StatefulWidget {
  final String title;
  final String url;
  final bool isCollection;
  final String articleId;
  final bool isBannerArticle;

  ArticleDetail(
      {Key key,
      this.title,
      @required this.url,
      @required this.articleId,
      @required this.isBannerArticle,
      this.isCollection: false})
      : super(key: key);

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  WebViewController _controller;

  bool localCollectionState;
  bool _isLoadComplete = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localCollectionState = widget.isCollection;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtil.showShortToast(context, '无法打开$url');
    }
  }

  //收藏相关操作
  _clickCollection(String articleId) async {
    CollectionHelper collectionHelper = new CollectionHelper();
    if (localCollectionState) {
      collectionHelper.unCollectionArticle(context, (isOperateSuccess) {
        setState(() {
          this.localCollectionState = false;
        });
      }, int.parse(articleId));
    } else {
      collectionHelper.collectionArticle(context, (isOperateSuccess) {
        setState(() {
          this.localCollectionState = true;
        });
      }, int.parse(articleId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${widget.title}'),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.refresh),
                            title: Text('刷新'),
                            onTap: () {
                              _controller.reload();
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.share),
                            title: Text('分享'),
                            onTap: () {
                              AppRoute.intentShareArticle(
                                  {'title': widget.title, 'url': widget.url});
                              Navigator.pop(context);
                            },
                          ),
                          Offstage(
                            child: ListTile(
                              leading: localCollectionState
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : Icon(Icons.favorite_border),
                              title: Text('收藏'),
                              onTap: () {
                                _clickCollection(widget.articleId);
                                Navigator.pop(context);
                              },
                            ),
                            offstage: widget.isBannerArticle,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.blur_circular,
                            ),
                            title: Text('在浏览器打开'),
                            onTap: () {
                              _launchURL(widget.url);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    });
              },
              child: Icon(
                Icons.more_vert,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            onWebViewCreated: (controller) {
              _controller = controller;
            },
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (url) {
              setState(() {
                _isLoadComplete = true;
              });
            },
          ),
          Offstage(
            offstage: _isLoadComplete,
            child: SpinKitCircle(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
