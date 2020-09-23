import 'package:flutter/material.dart';
import 'package:smart_flare/smart_flare.dart';

Widget showLoadingPage() {
  return Container(
    child: Center(
      child: SmartFlareActor(
          width: 150.0,
          height: 150.0,
          startingAnimation: 'init',
          filename: 'assets/flare/loading.flr'),
    ),
  );
}
