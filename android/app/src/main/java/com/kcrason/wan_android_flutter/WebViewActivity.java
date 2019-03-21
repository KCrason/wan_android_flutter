package com.kcrason.wan_android_flutter;

import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import android.widget.ProgressBar;
import android.widget.Toast;

import io.flutter.plugin.common.EventChannel;

public class WebViewActivity extends AppCompatActivity {
    private WebView mWebView;
    private String mArticleTitle;
    private String mArticleUrl;
    private SlowlyProgressBar mSlowlyProgressBar;


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_more_options, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                finish();
                break;
            case R.id.action_share:
                Intent shareIntent = new Intent(Intent.ACTION_SEND);
                shareIntent.setType("text/plain");
                shareIntent.putExtra(Intent.EXTRA_SUBJECT, mArticleTitle);//添加分享内容标题
                shareIntent.putExtra(Intent.EXTRA_TEXT, mArticleUrl);//添加分享内容
                this.startActivity(Intent.createChooser(shareIntent, "分享"));
                break;
            case R.id.action_collection:
                if (MainActivity.mLoginEventSink != null) {
                    MainActivity.mLoginEventSink.success("IntentToLogin");
                    finish();
                } else {
                    Toast.makeText(WebViewActivity.this, "EventSink is null!", Toast.LENGTH_SHORT).show();
                }
                break;
            case R.id.action_browser:
                Uri uri = Uri.parse(mArticleUrl);
                Intent intent = new Intent();
                intent.setAction("android.intent.action.VIEW");
                intent.setData(uri);
                startActivity(intent);
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bottom_sheet);
        mArticleTitle = getIntent().getStringExtra("key_title");
        mArticleUrl = getIntent().getStringExtra("key_url");
        Toolbar toolbar = findViewById(R.id.tool_bar);
        toolbar.setTitle(mArticleTitle);
        setSupportActionBar(toolbar);
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setDisplayHomeAsUpEnabled(true);
            actionBar.setDisplayShowTitleEnabled(true);
        }
        mWebView = findViewById(R.id.web_view);
        ProgressBar progressBar = findViewById(R.id.progress_view);
        mSlowlyProgressBar = new SlowlyProgressBar(progressBar);

        mWebView.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                if (mSlowlyProgressBar != null) {
                    mSlowlyProgressBar.onProgressStart();
                }
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                // TODO Auto-generated method stub
                //返回值是true的时候控制去WebView打开，为false调用系统浏览器或第三方浏览器
                if (url == null) return false;
                if (url.startsWith("http:") || url.startsWith("https:")) {
                    view.loadUrl(url);
                }
                return true;
            }

        });

        mWebView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onProgressChanged(WebView view, int newProgress) {
                super.onProgressChanged(view, newProgress);
                if (mSlowlyProgressBar != null) {
                    mSlowlyProgressBar.onProgressChange(newProgress);
                }
            }
        });
        WebSettings webSettings = mWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setSupportZoom(true);
        mWebView.setInitialScale(25);
        mWebView.getSettings().setUseWideViewPort(true);
        mWebView.getSettings().setBlockNetworkImage(false);
        mWebView.loadUrl(mArticleUrl);
    }
}
