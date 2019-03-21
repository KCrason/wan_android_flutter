import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:wan_android_flutter/network/PopularBannerBean.dart';
import 'package:wan_android_flutter/widgets/popular_banner.dart';
import 'package:wan_android_flutter/network/PopularArticleBean.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wan_android_flutter/utils/constant.dart';
import 'package:wan_android_flutter/utils/app_route.dart';

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

  bool isLoadMore = false;

  void loadMore() async {
    try {
      _curPage++;
      isLoadMore = true;
      Response responseArticle =
          await Dio().get(Constants.generatePopularArticleUrl(_curPage));
      final articleJson = json.decode(responseArticle.toString());
      setState(() {
        isLoadMore = false;
        List newArticleData = articleJson['data']['datas'];
        _articleData.addAll(newArticleData);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Null> _requestBanner() async {
    try {
      _curPage = 0;
      isLoadMore = false;
      Response responseBanner = await Dio().get(Constants.popularBannerUrl);
      Response responseArticle =
          await Dio().get(Constants.generatePopularArticleUrl(_curPage));
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
                      PopularArticleBean.fromMap(_articleData[index - 1]));
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
              AppRoute.intentArticleDetail({
                'title': popularBannerBean.title,
                'url': popularBannerBean.url
              });
//              Navigator.of(context)
//                  .push(new MaterialPageRoute(builder: (context) {
//                return ArticleDetail(
//                  url: popularBannerBean.url,
//                  title: popularBannerBean.title,
//                );
//              }));
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

  Widget _buildItem(PopularArticleBean popularArticleBean) {
    return Material(
      child: Card(
        elevation: 3.0,
        child: InkWell(
          onTap: () {
            AppRoute.intentArticleDetail({
              'title': popularArticleBean.title,
              'url': popularArticleBean.link
            });
//            Navigator.push(context, new MaterialPageRoute(builder: (context) {
//              return ArticleDetail(
//                title: popularArticleBean.title,
//                url: popularArticleBean.link,
//              );
//            }));
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
                    child: Icon(
                      popularArticleBean.collect
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          popularArticleBean.collect ? Colors.red : Colors.grey,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    return getBody();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
