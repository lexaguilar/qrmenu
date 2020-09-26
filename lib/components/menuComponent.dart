import 'package:flutter/material.dart';
import 'package:qrmenu/constants/index.dart';
import 'package:qrmenu/models/item.dart';
import 'package:rating_bar/rating_bar.dart';

List<Widget> getSuggestions(List<Item> items) {
  return items.map((item) => getSuggestion(item)).toList();
}

Widget getSuggestion(Item item) {
  return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(
        right: 20,
        bottom: item.descripcion.length > 20 ? 5 : 20,
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
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                item.hasImage
                    ? CircleAvatar(
                        backgroundImage: item.image,
                        radius: 30,
                      )
                    : CircleAvatar(
                        child: Text(item.title[0]),
                        radius: 30,
                      ),
                Padding(padding: EdgeInsets.only(left: 5)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.title, style: jobCardTitileStyleBlue),
                    Text(
                      '${item.money} ${item.price.toStringAsFixed(2)}',
                      style: new TextStyle(
                          fontFamily: 'Avenir',
                          color: darkGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
              ]),
          Row(
            children: [
              Container(
                width: item.descripcion.length > 20 ? 220 : 180,
                child: Text(
                  item.descripcion.length == 0
                      ? item.categoria
                      : item.descripcion,
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
              RatingBar.readOnly(
                filledColor: Colors.yellow[700],
                initialRating: 3,
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                size: 15,
              ),
              Icon(
                Icons.favorite_border,
                size: 25,
              )
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

Widget getMenu(Item item) {
  return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
      height: 70,
      child: ListTile(
        title: Text(item.title),
        subtitle: Text(item.categoria),
        trailing: Text(
          "${item.money} ${item.price.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: item.hasImage
            ? CircleAvatar(
                backgroundImage: item.image,
                radius: 30,
              )
            : CircleAvatar(
                child: Text(item.title[0]),
                radius: 30,
              ),
      ));
}
