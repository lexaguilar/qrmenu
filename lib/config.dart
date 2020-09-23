import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/index.dart';

class Config extends StatefulWidget {
  @override
  ConfigState createState() => ConfigState();
}

class ConfigState extends State<Config> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool value = true;
  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        value = (prefs.getBool(key) ?? true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Container(
              child: Icon(Icons.save, color: Color(primaryColor)),
            ),
            Container(
              child: Text(
                "Save automatically menu:",
                style: TextStyle(fontSize: 18),
              ),
            ),
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
            )
          ],
        ),
      ],
    ));
  }
}
