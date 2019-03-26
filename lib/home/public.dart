//公众号

import 'package:flutter/material.dart';
import 'package:wan_android_flutter/widgets/multi_status_page_widget.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/network/project_classfiy_tab_bean.dart';
import 'package:random_color/random_color.dart';
import 'package:wan_android_flutter/home/public_article_list_page.dart';

class Public extends StatefulWidget {
  @override
  _PublicState createState() => _PublicState();
}

class _PublicState extends State<Public> with AutomaticKeepAliveClientMixin {
  MultiStatus _multiStatus = MultiStatus.loading;

  List<Widget> widgets = new List();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    ApiRequest.getPublicTabData().then((result) {
      ProjectClassifyTabBean projectClassifyTabBean =
          ProjectClassifyTabBean.fromJson(result.data);
      projectClassifyTabBean.data.forEach((projectClassifyTabItem) {
        widgets.add(new RaisedButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return PublicArticleListPage(
                  publicId: projectClassifyTabItem.id,
                  publicName: projectClassifyTabItem.name,
                );
              }));
            },
            child: Text(
              '${projectClassifyTabItem.name}',
              style: TextStyle(color: Colors.black),
            )));
      });
      setState(() {
        _multiStatus = MultiStatus.normal;
      });
    }).catchError((error) {
      setState(() {
        _multiStatus = MultiStatus.error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiStatusPageWidget(
        multiStatus: _multiStatus,
        refreshCallback: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: widgets,
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
