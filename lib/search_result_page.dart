import 'package:flutter/material.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/network/article_bean.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/widgets/list_view_widget.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/widgets/multi_status_page_widget.dart';
import 'package:wan_android_flutter/utils/collection_helper.dart';
import 'package:wan_android_flutter/article_detail.dart';
import 'package:transparent_image/transparent_image.dart';
import 'events/update_search_event.dart';

class SearchResultPage extends StatefulWidget {
  final String keyWord;

  SearchResultPage({this.keyWord});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  int mCurrentPage = 0;
  List<ArticleItem> _articleItems = new List();
  bool _isLoadComplete = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  MultiStatus _multiStatus = MultiStatus.loading;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  _retryRefresh() {
    setState(() {
      _multiStatus = MultiStatus.loading;
    });
    _refreshData();
  }

  Future<void> _refreshData() async {
    mCurrentPage = 0;
    _isLoadComplete = false;
    ApiRequest.search(widget.keyWord, mCurrentPage).then((response) {
      ArticleBean articleBean = ArticleBean.fromJson(response.data['data']);
      if (articleBean.total == 0) {
        setState(() {
          _multiStatus = MultiStatus.empty;
        });
      } else {
        if (articleBean == null || articleBean.datas == null) {
          setState(() {
            _multiStatus = MultiStatus.error;
          });
        } else {
          _articleItems = articleBean.datas;
          _multiStatus = MultiStatus.normal;
          _setLoadCompleteState(articleBean);
        }
      }
    }).catchError((error) {
      setState(() {
        _multiStatus = MultiStatus.error;
      });
    });
  }

  _setLoadCompleteState(ArticleBean articleBean) {
    setState(() {
      if (articleBean.total == _articleItems.length) {
        _isLoadComplete = true;
      }
    });
  }

  Future<void> _loadMore() async {
    mCurrentPage++;
    Response response = await ApiRequest.search(widget.keyWord, mCurrentPage);
    ArticleBean articleBean = ArticleBean.fromJson(response.data['data']);
    _articleItems.addAll(articleBean.datas);
    _setLoadCompleteState(articleBean);
  }

  _onLoadMoreError(String errorMessage) {
    LogUtil.printLog(errorMessage);
    if (mCurrentPage > 1) {
      mCurrentPage--;
      if (mCurrentPage < 1) {
        mCurrentPage = 1;
      }
    }
  }

  List<TextSpan> createTextSpan(String title) {
    String newKeyWord = '<em class=\'highlight\'>${widget.keyWord}</em>';
    Match match = RegExp(newKeyWord).firstMatch(title);
    if (match != null) {
      int start = match.start;
      int end = match.end;
      String startStr = title.substring(0, start);
      String endStr = title.substring(end);
      return <TextSpan>[
        TextSpan(
            text: startStr,
            style: TextStyle(fontSize: 16.0, color: Colors.black)),
        TextSpan(
            text: widget.keyWord,
            style: TextStyle(color: Colors.blue, fontSize: 16)),
        TextSpan(
            text: endStr, style: TextStyle(fontSize: 16.0, color: Colors.black))
      ];
    } else {
      return <TextSpan>[
        TextSpan(
            text: title, style: TextStyle(fontSize: 16.0, color: Colors.black)),
      ];
    }
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
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                children:
                                    createTextSpan('${articleItem.title}'))),
                        Container(
                          margin: EdgeInsets.only(top: 6.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  '${articleItem.niceDate}  @${articleItem.author}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索${widget.keyWord}的结果'),
      ),
      key: _scaffoldKey,
      body: RefreshIndicator(
          child: MultiStatusPageWidget(
            multiStatus: _multiStatus,
            refreshCallback: _retryRefresh,
            child: ListViewWidget(
              itemCount: _articleItems == null || _articleItems.length == 0
                  ? 0
                  : _articleItems.length,
              itemBuilder: (context, index) => _buildItem(_articleItems[index]),
              loadMore: _loadMore,
              loadMoreError: _onLoadMoreError,
              isLoadComplete: _isLoadComplete,
            ),
          ),
          onRefresh: _refreshData),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBus.fire(new UpdateSearchEvent());
  }
}
