import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/user/login.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/utils/snackbar_util.dart';

class CollectionHelper {
  void unCollectionArticle(
      ScaffoldState _scaffoldKey, Function success, int articleId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLogin = sharedPreferences.getBool(Constants.preferenceKeyIsLogin);
    if (isLogin != null && isLogin) {
      Response response =
          await ApiRequest.unCollectionWebsiteArticle('$articleId');
      final jsonResult = json.decode(response.toString());
      int errorCode = jsonResult['errorCode'];
      if (errorCode == 0) {
        SnackBarUtil.showShortSnackBar(_scaffoldKey, '已取消收藏');
        if (success != null) {
          success(true);
        }
      } else {
        SnackBarUtil.showShortSnackBar(_scaffoldKey, '取消失败');
      }
    } else {
      Navigator.push(_scaffoldKey.context,
          new MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }
  }

  void collectionArticle(
      ScaffoldState _scaffoldKey, Function success, int articleId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLogin = sharedPreferences.getBool(Constants.preferenceKeyIsLogin);
    if (isLogin != null && isLogin) {
      Response response =
          await ApiRequest.collectionWebsiteArticle('$articleId');
      final jsonResult = json.decode(response.toString());
      int errorCode = jsonResult['errorCode'];
      if (errorCode == 0) {
        SnackBarUtil.showShortSnackBar(_scaffoldKey, '收藏成功');
        if (success != null) {
          success(true);
        }
      } else {
        SnackBarUtil.showShortSnackBar(_scaffoldKey, '收藏失败');
      }
    } else {
      Navigator.push(_scaffoldKey.context,
          new MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }
  }
}
