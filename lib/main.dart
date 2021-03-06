import 'package:flutter/material.dart';
import 'package:wan_android_flutter/home.dart';
import 'package:wan_android_flutter/discovery.dart';
import 'package:wan_android_flutter/me.dart';
import 'dart:ui';

//import 'package:shared_preferences/shared_preferences.dart';
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var _currentIndex = 0;
  var _pages = [new Home(), new Discovery(), new Me()];

  PageController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = 0;
    _controller = PageController(initialPage: 0);
  }

  _pageChange(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (context, index) {
          return _pages[index];
        },
        itemCount: _pages.length,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: _pageChange,
        controller: _controller,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: _currentIndex == 0
                  ? Text('首页',
                      style: TextStyle(color: Colors.blue))
                  : Text('首页'),
              activeIcon: Icon(
                Icons.home,
                color: Colors.blue,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              title: _currentIndex == 1
                  ? Text('最新',
                      style: TextStyle(color: Colors.blue))
                  : Text('最新'),
              activeIcon: Icon(
                Icons.explore,
                color: Colors.blue,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.group),
              title: _currentIndex == 2
                  ? Text('我的',
                      style: TextStyle(color:Colors.blue))
                  : Text('我的'),
              activeIcon: Icon(
                Icons.group,
                color: Colors.blue,
              )),
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.blue,
        onTap: (index) {
          _controller.jumpToPage(index);
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
