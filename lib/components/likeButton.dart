import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

Widget likeButton(bool isLiked, int likeCount, IconData icon, Function fuct) {
  return LikeButton(
    circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
    bubblesColor: BubblesColor(
      dotPrimaryColor: Color(0xff33b5e5),
      dotSecondaryColor: Colors.blue[300],
    ),
    likeBuilder: (isLiked) {
      return Icon(
        icon,
        color: isLiked ? Colors.blue : Colors.grey,
        size: 20,
      );
    },
    isLiked: isLiked,
    size: 20,
    likeCount: likeCount,
    onTap: fuct,
  );
}
