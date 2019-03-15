//项目

import 'package:flutter/material.dart';

class Project extends StatefulWidget {
  @override
  _ProjectState createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          '项目',
          textScaleFactor: 5,
        ),
      ),
    );
  }
}
