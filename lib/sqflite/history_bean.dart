class SearchHistoryBean {
  int searchTime;
  String searchWord;

  SearchHistoryBean({this.searchTime, this.searchWord});

  Map<String, dynamic> toMap() {
    Map map = <String, dynamic>{
      'searchTime': searchTime,
      'searchWord': searchWord,
    };
    return map;
  }

  SearchHistoryBean.fromMap(Map<String, dynamic> map) {
    searchWord = map['searchWord'];
    searchTime = map['searchTime'];
  }
}
