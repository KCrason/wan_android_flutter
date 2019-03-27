import 'package:flutter/material.dart';
import 'package:wan_android_flutter/widgets/multi_status_page_widget.dart';
import 'package:wan_android_flutter/widgets/list_view_widget.dart';
import 'article_detail.dart';
import 'package:wan_android_flutter/network/article_bean.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/utils/collection_helper.dart';
import 'package:transparent_image/transparent_image.dart';

class MyCollectionPage extends StatefulWidget {
  @override
  _MyCollectionPageState createState() => _MyCollectionPageState();
}

class _MyCollectionPageState extends State<MyCollectionPage> {
  int curPage = 0;
  ArticleBean _articleData = new ArticleBean();
  MultiStatus _multiStatus = MultiStatus.loading;
  bool _isLoadComplete = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> _refresh() async {
    curPage = 0;
    _isLoadComplete = false;
    ApiRequest.getMyCollectionData(curPage).then((result) {
      _articleData = ArticleBean.fromJson(result.data['data']);
      if (_articleData == null ||
          _articleData.datas == null ||
          _articleData.datas.length == 0) {
        setState(() {
          _multiStatus = MultiStatus.empty;
        });
      } else {
        setState(() {
          if (_articleData.total == _articleData.datas.length) {
            _isLoadComplete = true;
          }
          _multiStatus = MultiStatus.normal;
        });
      }
    }).catchError((error) {
      setState(() {
        _multiStatus = MultiStatus.error;
      });
    });
  }

  Future<void> _loadMore() async {
    curPage++;
    ApiRequest.getMyCollectionData(curPage).then((result) {
      ArticleBean articleBean = ArticleBean.fromJson(result.data['data']);
      setState(() {
        _articleData.datas.addAll(articleBean.datas);
        if (_articleData.total == _articleData.datas.length) {
          _isLoadComplete = true;
        }
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
        title: Text('我的收藏'),
      ),
      body: RefreshIndicator(
          child: MultiStatusPageWidget(
            refreshCallback: _refresh,
            child: ListViewWidget(
              isLoadComplete: _isLoadComplete,
              itemCount: _articleData == null || _articleData.datas == null
                  ? 0
                  : _articleData.datas.length,
              itemBuilder: (context, index) {
                return _buildItem(_articleData.datas[index], index);
              },
              loadMore: _loadMore,
              loadMoreError: _loadError,
            ),
            multiStatus: _multiStatus,
          ),
          onRefresh: _refresh),
    );
  }

  Widget _buildItem(ArticleItem articleItem, int index) {
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
                      _clickUnCollection(
                          articleItem.id, index, articleItem.originId);
                    },
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
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
  _clickUnCollection(int articleId, int index, int originId) async {
    CollectionHelper _collectionHelper = new CollectionHelper();
    _collectionHelper.unCollectionArticleForMyCollectionPage(context,
        (isOperateSuccess) {
      setState(() {
        _articleData.datas.removeAt(index);
      });
    }, articleId, originId);
  }
}
