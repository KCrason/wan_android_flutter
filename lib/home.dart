import 'package:flutter/material.dart';
import 'package:wan_android_flutter/search.dart';
import 'home/project.dart';
import 'home/popular.dart';
import 'home/public.dart';
import 'home/system.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> with SingleTickerProviderStateMixin {
  final tabs = ['头条', '项目', '公众号', '体系'];
  var _homeItems = [Popular(), Project(), Public(), System()];
  TabController _tabController;
  var _currentTabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            height: 36.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Text(
                    '热门',
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                  flex: 8,
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return new Search();
            }));
          },
        ),
        bottom: TabBar(
            controller: _tabController,
            tabs: tabs.map((s) {
              return Tab(
                text: s,
              );
            }).toList()),
      ),
      body: new TabBarView(
          controller: _tabController,
          children: tabs.map((s) {
            return _homeItems[_currentTabIndex];
          }).toList()),
    );
  }
}