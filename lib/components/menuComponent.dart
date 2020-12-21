import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrmenu/constants/index.dart';
import 'package:qrmenu/models/item.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../itemDetail.dart';
import 'likeButton.dart';

List<Widget> getSuggestions(List<Item> items) {
  return items.map((item) => getSuggestion(item)).toList();
}

Future<bool> onLikeButtonTapped(bool isLiked, int itemId) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var pre = await _prefs;
  var token = (pre.getString(keyToken) ?? "");

  http.post('${pathUrl}devices/menu/items/$itemId/feedback',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: '$token',
      },
      body: jsonEncode(<String, int>{
        'Feedback': 0,
        'Like': isLiked ? 0 : 1,
      }));

  return !isLiked;
}

Widget getSuggestion(Item item) {
  return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(
        right: 20,
        bottom: item.descripcion.length > 20 ? 5 : 30,
      ),
      width: item.descripcion.length > 20 ? 240 : 210,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              blurRadius: 4.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                circleAvatar(item, 30),
                Padding(padding: EdgeInsets.only(left: 5)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: item.title.length > 16 ||
                                item.descripcion.length > 20
                            ? 150
                            : 100,
                        child: Text(item.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: jobCardTitileStyleBlue)),
                    Row(
                      children: [
                        Text(
                          '${item.money} ${item.price.toStringAsFixed(2)}',
                          style: new TextStyle(
                              fontFamily: 'Avenir',
                              color: darkGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        price(item),
                      ],
                    )
                  ],
                ),
              ]),
          Row(
            children: [
              Container(
                width: item.descripcion.length > 20 ? 220 : 180,
                child: Text(
                  descriptionComponse(item),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: item.descripcion.length > 90 ? 13 : 14),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ratingBarReadOnly(item.valoration),
              likeButton(item.isLiked, item.likeCount, Icons.thumb_up,
                  (like) => onLikeButtonTapped(like, item.id)),
            ],
          )
        ],
      ));
}

Widget tabsMenu(String tab, Function fuc, bool active) {
  return GestureDetector(
      onTap: fuc,
      child: Container(
        padding: EdgeInsets.only(right: 15, left: 15, bottom: 10, top: 10),
        margin: EdgeInsets.only(right: 5, left: 5, bottom: 10, top: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 2,
                    color: active ? Color(primaryColor) : Colors.white))),
        child: Text(
          tab,
          style:
              TextStyle(color: active ? Color(primaryColor) : Colors.grey[700]),
        ),
      ));
}

Widget getMenu(BuildContext context, Item item) {
  return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => ItemDetail(item))),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[100]))),
        height: 70,
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4),
              height: 100,
              width: 70,
              child: circleAvatar(item, 30),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.title,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black, fontSize: 17)),
                    Text(descriptionComponse(item),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600])),
                    Row(
                      children: [
                        ratingBarReadOnly(item.valoration, size: 14),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              width: 90,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${item.money} ${item.price.toStringAsFixed(2)}",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    price(item),
                  ]),
            ),
          ],
        ),
      ));
}
