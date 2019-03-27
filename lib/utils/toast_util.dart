import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ToastUtil {
  static void showShortToast(BuildContext context, String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

}
