import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'package:qrmenu/config.dart';
import 'package:qrmenu/menuList.dart';
import 'package:qrmenu/scanner.dart';

import 'constants/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qr Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  MotionTabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = MotionTabController(initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: MotionTabBar(
          labels: labels,
          initialSelectedTab: initialSelectedTab,
          tabIconColor: Color(accentColor),
          tabSelectedColor: Color(primaryColor),
          onTabItemSelected: (int value) {
            setState(() {
              _tabController.index = value;
            });
          },
          icons: [
            Icons.playlist_add_check,
            Icons.crop_free,
            Icons.account_circle
          ],
          textStyle: TextStyle(color: Color(primaryColor)),
        ),
        body: _tabController.index == 0
            ? MenuList()
            : _tabController.index == 2 ? Config() : Scanner());
  }
}
