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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
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
            pagination: SwiperPagination(),
          ),
        ],
      ),
    );
  }
}
