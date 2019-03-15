import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:wan_android_flutter/network/PopularBannerBean.dart';
import 'package:wan_android_flutter/widgets/PopularBanner.dart';
import 'package:wan_android_flutter/network/PopularArticleBean.dart';
import 'package:transparent_image/transparent_image.dart';

//头条
class Popular extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _PopularState();
  }
}

class _PopularState extends State<Popular> {
  List _bannerData;
  List _articleData;

  void _requestBanner() async {
    try {
      Response responseBanner =
          await Dio().get('https://www.wanandroid.com/banner/json');
      Response responseArticle =
          await Dio().get('https://www.wanandroid.com/article/list/0/json');
      final bannerJson = json.decode(responseBanner.toString());
      final articleJson = json.decode(responseArticle.toString());
      setState(() {
        _bannerData = bannerJson['data'];
        _articleData = articleJson['data']['datas'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestBanner();
  }

  Widget getBody() {
    if (_articleData == null) {
      return new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                '加载中...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        child: Center(
          child: ListView.builder(
              itemCount: _articleData == null ? 1 : _articleData.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PopularBannerWidget(
                    bannerTitle: (index) {
                      return PopularBannerBean.fromMap(_bannerData[index])
                          .title;
                    },
                    bannerCount: _bannerData == null ? 0 : _bannerData.length,
                    buildBannerItem: (context, index) {
                      PopularBannerBean popularBannerBean =
                          PopularBannerBean.fromMap(_bannerData[index]);
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            print('You click $index');
                          },
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: popularBannerBean.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }
                PopularArticleBean popularArticleBean =
                    PopularArticleBean.fromMap(_articleData[index - 1]);
                return ListTile(
                  trailing: Icon(
                    popularArticleBean.collect
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  title: Text('${popularArticleBean.title}'),
                );
              }),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getBody();
  }
}
