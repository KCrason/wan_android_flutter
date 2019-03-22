import 'package:flutter/material.dart';

class SnackBarUtil {
  static void showShortSnackBar(ScaffoldState scaffoldState, String message) {
    scaffoldState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 500),
    ));
  }

  static void showLongSnackBar(ScaffoldState scaffoldState, String message) {
    scaffoldState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),
    ));
  }
}
