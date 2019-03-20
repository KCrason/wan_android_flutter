import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:wan_android_flutter/network/PopularBannerBean.dart';
import 'package:wan_android_flutter/widgets/PopularBanner.dart';
import 'package:wan_android_flutter/network/PopularArticleBean.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wan_android_flutter/ArticleDetail.dart';

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
      Response responseArticle = await Dio()
          .get('https://www.wanandroid.com/article/list/$_curPage/json');
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

  void _requestBanner() async {
    try {
      Response responseBanner =
          await Dio().get('https://www.wanandroid.com/banner/json');
      Response responseArticle = await Dio()
          .get('https://www.wanandroid.com/article/list/$_curPage/json');
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
          _curPage++;
          isLoadMore = true;
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
        child: Center(
          child: ListView.separated(
              controller: _scrollController,
              separatorBuilder: (BuildContext context, int index) =>
                  new Divider(
                    color: index >= 1 ? Colors.grey[300] : Colors.transparent,
                  ),
              itemCount: _articleData == null ? 1 : _articleData.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PopularBannerWidget(
                    bannerTitle: (index) {
                      return PopularBannerBean.fromMap(_bannerData[index])
                          .title;
                    },
                    bannerCount: _bannerData == null ? 0 : _bannerData.length,
                    buildBannerItem: (context, index) {
                      PopularBannerBean popularBannerBean =
                          PopularBannerBean.fromMap(_bannerData[index]);
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            print('You click $index');
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
        ),
      );
    }
  }

  Widget _buildItem(PopularArticleBean popularArticleBean) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return ArticleDetail(
              title: popularArticleBean.title,
              url: popularArticleBean.link,
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
    );

//    ListTile(
//      trailing: Icon(
//        popularArticleBean.collect ? Icons.favorite : Icons.favorite_border,
//      ),
//      title: Text('${popularArticleBean.title}'),
//    );
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
