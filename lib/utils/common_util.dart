import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommonUtil {
  static Future<void> showCommonDialog(BuildContext context) {
    return showLoadingMsgDialog(context, '加载中...');
  }

  static Future<Null> showLoadingMsgDialog(
      BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.white),
                width: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitCircle(color: Colors.black,size: 35,),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
