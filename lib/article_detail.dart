import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'utils/app_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/constant.dart';
import 'user/login.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'dart:convert';
import 'package:wan_android_flutter/utils/snackbar_util.dart';

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
      SnackBarUtil.showShortSnackBar(_scaffoldKey.currentState, '无法打开$url');
    }
  }

  //收藏相关操作
  _clickCollection(String articleId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLogin = sharedPreferences.getBool(Constants.preferenceKeyIsLogin);
    if (isLogin != null && isLogin) {
      if (localCollectionState) {
        Response response =
            await ApiRequest.unCollectionWebsiteArticle(articleId);
        print('KCrason UnCollection:${response.toString()}');
        final jsonResult = json.decode(response.toString());
        int errorCode = jsonResult['errorCode'];
        if (errorCode == 0) {
          setState(() {
            this.localCollectionState = false;
            SnackBarUtil.showShortSnackBar(_scaffoldKey.currentState, '已取消收藏');
          });
        } else {
          SnackBarUtil.showShortSnackBar(_scaffoldKey.currentState, '取消失败');
        }
      } else {
        Response response =
            await ApiRequest.collectionWebsiteArticle(articleId);
        print('KCrason Collection:${response.toString()}');
        final jsonResult = json.decode(response.toString());
        int errorCode = jsonResult['errorCode'];
        if (errorCode == 0) {
          setState(() {
            this.localCollectionState = true;
            SnackBarUtil.showShortSnackBar(_scaffoldKey.currentState, '收藏成功');
          });
        } else {
          SnackBarUtil.showShortSnackBar(_scaffoldKey.currentState, '收藏失败');
        }
      }
    } else {
      Navigator.push(context, new MaterialPageRoute(builder: (context) {
        return Login();
      }));
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
                            leading: Icon(Icons.refresh, color: Colors.white),
                            title: Text('刷新'),
                            onTap: () {
                              _controller.reload();
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.share, color: Colors.white),
                            title: Text('分享'),
                            onTap: () {
                              AppRoute.intentShareArticle(
                                  {'title': widget.title, 'url': widget.url});
                              Navigator.pop(context);
                            },
                          ),
                          Offstage(
                            child: ListTile(
                              leading: Icon(
                                localCollectionState
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: localCollectionState
                                    ? Colors.red
                                    : Colors.white,
                              ),
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
                              color: Colors.white,
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
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: WebView(
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url) {
          print('$url load complete.');
        },
      ),
    );
  }
}
