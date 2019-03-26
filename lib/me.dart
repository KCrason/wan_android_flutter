import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android_flutter/utils/constant.dart';
import 'package:wan_android_flutter/my_collection_page.dart';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> with AutomaticKeepAliveClientMixin {
  String _userName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((preferences) {
      setState(() {
        dynamic _localUserName =
            preferences.get(Constants.preferenceKeyUserName);
        if (_localUserName != null) {
          setState(() {
            _userName = _localUserName;
          });
        }
      });
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
                        backgroundImage: NetworkImage(
                            "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    alignment: Alignment(0, -0.5),
                  ),
                  Padding(
                    child: Text(
                      _userName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyCollectionPage();
                }));
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
