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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Response response = snapshot.data;
            SystemBean systemBean = SystemBean.fromJson(response.data);
            return ListView.builder(
              itemBuilder: (context, index) {
                return _buildItem(systemBean.data[index]);
              },
              itemCount: systemBean.data.length,
            );
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
