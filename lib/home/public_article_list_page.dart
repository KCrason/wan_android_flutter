import 'package:flutter/material.dart';
import 'package:wan_android_flutter/widgets/multi_status_page_widget.dart';
import 'package:wan_android_flutter/widgets/list_view_widget.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/network/article_bean.dart';
import 'package:wan_android_flutter/article_detail.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wan_android_flutter/utils/collection_helper.dart';

class PublicArticleListPage extends StatefulWidget {
  final String publicName;
  final int publicId;

  PublicArticleListPage({this.publicName, this.publicId});

  @override
  _PublicArticleListPageState createState() => _PublicArticleListPageState();
}

class _PublicArticleListPageState extends State<PublicArticleListPage> {
  MultiStatus _multiStatus = MultiStatus.loading;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int curPage = 1;
  ArticleBean _articleData = new ArticleBean();

  _refresh() {
    curPage = 1;
    ApiRequest.getPublicArticleListData(widget.publicId, curPage)
        .then((result) {
      _articleData = ArticleBean.fromJson(result.data['data']);
      setState(() {
        _multiStatus = MultiStatus.normal;
      });
    }).catchError((error) {
      setState(() {
        _multiStatus = MultiStatus.error;
      });
    });
  }

  Future<void> _loadMore() async {
    curPage++;
    ApiRequest.getPublicArticleListData(widget.publicId, curPage)
        .then((result) {
      ArticleBean articleBean = ArticleBean.fromJson(result.data['data']);
      setState(() {
        _articleData.datas.addAll(articleBean.datas);
      });
    });
  }

  _loadError(String errorMsg) {
    if (curPage > 1) {
      curPage--;
      if (curPage < 1) {
        curPage = 1;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.publicName),
      ),
      body: RefreshIndicator(
          child: MultiStatusPageWidget(
            refreshCallback: _refresh,
            multiStatus: _multiStatus,
            child: ListViewWidget(
              itemCount: _articleData == null || _articleData.datas == null
                  ? 0
                  : _articleData.datas.length,
              itemBuilder: (context, index) {
                return _buildItem(_articleData.datas[index]);
              },
              loadMore: _loadMore,
              loadMoreError: _loadError,
            ),
          ),
          onRefresh: _refresh),
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
}
