import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

typedef HeaderViewWidgetBuilder = Widget Function(BuildContext context);
typedef LoadMoreCallBack = Future<void> Function();
typedef LoadMoreError = void Function(String errorMessage);

class ListViewWidget extends StatefulWidget {
  final HeaderViewWidgetBuilder headerViewBuild;
  final itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final LoadMoreCallBack loadMore;
  final bool isLoadComplete;
  final LoadMoreError loadMoreError;

  ListViewWidget(
      {Key key,
      this.headerViewBuild,
      this.itemCount,
      @required this.itemBuilder,
      @required this.loadMore,
      this.loadMoreError,
      this.isLoadComplete: false})
      : super(key: key);

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  bool isLoading = false;
  bool isLoadError = false;

  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          !widget.isLoadComplete) {
        isLoadError = false;
        Future<void> loadMoreResult = widget.loadMore();
        if (loadMoreResult == null) {
          throw FlutterError('ListViewWidget LoadMore Method return is null!');
        }
        loadMoreResult.catchError((error) {
          if (widget.loadMoreError != null) {
            widget.loadMoreError(error.toString());
          }
          setState(() {
            isLoading = false;
            isLoadError = true;
          });
        }).whenComplete(() {
          isLoading = false;
        });
      }
    });
  }

  Widget _buildLoadMoreStateWidget() {
    if (widget.isLoadComplete) {
      return Center(
        child: Text(
          '没有更多数据',
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
      );
    } else if (isLoadError) {
      return Center(
        child: Text(
          '加载失败啦 %>_<%',
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
      );
    } else {
      return SpinKitCircle(
        color: Colors.black,
        size: 24,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (widget.headerViewBuild == null) {
          if (index == widget.itemCount) {
            return Container(
              padding: EdgeInsets.all(12.0),
              child: _buildLoadMoreStateWidget(),
            );
          } else {
            return widget.itemBuilder(context, index);
          }
        } else {
          if (index == 0) {
            return widget.headerViewBuild(context);
          } else if (index > 0 && index <= widget.itemCount) {
            return widget.itemBuilder(context, index-1);
          } else {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: _buildLoadMoreStateWidget(),
            );
          }
        }
      },
      itemCount: widget.headerViewBuild == null
          ? widget.itemCount == 0 ? 0 : widget.itemCount + 1
          : widget.itemCount == 0 ? 1 : widget.itemCount + 2,
    );
  }
}
