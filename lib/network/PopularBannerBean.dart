class PopularBannerBean {
  int id;
  String desc;
  String imagePath;
  int isVisible;
  int order;
  String title;
  int type;
  String url;

  PopularBannerBean(
      {this.id,
      this.desc,
      this.imagePath,
      this.isVisible,
      this.order,
      this.title,
      this.type,
      this.url});

  factory PopularBannerBean.fromMap(Map<String, dynamic> map) {
    return PopularBannerBean(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      imagePath: map['imagePath'],
      isVisible: map['isVisible'],
      order: map['order'],
      type: map['type'],
      url: map['url'],
    );
  }
}
