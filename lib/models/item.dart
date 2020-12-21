import 'package:flutter/material.dart';
import 'package:qrmenu/constants/index.dart';

class Item {
  final int id;
  final String categoria;
  final String title;
  final double price;
  final bool isSuggestion;
  final bool hasIva;
  final ImageProvider image;
  final String money;
  final String descripcion;
  bool hasImage;
  final bool isLiked;
  final int likeCount;
  final double valoration;

  Item({
    this.id,
    this.categoria,
    this.title,
    this.price,
    this.image,
    this.money,
    this.isSuggestion,
    this.hasIva,
    this.descripcion,
    this.isLiked,
    this.likeCount,
    this.valoration,
  });

  factory Item.fromJson(Map<String, dynamic> json, String token) {
    ImageProvider getImage(String path, String categoria) {
      if (path == null) {
        if (imageDefault.contains(categoria))
          return new AssetImage("assets/images/$categoria.png");
        else
          return new AssetImage("assets/images/default.png");
      }

      return new NetworkImage(path, headers: {"authorization": token});
    }

    double price = json['price'];
    double feedback = 0.0;
    if (json['feedback'] != null) feedback = checkDouble(json['feedback']);

    var item = Item(
      id: json['itemId'],
      categoria: json['categoryName'],
      title: json['name'],
      price: price,
      money: json['currency'],
      descripcion: json['description'] ?? '',
      image: getImage(json['imgSrc'], json['categoryName']),
      isSuggestion: json['isSuggestion'],
      hasIva: json['taxIncluded'],
      isLiked: json['likeLeft'],
      likeCount: json['likeUp'],
      valoration: feedback,
    );

    item.hasImage =
        json['imgSrc'] != null || imageDefault.contains(json['categoria']);

    return item;
  }
}

double checkDouble(dynamic value) {
  if (value is String) {
    return double.parse(value);
  } else {
    return value.toDouble();
  }
}

class ValorationItem {
  final double valoration;
  final int myValoration;
  final int like;

  ValorationItem({this.valoration, this.myValoration, this.like});

  factory ValorationItem.fromJson(Map<String, dynamic> json) {
    double valoration = json['feedback'].toDouble();
    return ValorationItem(
      valoration: valoration,
      myValoration: json['userFeedback'],
      like: json['like'],
    );
  }
}
