import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:ui';

typedef BuildBannerItem = Widget Function(BuildContext context, int index);

typedef BuildBannerTitle = String Function(int index);

class PopularBannerWidget extends StatefulWidget {
  final BuildBannerItem buildBannerItem;
  final int bannerCount;
  final BuildBannerTitle bannerTitle;
  final ValueChanged<int> onIndexChanged;

  PopularBannerWidget(
      {Key key,
      this.buildBannerItem,
      this.bannerTitle,
      this.bannerCount,
      this.onIndexChanged})
      : super(key: key);

  @override
  _PopularBannerWidgetState createState() => _PopularBannerWidgetState();
}

class _PopularBannerWidgetState extends State<PopularBannerWidget> {
  int _curSwipeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          Swiper(
            itemCount: widget.bannerCount,
            itemBuilder: (context, index) {
              return widget.buildBannerItem(context, index);
            },
            autoplay: true,
            autoplayDisableOnInteraction: true,
            pagination: null,
            onIndexChanged: (index) {
              setState(() {
                _curSwipeIndex = index;
              });
            },
          ),
          Container(
            alignment: AlignmentDirectional.center,
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            height: 36.0,
            color: Colors.black54,
            child: Text(
              widget.bannerTitle(_curSwipeIndex),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
