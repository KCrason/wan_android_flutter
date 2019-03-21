import 'package:flutter/material.dart';
import 'package:wan_android_flutter/home.dart';
import 'package:wan_android_flutter/discovery.dart';
import 'package:wan_android_flutter/me.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'user/login.dart';

//import 'package:shared_preferences/shared_preferences.dart';
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play Android',
      theme: ThemeData.dark(),
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

  static const loginPlugin = const EventChannel('android:Flutter');

  PageController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = 0;
    _controller = PageController(initialPage: 0);
    loginPlugin.receiveBroadcastStream().listen((value) {
      switch (value) {
        case 'IntentToLogin':
          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return Login();
            }));
          });
          break;
      }
    }, onError: (error) {
      print('This is Error Message:$error');
    });
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
      appBar: PreferredSize(
          child: Offstage(
            offstage: false,
            child: AppBar(
              elevation: 0,
            ),
          ),
          preferredSize: Size.fromHeight(_currentIndex == 0
              ? 0.07
              : MediaQuery.of(context).size.height * 0.07)),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
          BottomNavigationBarItem(icon: Icon(Icons.explore), title: Text('导航')),
          BottomNavigationBarItem(icon: Icon(Icons.group), title: Text('我的')),
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
