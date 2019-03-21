package com.kcrason.wan_android_flutter;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    public static EventChannel.EventSink mLoginEventSink;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(this.getFlutterView(), "flutter:Android")
                .setMethodCallHandler((methodCall, result) -> {
                    if (methodCall.method.equals("ArticleDetail")) {
                        shareFile(methodCall.arguments);
                    }
                });

        new EventChannel(this.getFlutterView(), "android:Flutter").setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink eventSink) {
                mLoginEventSink = eventSink;
                Toast.makeText(MainActivity.this, mLoginEventSink.toString(), Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onCancel(Object o) {

            }
        });
    }

    private void shareFile(Object arguments) {
        if (arguments instanceof Map) {
            Map newArguments = (Map) arguments;
            startActivity(new Intent(this, WebViewActivity.class)
                    .putExtra("key_title", (String) newArguments.get("title"))
                    .putExtra("key_url", (String) newArguments.get("url")));
        } else {
            Toast.makeText(this, "无法打开页面", Toast.LENGTH_SHORT).show();
        }
    }
}
