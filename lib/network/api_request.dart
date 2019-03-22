import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:wan_android_flutter/utils/constant.dart';
import 'dart:io';
import 'dart:convert';

class ApiRequest {
  //登陆
  static Future<Response> login(String username, String password) async {
    Dio dio = Dio();
    PersistCookieJar persistCookieJar = await getCookieJar();
    dio.interceptors.add(CookieManager(persistCookieJar));
    return await dio.post(Constants.loginUrl,
        data: FormData.from({'username': username, 'password': password}));
  }

  //获取banner数据
  static Future<Response> getBannerData() async {
    return await Dio().get(Constants.popularBannerUrl);
  }

  //获取头条数据
  static Future<Response> getPopularListData(int curPage) async {
    return await Dio().get(Constants.generatePopularArticleUrl(curPage),
        options: _getOptions(await getCookieJar()));
  }

  //获取收藏列表
  static Future<Response> getCollectionListData(int curPage) async {
    return await Dio().get(Constants.generateCollectionListUrl(curPage),
        options: _getOptions(await getCookieJar()));
  }

  //收藏站内文章
  static Future<Response> collectionWebsiteArticle(String articleId) async {
    return await Dio().post(
        Constants.generateCollectionWebsiteArticleUrl(articleId),
        options: _getOptions(await getCookieJar()));
  }

  //取消收藏
  static Future<Response> unCollectionWebsiteArticle(String articleId) async {
    return await Dio().post(
        Constants.generateUnCollectionWebsiteArticleUrl(articleId),
        options: _getOptions(await getCookieJar()));
  }

  static _getOptions(PersistCookieJar persistCookieJar) {
    List<Cookie> cookies =
        persistCookieJar.loadForRequest(Uri.parse(Constants.loginUrl));
    List<String> listCookiesResult = new List<String>();
    cookies.forEach(
        (cookie) => listCookiesResult.add('${cookie.name}=${cookie.value}'));
    final cookiesResult = json
        .encode(listCookiesResult)
        .replaceAll("\{\"", "")
        .replaceAll("\"\}", "")
        .replaceAll("\",\"", "; ");
    return Options(headers: {'Cookie': cookiesResult});
  }

  //获取cookie持久化对象
  static Future<PersistCookieJar> getCookieJar() async {
    Directory tempDir = await getTemporaryDirectory();
    PersistCookieJar persistCookieJar = new PersistCookieJar(dir: tempDir.path);
    return persistCookieJar;
  }
}
