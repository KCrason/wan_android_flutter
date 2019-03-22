import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:wan_android_flutter/network/PopularBannerBean.dart';
import 'package:wan_android_flutter/widgets/popular_banner.dart';
import 'package:wan_android_flutter/network/PopularArticleBean.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wan_android_flutter/article_detail.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android_flutter/utils/constant.dart';
import 'package:wan_android_flutter/utils/snackbar_util.dart';
import 'package:wan_android_flutter/user/login.dart';

//头条
class Popular extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _PopularState();
  }
}

class _PopularState extends State<Popular> with AutomaticKeepAliveClientMixin {
  List _bannerData;
  List _articleData;
  int _curPage = 0;
  ScrollController _scrollController = new ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoadMore = false;

  void loadMore() {
    _curPage++;
    isLoadMore = true;
    ApiRequest.getPopularListData(_curPage).then((responseArticle) {
      final articleJson = json.decode(responseArticle.toString());
      setState(() {
        isLoadMore = false;
        List newArticleData = articleJson['data']['datas'];
        _articleData.addAll(newArticleData);
      });
    });
  }

  Future<Null> _requestBanner() async {
    try {
      _curPage = 0;
      isLoadMore = false;
      Response responseBanner = await ApiRequest.getBannerData();
      Response responseArticle = await ApiRequest.getPopularListData(_curPage);
      final bannerJson = json.decode(responseBanner.toString());
      final articleJson = json.decode(responseArticle.toString());
      setState(() {
        _bannerData = bannerJson['data'];
        _articleData = articleJson['data']['datas'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          !isLoadMore) {
        setState(() {
          loadMore();
        });
      }
    });
    _requestBanner();
  }

  Widget getBody() {
    if (_articleData == null) {
      return new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                '加载中...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        child: RefreshIndicator(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: _articleData == null ? 1 : _articleData.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildBanner();
                  } else if (index == _articleData.length + 1) {
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12.0),
                            child: Text(
                              '正在加载...',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return _buildItem(
                      PopularArticleBean.fromMap(_articleData[index - 1]),
                      index - 1);
                }),
            onRefresh: _requestBanner),
      );
    }
  }

  Widget _buildBanner() {
    return PopularBannerWidget(
      bannerTitle: (index) {
        return PopularBannerBean.fromMap(_bannerData[index]).title;
      },
      bannerCount: _bannerData == null ? 0 : _bannerData.length,
      buildBannerItem: (context, index) {
        PopularBannerBean popularBannerBean =
            PopularBannerBean.fromMap(_bannerData[index]);
        return Container(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return ArticleDetail(
                  url: popularBannerBean.url,
                  title: popularBannerBean.title,
                  articleId: '${popularBannerBean.id}',
                  isBannerArticle: true,
                );
              }));
            },
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: popularBannerBean.imagePath,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(PopularArticleBean popularArticleBean, int index) {
    return Material(
      child: Card(
        elevation: 3.0,
        child: InkWell(
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return ArticleDetail(
                title: popularArticleBean.title,
                url: popularArticleBean.link,
                isCollection: popularArticleBean.collect,
                articleId: '${popularArticleBean.id}',
                isBannerArticle: false,
              );
            }));
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${popularArticleBean.title}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 6.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${popularArticleBean.niceDate}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  '来源：${popularArticleBean.author}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _clickCollection(index);
                    },
                    child: Icon(
                      popularArticleBean.collect
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          popularArticleBean.collect ? Colors.red : Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //收藏相关操作
  _clickCollection(int index) async {
    PopularArticleBean popularArticleBean =
        PopularArticleBean.fromMap(_articleData[index]);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLogin = sharedPreferences.getBool(Constants.preferenceKeyIsLogin);
    if (isLogin != null && isLogin) {
      if (popularArticleBean.collect) {
        Response response = await ApiRequest.unCollectionWebsiteArticle(
            '${popularArticleBean.id}');
        print('KCrason UnCollection:${response.toString()}');
        final jsonResult = json.decode(response.toString());
        int errorCode = jsonResult['errorCode'];
        if (errorCode == 0) {
          setState(() {
            popularArticleBean.collect = false;
            SnackBarUtil.showShortSnackBar(_scaffoldKey.currentState, '已取消收藏');
          });
        } else {
          SnackBarUtil.showShortSnackBar(_scaffoldKey.currentState, '取消失败');
        }
      } else {
        Response response = await ApiRequest.collectionWebsiteArticle(
            '${popularArticleBean.id}');
        print('KCrason Collection:${response.toString()}');
        final jsonResult = json.decode(response.toString());
        int errorCode = jsonResult['errorCode'];
        if (errorCode == 0) {
          setState(() {
            popularArticleBean.collect = true;
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
    super.build(context);
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      body: getBody(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
