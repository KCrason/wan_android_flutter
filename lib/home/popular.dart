import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/network/popular_banner_bean.dart';
import 'package:wan_android_flutter/widgets/popular_banner.dart';
import 'package:wan_android_flutter/network/article_bean.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wan_android_flutter/article_detail.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/utils/collection_helper.dart';

//头条
class Popular extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _PopularState();
  }
}

class _PopularState extends State<Popular> with AutomaticKeepAliveClientMixin {
  PopularBannerBean _bannerData;
  ArticleBean _articleData;
  int _curPage = 0;
  ScrollController _scrollController = new ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoadMore = false;

  void loadMore() {
    _curPage++;
    isLoadMore = true;
    ApiRequest.getPopularListData(_curPage).then((responseArticle) {
      ArticleBean newArticleData =
          ArticleBean.fromJson(responseArticle.data['data']);
      setState(() {
        isLoadMore = false;
        _articleData.datas.addAll(newArticleData.datas);
      });
    });
  }

  Future<Null> _requestBanner() async {
    try {
      _curPage = 0;
      isLoadMore = false;
      Response responseBanner = await ApiRequest.getBannerData();
      Response responseArticle = await ApiRequest.getPopularListData(_curPage);
      setState(() {
        _bannerData = PopularBannerBean.fromJson(responseBanner.data);
        _articleData = ArticleBean.fromJson(responseArticle.data['data']);
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
                itemCount: (_articleData == null || _articleData.datas == null)
                    ? 1
                    : _articleData.datas.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildBanner();
                  } else if (index == _articleData.datas.length + 1) {
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
                  return _buildItem(_articleData.datas[index - 1]);
                }),
            onRefresh: _requestBanner),
      );
    }
  }


  Widget _buildBanner() {
    return PopularBannerWidget(
      bannerTitle: (index) {
        return _bannerData.data[index].title;
      },
      bannerCount: _bannerData == null || _bannerData.data == null
          ? 0
          : _bannerData.data.length,
      buildBannerItem: (context, index) {
        BannerItem bannerItem = _bannerData.data[index];
        return Container(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return ArticleDetail(
                  url: bannerItem.url,
                  title: bannerItem.title,
                  articleId: '${bannerItem.id}',
                  isBannerArticle: true,
                );
              }));
            },
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: bannerItem.imagePath,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(ArticleItem articleItem) {
    return Material(
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return ArticleDetail(
                title: articleItem.title,
                url: articleItem.link,
                isCollection: articleItem.collect,
                articleId: '${articleItem.id}',
                isBannerArticle: false,
              );
            }));
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Offstage(
                  offstage: articleItem.envelopePic.isEmpty,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: articleItem.envelopePic,
                            fit: BoxFit.cover,
                          ))),
                ),
                Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${articleItem.title}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 6.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${articleItem.niceDate}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  '来源：${articleItem.author}',
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
                      _clickCollection(articleItem);
                    },
                    child: Icon(
                      articleItem.collect
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: articleItem.collect ? Colors.red : Colors.grey,
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
  _clickCollection(ArticleItem articleItem) async {
    CollectionHelper _collectionHelper = new CollectionHelper();
    if (articleItem.collect) {
      _collectionHelper.unCollectionArticle(_scaffoldKey.currentState,
          (isOperateSuccess) {
        setState(() {
          articleItem.collect = false;
        });
      }, articleItem.id);
    } else {
      _collectionHelper.collectionArticle(_scaffoldKey.currentState,
          (isOperateSuccess) {
        setState(() {
          articleItem.collect = true;
        });
      }, articleItem.id);
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
