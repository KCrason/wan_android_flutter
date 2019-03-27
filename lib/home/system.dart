//体系
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/network/system_bean.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/home/system_children_page.dart';
import 'package:wan_android_flutter/widgets/multi_status_page_widget.dart';

class System extends StatefulWidget {
  @override
  _SystemState createState() => _SystemState();
}

class _SystemState extends State<System> with AutomaticKeepAliveClientMixin {
  SystemBean _systemBean;

  MultiStatus _multiStatus = MultiStatus.loading;

  _buildItem(SystemItemBean systemItemBean) {
    return Card(
      child: ListTile(
        title: Text(
          systemItemBean.name,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        subtitle: Text(
          _makeSubTitle(systemItemBean.children),
          style: TextStyle(fontSize: 14),
        ),
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return SystemChildrenPage(
              childrenBean: systemItemBean.children,
            );
          }));
        },
      ),
    );
  }

  _makeSubTitle(List<ChildrenBean> childrenBeans) {
    String subTile = '';
    childrenBeans.forEach((childrenBean) {
      subTile += '${childrenBean.name}  ';
    });
    return subTile;
  }

  Future<void> _refresh() async {
    try {
      Response response = await ApiRequest.getSystemData();
      setState(() {
        _systemBean = SystemBean.fromJson(response.data);
        _multiStatus = MultiStatus.normal;
      });
    } catch (e) {
      setState(() {
        _multiStatus = MultiStatus.error;
      });
    }
  }

  void retryRefresh() {
    setState(() {
      _multiStatus = MultiStatus.loading;
    });
    _refresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiStatusPageWidget(
        refreshCallback: retryRefresh,
        multiStatus: _multiStatus,
        child: RefreshIndicator(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _buildItem(_systemBean.data[index]);
              },
              itemCount: _systemBean == null || _systemBean.data == null
                  ? 0
                  : _systemBean.data.length,
            ),
            onRefresh: _refresh),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
