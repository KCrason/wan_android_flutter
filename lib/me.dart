import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:wan_android_flutter/my_collection_page.dart';
import 'utils/user_helper.dart';
import 'events/user_login_event.dart';
import 'dart:async';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> with AutomaticKeepAliveClientMixin {
  String _userName = '还未登陆，点击登陆';

  final _globalKey = new GlobalKey<ScaffoldState>();

  bool _isLogin = false;

  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    isLogin();
    getUserName();
    _streamSubscription = eventBus.on<UserLoginEvent>().listen((event) {
      if (event.isLoginSuccess) {
        _isLogin = true;
        getUserName();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamSubscription.cancel();
  }

  void getUserName() {
    UserHelper.getUserName().then((username) {
      if (username != null) {
        setState(() {
          _userName = username;
        });
      }
    });
  }

  void isLogin() async {
    _isLogin = await UserHelper.isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('我的'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    child: SizedBox(
                      width: 90,
                      height: 90,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/flutter.jpg'),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    alignment: Alignment(0, -0.5),
                  ),
                  Padding(
                    child: GestureDetector(
                      onTap: () {
                        UserHelper.isLogin().then((result) {
                          if (result == null || !result) {
                            UserHelper.toLogin(context);
                          }
                        });
                      },
                      child: Text(
                        _userName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ),
                    padding: EdgeInsets.only(top: 16),
                  )
                ],
              ),
            ),
            height: 250,
          ),
          Card(
            child: ListTile(
              title: Text('我的收藏'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                UserHelper.isLogin().then((result) {
                  if (result != null && result) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MyCollectionPage();
                    }));
                  } else {
                    UserHelper.toLogin(context);
                  }
                });
              },
            ),
          ),
          Offstage(
            offstage: !_isLogin,
            child: Card(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                color: Colors.red,
                child: InkWell(
                  child: Container(
                    height: 48.0,
                    width: window.physicalSize.width,
                    child: Center(
                      child: Text(
                        '退出登陆',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400,color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    UserHelper.loginOut(_globalKey.currentState, () {
                      setState(() {
                        _isLogin = false;
                        _userName = '还未登陆，点击登陆';
                      });
                    });
                  },
                )),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
