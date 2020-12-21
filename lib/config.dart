import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/index.dart';

class Config extends StatefulWidget {
  @override
  ConfigState createState() => ConfigState();
}

class ConfigState extends State<Config> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool value = true;
  String valueTheme = "Claro";
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        value = (prefs.getBool(key) ?? true);
        valueTheme = (prefs.getString(keyTheme) ?? "Claro");
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        body: Column(
      children: <Widget>[
        SizedBox(height: 30),
        Container(
          child: Image.asset(
            "assets/images/logo.png",
            scale: 2,
          ),
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 10)),
            Container(
              child: Icon(Icons.app_settings_alt,
                  color: Color(primaryColor), size: 30),
            ),
            Container(
                width: 260,
                child: Column(children: <Widget>[
                  ListTile(
                      title: Text('Guardar automáticamente'),
                      subtitle: Text(
                          'Guardar menu inmediatamente despúes de escanear el código QR')),
                ])),
            Container(
              child: Switch(
                  value: value,
                  onChanged: (bool state) async {
                    final SharedPreferences prefs = await _prefs;
                    prefs.setBool(key, state);
                    setState(() {
                      value = state;
                    });
                  }),
            ),
            Padding(padding: EdgeInsets.only(right: 10)),
          ],
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 10)),
            Container(
              child:
                  Icon(Icons.color_lens, color: Color(primaryColor), size: 30),
            ),
            Container(
                width: 260,
                child: Column(children: <Widget>[
                  ListTile(
                      title: Text('Activar tema oscuro'),
                      subtitle: Text(
                          'Seleccione un tema de colores bajos ideal para ver de noche')),
                ])),
            Container(
              child: Switch(
                  value: valueTheme == "Claro",
                  onChanged: (bool state) async {
                    final SharedPreferences prefs = await _prefs;
                    prefs.setString(keyTheme, state ? "Claro" : "Oscuro");
                    setState(() {
                      valueTheme = state ? "Claro" : "Oscuro";
                    });
                  }),
            ),
            Padding(padding: EdgeInsets.only(right: 10)),
          ],
        ),
      ],
    ));
  }
}
