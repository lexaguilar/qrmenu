import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrmenu/models/item.dart';
import 'package:rating_bar/rating_bar.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/index.dart';

class ItemDetail extends StatefulWidget {
  final item;
  ItemDetail(this.item);

  @override
  ItemDetailState createState() => ItemDetailState(item);
}

class ItemDetailState extends State<ItemDetail> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Item item;
  bool isLoading = true;
  String valoration = valorationString[0];
  ItemDetailState(this.item);
  double initialRating = 0.0;

  @override
  void initState() {
    super.initState();
    getValoration();
  }

  Future<void> getValoration() async {
    var pre = await _prefs;
    var token = (pre.getString(keyToken) ?? "");
    final response = await http.get(
      '${pathUrl}devices/menu/items/${item.id}/feedback',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: '$token',
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = ValorationItem.fromJson(json.decode(response.body));
      var newValoration = valorationString[jsonResponse.myValoration];
      setState(() {
        valoration = newValoration;
        initialRating = jsonResponse.valoration;
        isLoading = false;
      });
    }
  }

  void setValoration(double rating) {
    var ratingInt = int.parse(rating.toString().replaceAll(".0", ""));
    var newValoration = valorationString[ratingInt];
    setState(() {
      valoration = newValoration;
    });
  }

  Future<double> saveRating(double rating) async {
    var pre = await _prefs;
    var token = (pre.getString(keyToken) ?? "");
    var ratingInt = int.parse(rating.toString().replaceAll(".0", ""));
    http.post('${pathUrl}devices/menu/items/${item.id}/feedback',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: '$token',
        },
        body: jsonEncode(<String, int>{
          'Feedback': ratingInt,
          'Like': 0,
        }));

    return rating;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        body: Center(
            child: Column(
      children: <Widget>[
        SizedBox(height: 30),
        Container(
          child: Image.asset(
            "assets/images/logo.png",
            scale: 2,
          ),
        ),
        SizedBox(height: 150),
        Container(child: circleAvatar(item, 80, fontSize: 30)),
        Text(
          item.title,
          style: TextStyle(fontSize: 22),
        ),
        ratingBarReadOnly(item.valoration, size: 18),
        SizedBox(height: 20),
        Container(
            width: 250,
            child: Text(
              descriptionComponse(item),
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            )),
        SizedBox(height: 20),
        Text(
          "${item.money} ${item.price.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        price(item),
        isLoading
            ? Text('Cargando...')
            : RatingBar(
                filledColor: Colors.yellow[700],
                initialRating: initialRating,
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                size: 30,
                isHalfAllowed: true,
                halfFilledIcon: Icons.star_half,
                halfFilledColor: Colors.yellow[700],
                onRatingChanged: (rating) {
                  setValoration(rating);

                  saveRating(rating);
                },
              ),
        SizedBox(height: 20),
        Text(
          "$valoration",
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    )));
  }
}
