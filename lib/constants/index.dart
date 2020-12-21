import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:qrmenu/models/item.dart';
import 'package:rating_bar/rating_bar.dart';

final cancelar = "-1";
final key = "state";
final keyToken = "keyToken";
final keyTheme = "keyTheme";
final userIdKey = "USER_ID";

//Colors
final primaryColor = 0xff27507e;
final accentColor = 0xff42c4ee;

//http
//final pathUrl = 'https://qrmenuapp.azurewebsites.net/api/menu/';
final pathUrl = 'http://qrcube.net/api/';

final responseOk = 200;
final responseNotFound = 404;

//tabs
final initialTabIndex = 1;
final labels = ["Menus", "Scan", "Config"];
final initialSelectedTab = labels[initialTabIndex];

final imageDefault = [
  "cerveza",
  "cockteles",
  "defecto",
  "fresconautal",
  "hamburguesa",
  "marisco",
  "papasfritas",
  "pizza",
  "pollofrito",
  "postre"
];

final boxDecoration =
    BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200])));

final borderRadius = BorderRadius.all(Radius.circular(10));

Color lightGreen = Color(0xFF95E08E);
Color lightBlueIsh = Color(0xFF33BBB5);
Color darkGreen = Color(0xFF00AA12);
Color backgroundColor = Color(0xFFEFEEF5);

TextStyle titleStyleWhite = new TextStyle(
    fontFamily: 'Helvetica',
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25);

TextStyle titleStyleMuted = new TextStyle(
    fontFamily: 'Helvetica',
    color: Colors.grey[200],
    fontWeight: FontWeight.bold,
    fontSize: 20);

TextStyle jobCardTitileStyleBlue = new TextStyle(
    fontFamily: 'Avenir',
    color: lightBlueIsh,
    fontWeight: FontWeight.bold,
    fontSize: 14);
TextStyle jobCardTitileStyleBlack = new TextStyle(
    fontFamily: 'Avenir',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 12);
TextStyle titileStyleLighterBlack = new TextStyle(
    fontFamily: 'Avenir',
    color: Color(0xFF34475D),
    fontWeight: FontWeight.bold,
    fontSize: 20);

TextStyle titileStyleBlack = new TextStyle(
    fontFamily: 'Helvetica',
    color: Color(primaryColor),
    fontWeight: FontWeight.bold,
    fontSize: 20);
TextStyle priceStyle = new TextStyle(
    fontFamily: 'Avenir',
    color: darkGreen,
    fontWeight: FontWeight.bold,
    fontSize: 16);

final colors = [
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.pink,
  Colors.deepPurple,
  Colors.blueGrey,
  Colors.redAccent,
  Colors.deepOrange,
  Colors.lime,
  Color(0xfff44336),
  Color(0xff9c27b0),
  Color(0xff673ab7),
  Color(0xff3f51b5),
  Color(0xff2196f3),
  Color(0xff00bcd4),
  Color(0xff009688),
  Color(0xff795548),
  Color(0xff607d8b),
  Color(0xff8bc34a),
  Color(0xffffc107),
  Color(0xff4f8511),
  Color(0xff17202a),
  Color(0xff17202a),
  Color(0xff4a235a),
  Color(0xffcb4335),
  Colors.yellow,
];

final letras = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z'
];

var valorationString = [
  "",
  "No me gusta",
  "Me gusta poco",
  "No está mal",
  "Me gusta",
  "Me encanta"
];

Future<AndroidDeviceInfo> getDeviceInfo() async {
  var deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  return androidInfo;
}

Widget circleAvatar(item, double radius, {double fontSize = 20}) {
  return item.hasImage
      ? CircleAvatar(
          backgroundImage: item.image,
          radius: radius,
        )
      : CircleAvatar(
          child: Text(item.title[0], style: TextStyle(fontSize: fontSize)),
          radius: radius,
        );
}

String descriptionComponse(Item item) {
  return item.descripcion.length == 0 ? item.categoria : item.descripcion;
}

Widget ratingBarReadOnly(double initialRating, {double size = 16}) {
  return RatingBar.readOnly(
    filledColor: Colors.yellow[700],
    initialRating: initialRating,
    filledIcon: Icons.star,
    emptyIcon: Icons.star_border,
    halfFilledIcon: Icons.star_half,
    halfFilledColor: Colors.yellow[700],
    size: size,
    isHalfAllowed: true,
  );
}

class AppColors {
  static const mainColor = Color(0XFFe5eefc);
  static const styleColor = Color(0XFF6f7e96);
  static const activeColor = Color(0XFFd0ddf3);
  static const lightBlue = Color(0XFF92aeff);
  static const darkBlue = Color(0XFF5880ff);
  static const lightBlueShadow = Color(0XAA92aeff);
}

Widget price(Item item) {
  return Text(
    "${!item.hasIva ? '+IVA' : ''}",
    style: TextStyle(fontSize: 12, color: Colors.grey),
  );
}
