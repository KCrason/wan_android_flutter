import 'package:shared_preferences/shared_preferences.dart';
import 'package:wan_android_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/utils/snackbar_util.dart';

import 'package:wan_android_flutter/utils/user_helper.dart';

class CollectionHelper {
  void unCollectionArticleForMyCollectionPage(ScaffoldState _scaffoldKey,
      Function success, int articleId, int originId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLogin = sharedPreferences.getBool(Constants.preferenceKeyIsLogin);
    if (isLogin != null && isLogin) {
      Response response =
          await ApiRequest.unCollectionWebsiteArticleForMyCollectionPage(
              articleId, originId);
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
      UserHelper.toLogin(_scaffoldKey.context);
    }
  }

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
      UserHelper.toLogin(_scaffoldKey.context);
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
      UserHelper.toLogin(_scaffoldKey.context);
    }
  }
}
