import 'package:flutter/material.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/network/article_bean.dart';
import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';

class ProjectClassifyItemPage extends StatefulWidget {
  final String projectTabName;
  final int projectTabId;

  ProjectClassifyItemPage({Key key, this.projectTabId, this.projectTabName})
      : super(key: key);

  @override
  _ProjectClassifyItemPageState createState() =>
      _ProjectClassifyItemPageState();
}

class _ProjectClassifyItemPageState extends State<ProjectClassifyItemPage> {
  int mCurrentPage = 1;
  List<ArticleItem> _articleItems = new List();

  final ScrollController _scrollController = new ScrollController();

  bool isLoadMore = false;

  @override
  void initState() {
    super.initState();
    _requestData();
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          !isLoadMore) {
        _loadMore();
      }
    });
  }

  Future<Null> _requestData() async {
    isLoadMore = false;
    Response response = await ApiRequest.getProjectClassifyListData(
        widget.projectTabId, mCurrentPage);
    ArticleBean articleBean = ArticleBean.fromJson(response.data['data']);
    setState(() {
      _articleItems = articleBean.datas;
    });
  }

  _loadMore() async {
    mCurrentPage++;
    isLoadMore = true;
    Response response = await ApiRequest.getProjectClassifyListData(
        widget.projectTabId, mCurrentPage);
    ArticleBean articleBean = ArticleBean.fromJson(response.data['data']);
    setState(() {
      isLoadMore = false;
      _articleItems.addAll(articleBean.datas);
    });
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
                        Icon(
                            articleItem.collect
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: articleItem.collect
                                ? Colors.red
                                : Colors.black38),
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

  @override
  Widget build(BuildContext context) {
//    return ListView.builder(
//        itemCount: _articleItems == null ? 0 : _articleItems.length,
//        itemBuilder: (context, index) {
//          return _buildItem(_articleItems[index]);
//        });

    return RefreshIndicator(
        child: ListView.builder(
          itemCount: _articleItems == null || _articleItems.length == 0
              ? 0
              : _articleItems.length + 1,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index < _articleItems.length) {
              return _buildItem(_articleItems[index]);
            }
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
          },
        ),
        onRefresh: _requestData);
  }
}
