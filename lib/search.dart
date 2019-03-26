import 'package:flutter/material.dart';
import 'sqflite/sqf_helper.dart';
import 'sqflite/history_bean.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      String newText = _controller.text;
    });
  }

  void insertSearch() async {
    var db = SqfHelper();
    await db.insertSearchHistory(SearchHistoryBean(
        searchTime: DateTime.now().millisecondsSinceEpoch,
        searchWord: '尼玛傻逼1'));
    await db.insertSearchHistory(SearchHistoryBean(
        searchTime: DateTime.now().millisecondsSinceEpoch,
        searchWord: '尼玛傻逼2'));
    await db.insertSearchHistory(SearchHistoryBean(
        searchTime: DateTime.now().millisecondsSinceEpoch,
        searchWord: '尼玛傻逼3'));

    List searchBeans = await db.queryAllSearchHistory();

    searchBeans.forEach((item) {
      SearchHistoryBean searchHistoryBean = SearchHistoryBean.fromMap(item);
      print(
          'Db data:[searchTime:${searchHistoryBean.searchTime},searchWord:${searchHistoryBean.searchWord}]');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.grey,
        ),
        backgroundColor: Colors.white,
        title: Container(
          alignment: Alignment.center,
          height: 40.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration.collapsed(
              hintText: '请输入你要搜索的内容',
            ),
            onFieldSubmitted: (value) {
              print('ValueChange:$value');
            },
          ),
        ),
      ),
      body: new Center(
        child: Text('暂无搜索历史'),
      ),
    );
  }
}

class SearchHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
