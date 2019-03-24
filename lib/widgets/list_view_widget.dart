import 'package:flutter/material.dart';

typedef HeaderViewWidgetBuilder = Widget Function(BuildContext context);
typedef LoadMoreCallBack = Future<void> Function();

class ListViewWidget extends StatefulWidget {
  final HeaderViewWidgetBuilder headerViewBuild;
  final itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final LoadMoreCallBack loadMore;

  ListViewWidget(
      {Key key,
      this.headerViewBuild,
      this.itemCount,
      @required this.itemBuilder,
      @required this.loadMore})
      : super(key: key);

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

_buildLoadMoreWidget() {
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

class _ListViewWidgetState extends State<ListViewWidget> {

  bool isLoadMore;

  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          !isLoadMore) {
        widget.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (widget.headerViewBuild == null) {
          if (index == widget.itemCount) {
            return _buildLoadMoreWidget();
          } else {
            return widget.itemBuilder(context, index);
          }
        } else {
          if (index == 0) {
            return widget.headerViewBuild(context);
          } else if (index > 0 && index <= widget.itemCount) {
            return widget.itemBuilder(context, index);
          } else {
            return _buildLoadMoreWidget();
          }
        }
      },
      itemCount: widget.headerViewBuild == null
          ? widget.itemCount + 1
          : widget.itemCount + 2,
    );
  }
}
