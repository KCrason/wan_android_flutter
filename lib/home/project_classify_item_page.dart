import 'package:flutter/material.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/network/article_bean.dart';
import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wan_android_flutter/widgets/list_view_widget.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/widgets/multi_status_page_widget.dart';
import 'package:wan_android_flutter/utils/collection_helper.dart';

class ProjectClassifyItemPage extends StatefulWidget {
  final String projectTabName;
  final int projectTabId;

  ProjectClassifyItemPage({Key key, this.projectTabId, this.projectTabName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectClassifyItemPageState();
}

class _ProjectClassifyItemPageState extends State<ProjectClassifyItemPage> {
  int mCurrentPage = 1;
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
    ApiRequest.getProjectClassifyListData(widget.projectTabId, mCurrentPage)
        .then((response) {
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
    Response response = await ApiRequest.getProjectClassifyListData(
        widget.projectTabId, mCurrentPage);
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

  Widget _buildItem(ArticleItem articleItem) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                width: 100,
                height: 160,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: articleItem.envelopePic,
                  fit: BoxFit.cover,
                )),
            Expanded(
              child: Container(
                height: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          child: Text(
                            articleItem.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          padding:
                              EdgeInsets.only(left: 12, right: 12, bottom: 8),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12, right: 12),
                          child: Text(
                            articleItem.desc,
                            style:
                                TextStyle(fontSize: 14, color: Colors.black38),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Row(
                            children: <Widget>[
                              Text(
                                articleItem.niceDate,
                                style: TextStyle(color: Colors.black38),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  articleItem.author,
                                  style: TextStyle(color: Colors.black38),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _clickCollection(articleItem);
                          },
                          child: Icon(
                              articleItem.collect
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: articleItem.collect
                                  ? Colors.red
                                  : Colors.black38),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              flex: 1,
            )
          ],
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
    return Scaffold(
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
}
