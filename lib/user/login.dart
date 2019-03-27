import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android_flutter/utils/constant.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:wan_android_flutter/utils/user_helper.dart';
import 'package:wan_android_flutter/events/user_login_event.dart';
import 'package:wan_android_flutter/utils/common_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _globalKey = new GlobalKey<ScaffoldState>();

  String _account;
  String _password;

  FocusNode _focusNodeAccount = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();

  //保存登陆状态
  _saveLoginState(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(Constants.preferenceKeyIsLogin, true);
    await preferences.setString(Constants.preferenceKeyUserName, userName);
    eventBus.fire(UserLoginEvent(isLoginSuccess: true));
  }

  void _login() async {
    CommonUtil.showLoadingMsgDialog(context, '登录中...');
    ApiRequest.login(_account, _password).then((response) {
      final jsonResult = json.decode(response.toString());
      int errorCode = jsonResult['errorCode'];
      if (errorCode == 0) {
        _saveLoginState(jsonResult['data']['username']);
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        ToastUtil.showShortToast(context, '登陆失败：${jsonResult['errorMsg']}');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNodeAccount.addListener(() {
      setState(() {});
    });
    _focusNodePassword.addListener(() {
      setState(() {});
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
                  labelStyle: TextStyle(
                      color: _focusNodeAccount.hasFocus
                          ? Colors.blue
                          : Colors.black),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  icon: _focusNodeAccount.hasFocus
                      ? Icon(
                          Icons.account_circle,
                          color: Colors.blue,
                        )
                      : Icon(
                          Icons.account_circle,
                        )),
              focusNode: _focusNodeAccount,
              onChanged: (text) {
                setState(() {
                  _account = text;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: '请输入密码',
                  labelStyle: TextStyle(
                      color: _focusNodePassword.hasFocus
                          ? Colors.blue
                          : Colors.black),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  icon: _focusNodePassword.hasFocus
                      ? Icon(
                          Icons.lock,
                          color: Colors.blue,
                        )
                      : Icon(
                          Icons.lock,
                        )),
              focusNode: _focusNodePassword,
              obscureText: true,
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
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                alignment: FractionalOffset.centerRight,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Card(
                color: Colors.blue,
                child: InkWell(
                  onTap: () {
                    if (_account == null || _account.length == 0) {
                      ToastUtil.showShortToast(context, '请输入账户名');
                      return;
                    }
                    if (_password == null || _password.length == 0) {
                      ToastUtil.showShortToast(context, '请输入密码');
                      return;
                    }
                    setState(() {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _login();
                    });
                  },
                  child: Container(
                    height: 44.0,
                    child: Center(
                      child: Text(
                        '立即登录',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
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
