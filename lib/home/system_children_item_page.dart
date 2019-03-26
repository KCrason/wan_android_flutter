import 'package:flutter/material.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/network/article_bean.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/widgets/list_view_widget.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/widgets/multi_status_page_widget.dart';
import 'package:wan_android_flutter/utils/collection_helper.dart';
import 'package:wan_android_flutter/article_detail.dart';

class SystemChildrenItemPage extends StatefulWidget {
  final String projectTabName;
  final int projectTabId;

  SystemChildrenItemPage({Key key, this.projectTabId, this.projectTabName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SystemChildrenItemPageState();
}

class _SystemChildrenItemPageState extends State<SystemChildrenItemPage> {
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
    ApiRequest.getSystemArticleListData(widget.projectTabId, mCurrentPage)
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
      child: ListTile(
        title: Text(articleItem.title),
        subtitle: Text(articleItem.desc),
        trailing: GestureDetector(
          onTap: () {
            _clickCollection(articleItem);
          },
          child: Icon(
              articleItem.collect ? Icons.favorite : Icons.favorite_border,
              color: articleItem.collect ? Colors.red : Colors.black38),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ArticleDetail(
                url: articleItem.link,
                articleId: '${articleItem.id}',
                title: articleItem.title,
                isCollection: articleItem.collect,
                isBannerArticle: false);
          }));
        },
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
