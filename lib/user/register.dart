import 'package:flutter/material.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/utils/snackbar_util.dart';
import 'dart:convert';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _globalKey = new GlobalKey<ScaffoldState>();

  String _account;
  String _password;
  String _rePassword;

  bool _isLogging = false;

  void _register() async {
    _isLogging = true;
    ApiRequest.register(_account, _password, _rePassword).then((response) {
      final jsonResult = json.decode(response.toString());
      int errorCode = jsonResult['errorCode'];
      if (errorCode == 0) {
        SnackBarUtil.showShortSnackBar(_globalKey.currentState, '注册成功');
        Navigator.pop(context);
      } else {
        SnackBarUtil.showShortSnackBar(
            _globalKey.currentState, '注册失败：${jsonResult['errorMsg']}');
      }
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
                  labelText: '注册用户名',
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
                  labelText: '设置密码',
                  icon: Icon(
                    Icons.lock,
                  )),
              onChanged: (text) {
                setState(() {
                  _password = text;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: '确认密码',
                  icon: Icon(
                    Icons.lock,
                  )),
              onChanged: (text) {
                setState(() {
                  _rePassword = text;
                });
              },
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
                    if (_rePassword == null || _rePassword.length == 0) {
                      _globalKey.currentState
                          .showSnackBar(SnackBar(content: Text('请输入确认密码')));
                      return;
                    }
                    setState(() {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _register();
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
                            '立即注册',
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
