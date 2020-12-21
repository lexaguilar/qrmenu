import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:smart_flare/actors/smart_flare_actor.dart';

import 'constants/index.dart';
import 'menuPage.dart';

class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  @override
  void initState() {
    super.initState();
  }

  String resultScan;
  Future scanCode() async {
    resultScan = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancelar", true, ScanMode.QR);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MenuPage(
                resultScan == cancelar ? 'eH9bIOD3Jc4=' : resultScan)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [Colors.white, Colors.grey[100]],
                begin: const FractionalOffset(1.0, 1.0),
                end: const FractionalOffset(0.2, 0.2),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Center(
              child: Column(children: <Widget>[
            SizedBox(height: 30),
            Container(
              child: Image.asset(
                "assets/images/logo.png",
                scale: 2,
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(200)),
                  border: Border.all(width: 2, color: AppColors.mainColor),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.lightBlueShadow,
                        blurRadius: 10,
                        offset: Offset(5, 5),
                        spreadRadius: 3),
                    BoxShadow(
                        color: Colors.white38,
                        blurRadius: 5,
                        offset: Offset(-5, -5),
                        spreadRadius: 3)
                  ],
                  gradient: RadialGradient(colors: [
                    AppColors.mainColor,
                    AppColors.mainColor,
                    AppColors.mainColor,
                    Colors.white
                  ])),
              child: IconButton(
                onPressed: scanCode,
                iconSize: 150.0,
                icon: SmartFlareActor(
                    width: 400.0,
                    height: 400.0,
                    startingAnimation: 'init',
                    filename: 'assets/flare/loading.flr'),
              ),
            ),
            // Container(
            //   width: 200,
            //   height: 200,
            //   child: MaterialButton(
            //       color: Colors.white,
            //       hoverColor: Colors.blueGrey,
            //       elevation: 25,
            //       height: 100,
            //       minWidth: 100,
            //       onPressed: scanCode,
            //       textColor: Colors.white,
            //       child: SmartFlareActor(
            //           width: 400.0,
            //           height: 400.0,
            //           startingAnimation: 'init',
            //           filename: 'assets/flare/loading.flr'),
            //       padding: EdgeInsets.all(16),
            //       shape: CircleBorder(
            //           side: BorderSide(
            //               width: 2.5,
            //               style: BorderStyle.solid,
            //               color: Color(primaryColor)))),
            // ),
            SizedBox(height: 50),
            Text(
              "Presione para scanear",
              style: TextStyle(
                  fontSize: 20,
                  color: Color(primaryColor),
                  fontFamily: 'Tenor Sans - 400'),
            ),
          ]))),
    );
  }
}
