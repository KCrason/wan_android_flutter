import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/user/login.dart';

class UserHelper {
  static Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  static Future<String> getUserName() async {
    if (await isLogin()) {
      SharedPreferences sharedPreferences = await getSharedPreferences();
      return sharedPreferences.get(Constants.preferenceKeyUserName);
    }
    return '你还未登陆,点击登陆';
  }

  static Future<bool> isLogin() async {
    SharedPreferences sharedPreferences = await getSharedPreferences();
    return sharedPreferences.get(Constants.preferenceKeyIsLogin);
  }

  static void toLogin(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }
}
