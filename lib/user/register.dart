import 'package:flutter/material.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'dart:convert';
import 'package:wan_android_flutter/utils/common_util.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _globalKey = new GlobalKey<ScaffoldState>();

  String _account;
  String _password;
  String _rePassword;

  FocusNode _focusNodeAccount = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();
  FocusNode _focusNodeRePassword = new FocusNode();

  void _register() async {
    CommonUtil.showLoadingMsgDialog(context, '注册中...');
    ApiRequest.register(_account, _password, _rePassword).then((response) {
      final jsonResult = json.decode(response.toString());
      int errorCode = jsonResult['errorCode'];
      if (errorCode == 0) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        ToastUtil.showShortToast(context, '注册失败：${jsonResult['errorMsg']}');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNodeRePassword.addListener(() {
      setState(() {});
    });
    _focusNodePassword.addListener(() {
      setState(() {});
    });
    _focusNodeAccount.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: Container(
        child: new Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  labelText: '请输入注册用户名',
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
                  labelText: '请设置密码',
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
            TextField(
              decoration: InputDecoration(
                  labelText: '请确认密码',
                  labelStyle: TextStyle(
                      color: _focusNodeRePassword.hasFocus
                          ? Colors.blue
                          : Colors.black),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  icon: _focusNodeRePassword.hasFocus
                      ? Icon(
                          Icons.lock_outline,
                          color: Colors.blue,
                        )
                      : Icon(
                          Icons.lock_outline,
                        )),
              focusNode: _focusNodeRePassword,
              obscureText: true,
              onChanged: (text) {
                setState(() {
                  _rePassword = text;
                });
              },
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
                    if (_rePassword == null || _rePassword.length == 0) {
                      ToastUtil.showShortToast(context, '请输入确认密码');
                      return;
                    }
                    if (_rePassword != _password) {
                      ToastUtil.showShortToast(context, '两次输入的密码不一致');
                      return;
                    }
                    setState(() {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _register();
                    });
                  },
                  child: Container(
                    height: 44.0,
                    child: Center(
                      child: Text(
                        '立即注册',
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
