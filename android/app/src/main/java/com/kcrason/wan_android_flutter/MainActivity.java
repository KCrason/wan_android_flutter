package com.kcrason.wan_android_flutter;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(this.getFlutterView(), "flutter:Android")
                .setMethodCallHandler((methodCall, result) -> {
                    if (methodCall.method.equals("ShareArticle")) {
                        shareFile(methodCall.arguments);
                    }
                });
    }

    private void shareFile(Object arguments) {
        if (arguments instanceof Map) {
            Map newArguments = (Map) arguments;
            Intent shareIntent = new Intent(Intent.ACTION_SEND);
            shareIntent.setType("text/plain");
            shareIntent.putExtra(Intent.EXTRA_SUBJECT, (String) newArguments.get("title"));//添加分享内容标题
            shareIntent.putExtra(Intent.EXTRA_TEXT, (String) newArguments.get("url"));//添加分享内容
            this.startActivity(Intent.createChooser(shareIntent, "分享"));
        } else {
            Toast.makeText(this, "该内容无法分享", Toast.LENGTH_SHORT).show();
        }
    }
}
