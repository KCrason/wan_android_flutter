import 'package:json_annotation/json_annotation.dart';

part 'article_bean.g.dart';

@JsonSerializable()
class ArticleBean {
  int curPage;
  int total;
  List<ArticleItem> datas;

  ArticleBean({
    this.curPage,
    this.total,
    this.datas,
  });

  factory ArticleBean.fromJson(Map<String, dynamic> json) =>
      _$ArticleBeanFromJson(json);
}

@JsonSerializable()
class ArticleItem {
  String author;
  bool collect;
  String link;
  String niceDate;
  String title;
  int id;
  String envelopePic;
  String desc;
  int originId;

  ArticleItem(
      {this.title,
      this.author,
      this.collect,
      this.link,
      this.niceDate,
      this.id,
      this.envelopePic,this.desc,this.originId});

  factory ArticleItem.fromJson(Map<String, dynamic> json) =>
      _$ArticleItemFromJson(json);
}
