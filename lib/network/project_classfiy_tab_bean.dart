import 'package:json_annotation/json_annotation.dart';

part 'project_classfiy_tab_bean.g.dart';

@JsonSerializable()
class ProjectClassifyTabBean {
  List<ProjectClassifyTabItem> data;

  ProjectClassifyTabBean({this.data});

  factory ProjectClassifyTabBean.fromJson(Map<String, dynamic> json) {
    return _$ProjectClassifyBeanFromJson(json);
  }
}

@JsonSerializable()
class ProjectClassifyTabItem {
  String name;
  int courseId;
  int id;

  ProjectClassifyTabItem({this.name, this.courseId, this.id});

  factory ProjectClassifyTabItem.fromJson(Map<String, dynamic> json) {
    return _$ProjectClassifyItemFromJson(json);
  }
}
