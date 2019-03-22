import 'package:flutter/services.dart';

final MethodChannel _methodChannel = const MethodChannel('flutter:Android');

class AppRoute {
  static Future<void> intentShareArticle(Map<String, dynamic> arguments) async {
    try {
      await _methodChannel.invokeMethod('ShareArticle', arguments);
    } catch (e) {
      print(e);
    }
  }
}
