import 'package:flutter/material.dart';
import 'package:wan_android_flutter/network/system_bean.dart';
import 'package:wan_android_flutter/home/system_children_item_page.dart';

class SystemChildrenPage extends StatefulWidget {
  final List<ChildrenBean> childrenBean;

  SystemChildrenPage({this.childrenBean});

  @override
  State<StatefulWidget> createState() => _SystemChildrenPageState();
}

class _SystemChildrenPageState extends State<SystemChildrenPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController =
        new TabController(length: widget.childrenBean.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('体系数据'),
        bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: widget.childrenBean.map((childrenBean) {
              return Tab(
                child: Text(childrenBean.name),
              );
            }).toList()),
      ),
      body: TabBarView(
        children: widget.childrenBean.map((childrenBean) {
          return SystemChildrenItemPage(
            projectTabId: childrenBean.id,
            projectTabName: childrenBean.name,
          );
        }).toList(),
        controller: _tabController,
      ),
    );
  }
}
