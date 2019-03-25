import 'package:json_annotation/json_annotation.dart';

part 'system_bean.g.dart';

@JsonSerializable()
class SystemBean {
  List<SystemItemBean> data;

  SystemBean({this.data});

  factory SystemBean.fromJson(Map<String, dynamic> json) =>
      _$SystemBeanFromJson(json);
}

@JsonSerializable()
class SystemItemBean {
  List<ChildrenBean> children;
  int id;
  String name;
  int parentChapterId;

  SystemItemBean({this.name, this.id, this.children, this.parentChapterId});

  factory SystemItemBean.fromJson(Map<String, dynamic> json) =>
      _$SystemItemBeanFromJson(json);
}

@JsonSerializable()
class ChildrenBean {
  String name;
  int id;

  ChildrenBean({this.name, this.id});

  factory ChildrenBean.fromJson(Map<String, dynamic> json) => _$ChildrenBeanFromJson(json);
}
