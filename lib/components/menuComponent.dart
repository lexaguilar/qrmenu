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
    margin: EdgeInsets.only(right: 20, bottom: 30, top: 30),
    height: 150,
    width: 200,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            item.hasImage
                ? CircleAvatar(
                    backgroundImage: item.image,
                    radius: 30,
                  )
                : CircleAvatar(
                    child: Text(item.title[0]),
                    radius: 30,
                  ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text(item.price.toString(), style: priceStyle)
          ],
        ),
        Text(
          item.title,
          style: jobCardTitileStyleBlue,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RatingBar.readOnly(
                filledColor: Colors.yellow[700],
                initialRating: 3,
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                size: 20,
              ),
              Icon(
                Icons.favorite_border,
                size: 25,
              )
            ])
      ],
    ),
  );
}
