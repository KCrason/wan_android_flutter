import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/network/popular_banner_bean.dart';
import 'package:wan_android_flutter/widgets/popular_banner.dart';
import 'package:wan_android_flutter/network/article_bean.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wan_android_flutter/article_detail.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/utils/collection_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wan_android_flutter/widgets/list_view_widget.dart';
import 'package:wan_android_flutter/widgets/multi_status_page_widget.dart';

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

  List<dynamic> topArticle;

  int _curPage = 0;

  MultiStatus _multiStatus = MultiStatus.loading;

//  ScrollController _scrollController = new ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> loadMore() async {
    _curPage++;
    ApiRequest.getPopularListData(_curPage).then((responseArticle) {
      ArticleBean newArticleData =
          ArticleBean.fromJson(responseArticle.data['data']);
      setState(() {
        _articleData.datas.addAll(newArticleData.datas);
      });
    });
  }

  void loadError(String errorMsg) {
    if (_curPage > 0) {
      _curPage--;
      if (_curPage < 0) {
        _curPage = 0;
      }
    }
  }

  void _retryRefresh() {
    setState(() {
      _multiStatus = MultiStatus.loading;
    });
    _requestBanner();
  }

  Future<Null> _requestBanner() async {
    try {
      _curPage = 0;
      Response responseBanner = await ApiRequest.getBannerData();
      Response responseArticle = await ApiRequest.getPopularListData(_curPage);
      Response responseTopArticle = await ApiRequest.getTopArticleData();
      setState(() {
        _bannerData = PopularBannerBean.fromJson(responseBanner.data);
        topArticle = responseTopArticle.data['data'];
        _articleData = ArticleBean.fromJson(responseArticle.data['data']);
        _multiStatus = MultiStatus.normal;
      });
    } catch (e) {
      setState(() {
        _multiStatus = MultiStatus.error;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestBanner();
  }

  Widget _buildBanner() {
    return Column(
      children: <Widget>[
        PopularBannerWidget(
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
        ),
        Offstage(
          offstage: topArticle == null,
          child: Column(
            children: buildTopArticleViews(),
          ),
        )
      ],
    );
  }

  List<Widget> buildTopArticleViews() {
    return List<Widget>.generate(topArticle.length, (index) {
      ArticleItem articleItem = ArticleItem.fromJson(topArticle[index]);
      return Card(
        child: ListTile(
          leading: Icon(
            Icons.assistant_photo,
            color: Colors.red,
          ),
          title: Text(
            '${articleItem.title}',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return ArticleDetail(
                title: articleItem.title,
                url: articleItem.link,
                isCollection: articleItem.collect,
                articleId: '${articleItem.id}',
                isBannerArticle: true,
              );
            }));
          },
        ),
      );
    });
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
                          style: TextStyle(fontSize: 16.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
      _collectionHelper.unCollectionArticle(context, (isOperateSuccess) {
        setState(() {
          articleItem.collect = false;
        });
      }, articleItem.id);
    } else {
      _collectionHelper.collectionArticle(context, (isOperateSuccess) {
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
      body: MultiStatusPageWidget(
        refreshCallback: _retryRefresh,
        multiStatus: _multiStatus,
        child: RefreshIndicator(
          child: ListViewWidget(
            itemBuilder: (context, index) {
              return _buildItem(_articleData.datas[index]);
            },
            itemCount: (_articleData == null || _articleData.datas == null)
                ? 0
                : _articleData.datas.length,
            loadMore: loadMore,
            loadMoreError: loadError,
            headerViewBuild: (context) {
              return _buildBanner();
            },
          ),
          onRefresh: _requestBanner,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
