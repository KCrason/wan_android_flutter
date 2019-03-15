class PopularArticleBean {
  String author;
  bool collect;
  String link;
  String niceDate;
  String title;

  PopularArticleBean(
      {this.title, this.author, this.collect, this.link, this.niceDate});

  factory PopularArticleBean.fromMap(Map<String, dynamic> map) {
    return PopularArticleBean(
        title: map['title'],
        author: map['author'],
        collect: map['collect'],
        link: map['link'],
        niceDate: map['niceDate']);
  }
}
