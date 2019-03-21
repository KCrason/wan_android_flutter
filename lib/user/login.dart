import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:wan_android_flutter/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android_flutter/utils/constant.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _globalKey = new GlobalKey<ScaffoldState>();


  String _account;
  String _password;

  bool _isLogging = false;

  //保存登陆状态
  _saveLoginState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isLogin', true);
  }

  void _login() async {
    _isLogging = true;
    Dio dio = new Dio();
    Directory tempDir = await getTemporaryDirectory();
    PersistCookieJar persistCookieJar = new PersistCookieJar(dir: tempDir.path);

    dio.interceptors.add(CookieManager(persistCookieJar));
    Response response = await dio.post(Constants.loginUrl,
        queryParameters: {'username': _account, 'password': _password});

    final jsonResult = json.decode(response.toString());

    List<Cookie> cookies = persistCookieJar
        .loadForRequest(Uri.parse('https://www.wanandroid.com/user/login'));
    print('result cookies: $cookies');

    int errorCode = jsonResult['errorCode'];
    if (errorCode == 0) {
      _saveLoginState();
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) {
        return new Home();
      }), (route) => false);
    } else {
      setState(() {
        _isLogging = false;
      });
      _globalKey.currentState.showSnackBar(SnackBar(
        content: Text('登陆失败：${jsonResult['errorMsg']}'),
        duration: Duration(milliseconds: 500),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('登陆'),
      ),
      body: Container(
        child: new Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  labelText: '请输入用户名',
                  icon: Icon(
                    Icons.account_circle,
                  )),
              onChanged: (text) {
                setState(() {
                  _account = text;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: '请输入密码',
                  icon: Icon(
                    Icons.lock,
                  )),
              onChanged: (text) {
                setState(() {
                  _password = text;
                });
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0, right: 16.0),
              child: Align(
                child: Text(
                  '立即注册',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                alignment: FractionalOffset.centerRight,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: SizedBox(
                height: 44.0,
                width: MediaQuery.of(context).size.width * 0.7,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (_account == null || _account.length == 0) {
                      _globalKey.currentState
                          .showSnackBar(SnackBar(content: Text('请输入账户名')));
                      return;
                    }
                    if (_password == null || _password.length == 0) {
                      _globalKey.currentState
                          .showSnackBar(SnackBar(content: Text('请输入密码')));
                      return;
                    }
                    setState(() {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _login();
                    });
                  },
                  textColor: Colors.white,
                  child: Container(
                    height: 44.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Text(
                            '立即登录',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Container(
                          height: _isLogging ? 17 : 0,
                          width: _isLogging ? 17 : 0,
                          margin: EdgeInsets.only(left: _isLogging ? 16 : 0),
                          child: SizedBox(
                            width: 17,
                            height: 17,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}
