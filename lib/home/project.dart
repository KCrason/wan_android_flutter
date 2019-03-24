//项目

import 'package:flutter/material.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:wan_android_flutter/network/project_classfiy_tab_bean.dart';
import 'package:wan_android_flutter/home/project_classify_item_page.dart';

class Project extends StatefulWidget {
  @override
  _ProjectState createState() => _ProjectState();
}

class _ProjectState extends State<Project>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  //final tabs = ['完整项目', '跨平台应用', '资源聚合类', '动画', 'RV列表动效', '项目基础功能'];

  PageController _pageController;
  int _currentIndex = 0;

  List<ProjectClassifyTabItem> _tabs;

  bool isLoadDataComplete = false;

  List<ProjectClassifyItemPage> _classifyItemPages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = new PageController(initialPage: 0);
    ApiRequest.getProjectClassifyTabData((ProjectClassifyTabBean projectClassifyTabBean) {
      isLoadDataComplete = true;
      _classifyItemPages = List.generate(projectClassifyTabBean.data.length, (index) {
        ProjectClassifyTabItem projectClassifyTabItem = projectClassifyTabBean.data[index];
        return ProjectClassifyItemPage(
          projectTabName: projectClassifyTabItem.name,
          projectTabId: projectClassifyTabItem.id,
        );
      });
      setState(() {
        _tabs = projectClassifyTabBean.data;
      });
    });
  }

  List<Widget> _createTabItems() {
    return new List<Widget>.generate(_tabs.length, (index) {
      ProjectClassifyTabItem projectClassifyTabItem = _tabs[index];
      return Padding(
        padding: EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
        child: RaisedButton(
          elevation: 0,
          color: _currentIndex == index
              ? Theme.of(context).primaryColor
              : Colors.grey,
          textColor: Colors.white,
          onPressed: () {
            _pageController.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          child: Text(projectClassifyTabItem.name),
        ),
      );
    });
  }

  Widget _getBodyWidget() {
    if (isLoadDataComplete) {
      return _buildPageView();
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _buildPageView() {
    return Column(
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _createTabItems(),
          ),
        ),
        Expanded(
            flex: 1,
            child: PageView.builder(
                itemCount: _tabs.length,
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _classifyItemPages[index];
                }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBodyWidget(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
