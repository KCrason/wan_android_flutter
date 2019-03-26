import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android_flutter/utils/constant.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/utils/snackbar_util.dart';
import 'package:wan_android_flutter/utils/user_helper.dart';
import 'package:wan_android_flutter/events/user_login_event.dart';

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
  _saveLoginState(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(Constants.preferenceKeyIsLogin, true);
    await preferences.setString(Constants.preferenceKeyUserName, userName);
    eventBus.fire(UserLoginEvent(isLoginSuccess: true));
  }

  void _login() async {
    _isLogging = true;
    ApiRequest.login(_account, _password).then((response) {
      final jsonResult = json.decode(response.toString());
      int errorCode = jsonResult['errorCode'];
      if (errorCode == 0) {
        _saveLoginState(jsonResult['data']['username']);
        Navigator.pop(context);
      } else {
        setState(() {
          _isLogging = false;
        });
        SnackBarUtil.showShortSnackBar(
            _globalKey.currentState, '登陆失败：${jsonResult['errorMsg']}');
      }
    });
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
                child: GestureDetector(
                  onTap: () {
                    UserHelper.toRegister(context);
                  },
                  child: Text(
                    '立即注册',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
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
