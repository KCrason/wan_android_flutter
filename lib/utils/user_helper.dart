import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/user/login.dart';
import 'package:wan_android_flutter/user/register.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:wan_android_flutter/utils/common_util.dart';

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
    bool isLogin = sharedPreferences.get(Constants.preferenceKeyIsLogin);
    return isLogin == null ? false : isLogin;
  }

  static void toLogin(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  static void toRegister(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Register();
    }));
  }

  static void loginOut(BuildContext context, Function callBack) async {
    CommonUtil.showLoadingMsgDialog(context, '退出中...');
    SharedPreferences preferences = await getSharedPreferences();
    PersistCookieJar persistCookieJar = await ApiRequest.getCookieJar();
    ApiRequest.loginOut().then((result) {
      int errorCode = result.data['errorCode'];
      if (errorCode == 0) {
        Navigator.of(context, rootNavigator: true).pop();
        preferences.clear();
        persistCookieJar.deleteAll();
        ToastUtil.showShortToast(context, '已退出');
        if (callBack != null) {
          callBack();
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        ToastUtil.showShortToast(
            context, '退出失败:${result.data['errorMessage']}');
      }
    }).catchError(() {
      Navigator.of(context, rootNavigator: true).pop();
      ToastUtil.showShortToast(context, '退出失败');
    });
  }
}
