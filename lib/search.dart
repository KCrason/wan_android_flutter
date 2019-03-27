import 'package:flutter/material.dart';
import 'sqflite/sqf_helper.dart';
import 'sqflite/history_bean.dart';
import 'search_result_page.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'events/update_search_event.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller = new TextEditingController();

  Widget _widget = new Center(
    child: Text('暂无搜索历史'),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadHistorySearchData();
    eventBus.on<UpdateSearchEvent>().listen((event) {
      loadHistorySearchData();
    });
  }

  void insertSearch(String keyWord) async {
    var db = SqfHelper();
    await db.insertSearchHistory(SearchHistoryBean(
        searchTime: DateTime.now().millisecondsSinceEpoch,
        searchWord: keyWord));
  }

  void deleteSearch(String name) async {
    var db = SqfHelper();
    int result = await db.deleteItem(name);
    if (result > 0) {
      loadHistorySearchData();
    }
  }

  void loadHistorySearchData() async {
    var db = SqfHelper();
    List searchBeans = await db.queryAllSearchHistory();
    if (searchBeans != null && searchBeans.length > 0) {
      setState(() {
        _widget = ListView.builder(
          itemBuilder: (context, index) {
            SearchHistoryBean searchHistoryBean =
                SearchHistoryBean.fromMap(searchBeans[index]);
            return ListTile(
              title: Text(searchHistoryBean.searchWord),
              trailing: InkWell(
                child: Icon(Icons.clear),
                onTap: () {
                  deleteSearch(searchHistoryBean.searchWord);
                },
              ),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return SearchResultPage(
                    keyWord: searchHistoryBean.searchWord,
                  );
                }));
              },
            );
          },
          itemCount: searchBeans.length,
        );
      });
    } else {
      setState(() {
        _widget = new Center(
          child: Text('暂无搜索历史'),
        );
      });
    }
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration.collapsed(
                    hintText: '请输入你要搜索的内容',
                  ),
                  onFieldSubmitted: (value) {
                    print('ValueChange:$value');
                  },
                ),
                flex: 1,
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.search),
                ),
                onTap: () {
                  if (_controller.text.isEmpty) {
                    ToastUtil.showShortToast(context, '搜索关键字不能为空哦');
                    return;
                  }
                  insertSearch(_controller.text);
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) {
                    return SearchResultPage(
                      keyWord: _controller.text,
                    );
                  }));
                },
              )
            ],
          ),
        ),
      ),
      body: _widget,
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
