import 'package:json_annotation/json_annotation.dart';

part 'popular_banner_bean.g.dart';

@JsonSerializable()
class PopularBannerBean {
  List<BannerItem> data;

  PopularBannerBean({this.data});

  factory PopularBannerBean.fromJson(Map<String, dynamic> map) => _$PopularBannerBeanFromJson(map);
}

@JsonSerializable()
class BannerItem {
  int id;
  String desc;
  String imagePath;
  int isVisible;
  int order;
  String title;
  int type;
  String url;

  BannerItem(
      {this.id,
      this.desc,
      this.imagePath,
      this.isVisible,
      this.order,
      this.title,
      this.type,
      this.url});

  factory BannerItem.fromJson(Map<String, dynamic> map) =>
      _$BannerItemFromJson(map);
}
