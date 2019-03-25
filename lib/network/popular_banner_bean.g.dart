// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_banner_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularBannerBean _$PopularBannerBeanFromJson(Map<String, dynamic> json) {
  return PopularBannerBean(
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : BannerItem.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$PopularBannerBeanToJson(PopularBannerBean instance) =>
    <String, dynamic>{'data': instance.data};

BannerItem _$BannerItemFromJson(Map<String, dynamic> json) {
  return BannerItem(
      id: json['id'] as int,
      desc: json['desc'] as String,
      imagePath: json['imagePath'] as String,
      isVisible: json['isVisible'] as int,
      order: json['order'] as int,
      title: json['title'] as String,
      type: json['type'] as int,
      url: json['url'] as String);
}

Map<String, dynamic> _$BannerItemToJson(BannerItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'desc': instance.desc,
      'imagePath': instance.imagePath,
      'isVisible': instance.isVisible,
      'order': instance.order,
      'title': instance.title,
      'type': instance.type,
      'url': instance.url
    };
