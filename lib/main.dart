import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'package:qrmenu/config.dart';
import 'package:qrmenu/menuList.dart';
import 'package:qrmenu/scanner.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';
import 'constants/index.dart';
import 'menuPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
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
  //static const platform = const MethodChannel('app.channel.shared.data');
  StreamSubscription _intentDataStreamSubscription;
  String dataShared = "";
  MotionTabController _tabController;

  void navegateToMenu(String value) {
    if (value == null) return;

    var result = value.split('=')[1];
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MenuPage(result)));
  }

  @override
  void initState() {
    super.initState();
    _tabController = MotionTabController(initialIndex: 1, vsync: this);
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream()
        .listen((String value) => navegateToMenu(value), onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText()
        .then((String value) => navegateToMenu(value));
    //getSharedText();
  }

  // getSharedText() async {
  //   SystemChannels.lifecycle.setMessageHandler((message) {
  //     if (message.contains('resumed')) {
  //       _getSharedData().then((value) {
  //         if (value.isEmpty) return;
  //         print(value);
  //       });
  //     }
  //   });
  //   // var sharedData = await platform.invokeMethod("getSharedText");
  //   // if (sharedData != null) {
  //   //   setState(() {
  //   //     dataShared = sharedData;
  //   //   });
  //   // }
  // }

  // Future<Map> _getSharedData() async =>
  //     await platform.invokeMethod('getSharedData');

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.mainColor,
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
            : _tabController.index == 2
                ? Config()
                : Scanner());
  }
}
