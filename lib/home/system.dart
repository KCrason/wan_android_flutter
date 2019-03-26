//体系
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/network/system_bean.dart';
import 'package:wan_android_flutter/network/api_request.dart';
import 'package:dio/dio.dart';
import 'package:wan_android_flutter/home/system_children_page.dart';

class System extends StatefulWidget {
  @override
  _SystemState createState() => _SystemState();
}

class _SystemState extends State<System> with AutomaticKeepAliveClientMixin {

  SystemBean _systemBean;

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
    Response response = await ApiRequest.getSystemData();
    setState(() {
      _systemBean = SystemBean.fromJson(response.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Response response = snapshot.data;
            _systemBean = SystemBean.fromJson(response.data);
            return RefreshIndicator(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return _buildItem(_systemBean.data[index]);
                  },
                  itemCount: _systemBean == null || _systemBean.data == null
                      ? 0
                      : _systemBean.data.length,
                ),
                onRefresh: _refresh);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: ApiRequest.getSystemData(),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
