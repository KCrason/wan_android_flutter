import 'package:flutter/services.dart';

class AppRoute {
  static Future<void> intentArticleDetail(
      Map<String, dynamic> arguments) async {
    try {
      final channel = const MethodChannel('flutter:Android');
      await channel.invokeMethod('ArticleDetail', arguments);
    } catch (e) {
      print(e);
    }
  }
}
