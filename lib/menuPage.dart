import 'dart:convert';

import 'package:flutter/material.dart';
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
    var url = '$pathUrl?name=$name';
    final response = await http.get(url);
    if (response.statusCode == responseOk) {
      var jsonResponse = MenuWithItems.fromJson(json.decode(response.body));

      tabs = jsonResponse.items.map((e) => e.categoria).toSet().toList();

      _prefs.then((SharedPreferences prefs) {
        var saveValue = (prefs.getBool(key) ?? true);
        if (saveValue) {
          var newMenu = Menu(
              name: jsonResponse.name, descripcion: jsonResponse.descripcion);

          myDB.insertMenu(newMenu);
        }
      });

      if (!mounted) return;

      setState(() {
        companyName = jsonResponse.descripcion;
        itemsMenu = jsonResponse.items;
        itemsMenuSuggestions = jsonResponse.items
            .where((element) => element.isSuggestion)
            .toList();
        currentItemsMenu =
            itemsMenu.where((e) => e.categoria == tabs[0]).toList();
        selectedTab = 0;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = new ScrollController();
    return Scaffold(
        body: isLoading
            ? showLoadingPage()
            : SingleChildScrollView(
                controller: _scrollController,
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
                          margin: EdgeInsets.only(top: 60),
                          constraints: BoxConstraints.expand(height: 200),
                          child: ListView(
                              padding: EdgeInsets.only(left: 40),
                              scrollDirection: Axis.horizontal,
                              children: getSuggestions(itemsMenuSuggestions)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 200),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 40),
                                child: Text(
                                  "Menu",
                                  style: titileStyleBlack,
                                ),
                              ),
                              Container(
                                height: 530,
                                child: ListView(
                                  children: <Widget>[
                                    Container(
                                      height: 35,
                                      margin: EdgeInsets.only(top: 0),
                                      child: ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: tabs.length,
                                        itemBuilder:
                                            (BuildContext context, int x) {
                                          return GestureDetector(
                                            onTap: () {
                                              _scrollController.animateTo(
                                                250,
                                                curve: Curves.easeOut,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                              );
                                              setState(() {
                                                selectedTab = x;
                                                currentItemsMenu = itemsMenu
                                                    .where((e) =>
                                                        e.categoria == tabs[x])
                                                    .toList();
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: x ==
                                                                  selectedTab
                                                              ? Color(
                                                                  0xff42c4ee)
                                                              : Colors.white))),
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(
                                                '${tabs[x]}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: x == selectedTab
                                                        ? Color(primaryColor)
                                                        : Colors.grey),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                        height: 480,
                                        child: ListView.builder(
                                            itemCount: currentItemsMenu.length,
                                            itemBuilder: (context, index) {
                                              var item =
                                                  currentItemsMenu[index];

                                              return Container(
                                                  decoration: boxDecoration,
                                                  child: ListTile(
                                                    title: Text(item.title),
                                                    subtitle:
                                                        Text(item.categoria),
                                                    trailing: Text(
                                                      "$money ${item.price}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    leading: item.hasImage
                                                        ? CircleAvatar(
                                                            backgroundImage:
                                                                item.image,
                                                            radius: 30,
                                                          )
                                                        : CircleAvatar(
                                                            child: Text(
                                                                item.title[0]),
                                                            radius: 30,
                                                          ),
                                                  ));
                                            }))
                                  ],
                                ),
                              )
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
