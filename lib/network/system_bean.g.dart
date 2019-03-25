// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemBean _$SystemBeanFromJson(Map<String, dynamic> json) {
  return SystemBean(
      data: (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : SystemItemBean.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SystemBeanToJson(SystemBean instance) =>
    <String, dynamic>{'data': instance.data};

SystemItemBean _$SystemItemBeanFromJson(Map<String, dynamic> json) {
  return SystemItemBean(
      name: json['name'] as String,
      id: json['id'] as int,
      children: (json['children'] as List)
          ?.map((e) => e == null
              ? null
              : ChildrenBean.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      parentChapterId: json['parentChapterId'] as int);
}

Map<String, dynamic> _$SystemItemBeanToJson(SystemItemBean instance) =>
    <String, dynamic>{
      'children': instance.children,
      'id': instance.id,
      'name': instance.name,
      'parentChapterId': instance.parentChapterId
    };

ChildrenBean _$ChildrenBeanFromJson(Map<String, dynamic> json) {
  return ChildrenBean(name: json['name'] as String, id: json['id'] as int);
}

Map<String, dynamic> _$ChildrenBeanToJson(ChildrenBean instance) =>
    <String, dynamic>{'name': instance.name, 'id': instance.id};
