// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleBean _$ArticleBeanFromJson(Map<String, dynamic> json) {
  return ArticleBean(
      curPage: json['curPage'] as int,
      total: json['total'] as int,
      datas: (json['datas'] as List)
          ?.map((e) => e == null
              ? null
              : ArticleItem.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ArticleBeanToJson(ArticleBean instance) =>
    <String, dynamic>{
      'curPage': instance.curPage,
      'total': instance.total,
      'datas': instance.datas
    };

ArticleItem _$ArticleItemFromJson(Map<String, dynamic> json) {
  return ArticleItem(
      title: json['title'] as String,
      author: json['author'] as String,
      collect: json['collect'] as bool,
      link: json['link'] as String,
      niceDate: json['niceDate'] as String,
      id: json['id'] as int,
      envelopePic: json['envelopePic'] as String,
      desc: json['desc'] as String);
}

Map<String, dynamic> _$ArticleItemToJson(ArticleItem instance) =>
    <String, dynamic>{
      'author': instance.author,
      'collect': instance.collect,
      'link': instance.link,
      'niceDate': instance.niceDate,
      'title': instance.title,
      'id': instance.id,
      'envelopePic': instance.envelopePic,
      'desc': instance.desc
    };
