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
      title: 'Play Android',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var _currentIndex = 0;
  var _pages = [new Home(), new Discovery(), new Me()];

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
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
          BottomNavigationBarItem(icon: Icon(Icons.explore), title: Text('发现')),
          BottomNavigationBarItem(icon: Icon(Icons.group), title: Text('我的')),
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
