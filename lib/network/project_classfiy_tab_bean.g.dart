// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_classfiy_tab_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectClassifyTabBean _$ProjectClassifyTabBeanFromJson(
    Map<String, dynamic> json) {
  return ProjectClassifyTabBean(
      data: (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : ProjectClassifyTabItem.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ProjectClassifyTabBeanToJson(
        ProjectClassifyTabBean instance) =>
    <String, dynamic>{'data': instance.data};

ProjectClassifyTabItem _$ProjectClassifyTabItemFromJson(
    Map<String, dynamic> json) {
  return ProjectClassifyTabItem(
      name: json['name'] as String,
      courseId: json['courseId'] as int,
      id: json['id'] as int);
}

Map<String, dynamic> _$ProjectClassifyTabItemToJson(
        ProjectClassifyTabItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'courseId': instance.courseId,
      'id': instance.id
    };
