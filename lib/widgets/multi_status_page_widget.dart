import 'package:flutter/material.dart';

typedef RetryRefreshCallback = void Function();

class MultiStatusPageWidget extends StatefulWidget {
  final Widget child;

  final MultiStatus multiStatus;

  final RetryRefreshCallback refreshCallback;

  MultiStatusPageWidget(
      {this.child,
      this.multiStatus: MultiStatus.loading,
      @required this.refreshCallback});

  @override
  _MultiStatusPageWidgetState createState() => _MultiStatusPageWidgetState();
}

enum MultiStatus { loading, error, empty, normal, notNetwork }

class _MultiStatusPageWidgetState extends State<MultiStatusPageWidget> {
  Widget _getStatusWidget(
      MultiStatusPageWidget widget, MultiStatus multiStatus) {
    switch (multiStatus) {
      case MultiStatus.error:
        return _buildStatusView(widget, Icons.error, '加载错误~');
      case MultiStatus.loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      case MultiStatus.empty:
        return Center(
          child: _buildStatusView(widget, Icons.hourglass_empty, '数据为空~'),
        );
      case MultiStatus.notNetwork:
        return _buildStatusView(widget, Icons.portable_wifi_off, '暂无网络~');
      case MultiStatus.normal:
        return widget.child;
    }
    return null;
  }

  Widget _buildStatusView(
      MultiStatusPageWidget widget, IconData iconData, String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            size: 44,
            color: Colors.black38,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black38,
              ),
            ),
          ),
          Offstage(
            offstage: widget.multiStatus == MultiStatus.empty,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: widget.refreshCallback,
                child: Text(
                  '点击重试',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _getStatusWidget(widget, widget.multiStatus));
  }
}
