import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:wan_android_flutter/my_collection_page.dart';
import 'utils/user_helper.dart';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> with AutomaticKeepAliveClientMixin {
  String _userName = '还未登陆，点击登陆';

  @override
  void initState() {
    super.initState();
    UserHelper.getUserName().then((username) {
      if (username != null) {
        setState(() {
          _userName = username;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
