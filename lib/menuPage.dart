import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'components/loadingPage.dart';
import 'components/menuComponent.dart';
import 'constants/index.dart';
import 'models/db.dart';
import 'models/item.dart';
import 'models/menu.dart';

MyDB myDB = new MyDB();

class MenuPage extends StatefulWidget {
  final name;
  MenuPage(this.name);

  @override
  MenuState createState() => MenuState(name);
}

class MenuState extends State<MenuPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String name;
  MenuState(this.name);

  String companyName;
  List<Item> itemsMenu = new List<Item>();
  List<Item> itemsMenuSuggestions = new List<Item>();
  List<Item> currentItemsMenu = new List<Item>();

  List<String> tabs = [];
  int selectedTab = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    myDB.create().then((value) => getData(this.name));
  }

  Future getData(String name) async {
    AndroidDeviceInfo androidInfo = await getDeviceInfo();
    var url = '${pathUrl}user/authenticatedevice';

    final authRequest = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'DeviceId': androidInfo.id,
          'QrCode': name,
          'Model': androidInfo.model,
        }));

    if (authRequest.statusCode == responseOk) {
      var auth = Auth.fromJson(json.decode(authRequest.body));

      final SharedPreferences prefs = await _prefs;
      prefs.setString(keyToken, 'Bearer ${auth.jwtToken}');

      final response = await http.get('${pathUrl}devices/menu', headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${auth.jwtToken}',
      });

      if (response.statusCode == responseOk) {
        itemsMenu.clear();
        for (Map m in json.decode(response.body)) {
          itemsMenu.add(Item.fromJson(m, 'Bearer ${auth.jwtToken}'));
        }

        tabs = itemsMenu.map((e) => e.categoria).toSet().toList();

        _prefs.then((SharedPreferences prefs) {
          var saveValue = (prefs.getBool(key) ?? true);
          if (saveValue) {
            var newMenu =
                Menu(name: name, descripcion: auth.companyName, valoration: 0);

            myDB.insertMenu(newMenu);
          }
        });

        if (response.statusCode == responseNotFound) {
          return;
        }

        if (!mounted) return;

        setState(() {
          companyName = auth.companyName;
          itemsMenu = itemsMenu;
          itemsMenuSuggestions =
              itemsMenu.where((element) => element.isSuggestion).toList();
          currentItemsMenu =
              itemsMenu.where((e) => e.categoria == tabs[0]).toList();
          selectedTab = 0;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
        // backgroundColor: Color(0xff072736),
        body: isLoading
            ? ShimmerList()
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20),
                          constraints: BoxConstraints.expand(height: 180),
                          decoration: BoxDecoration(
                              gradient: new LinearGradient(
                                  colors: [
                                    Color(primaryColor),
                                    Color(accentColor)
                                  ],
                                  begin: const FractionalOffset(1.0, 1.0),
                                  end: const FractionalOffset(0.2, 0.2),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30))),
                          child: Container(
                            padding: EdgeInsets.only(top: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Sugerencias',
                                        style: titleStyleMuted,
                                      ),
                                      Text(
                                        companyName,
                                        style: titleStyleWhite,
                                      )
                                    ])
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 68),
                          constraints: BoxConstraints.expand(height: 170),
                          child: ListView(
                              padding: EdgeInsets.only(left: 40),
                              scrollDirection: Axis.horizontal,
                              children: getSuggestions(itemsMenuSuggestions)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 200),
                          padding: EdgeInsets.only(top: 20, left: 5, right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 30, left: 15),
                                child: Text(
                                  "Menú",
                                  style: titileStyleBlack,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                constraints: BoxConstraints.expand(height: 60),
                                child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: tabs.length,
                                    itemBuilder: (BuildContext context, int x) {
                                      var onTap = () {
                                        setState(() {
                                          selectedTab = x;
                                          currentItemsMenu = itemsMenu
                                              .where(
                                                  (e) => e.categoria == tabs[x])
                                              .toList();
                                        });
                                      };
                                      return tabsMenu(
                                          tabs[x], onTap, selectedTab == x);
                                    }),
                              ),
                              ...currentItemsMenu
                                  .map((e) => getMenu(context, e))
                                  .toList()
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ));
  }
}
