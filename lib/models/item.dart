import 'package:flutter/material.dart';
import 'package:qrmenu/constants/index.dart';

class Item {
  final String categoria;
  final String title;
  final int price;
  final bool isSuggestion;
  final ImageProvider image;
  bool hasImage;

  Item({this.categoria, this.title, this.price, this.image, this.isSuggestion});

  factory Item.fromJson(Map<String, dynamic> json) {
    ImageProvider getImage(String path, String categoria) {
      if (path == null) {
        if (imageDefault.contains(categoria))
          return new AssetImage("assets/images/$categoria.png");
        else
          return new AssetImage("assets/images/default.png");
      }

      return new NetworkImage(path);
    }

    var item = Item(
        categoria: json['categoria'],
        title: json['title'],
        price: json['price'],
        image: getImage(json['urlImagen'], json['categoria']),
        isSuggestion: json['isSuggestion']);

    item.hasImage =
        json['urlImagen'] != null || imageDefault.contains(json['categoria']);

    return item;
  }
}
