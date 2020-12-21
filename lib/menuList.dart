import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:qrmenu/constants/index.dart';
import 'menuPage.dart';
import 'models/db.dart';
import 'models/menu.dart';

MyDB myDB = new MyDB();

class MenuList extends StatefulWidget {
  @override
  MenuListState createState() => MenuListState();
}

class MenuListState extends State<MenuList> {
  List<Menu> menus = new List<Menu>();

  loadMenu() async {
    final listMenu = await myDB.menus();
    setState(() {
      menus = listMenu;
    });
  }

  @override
  void initState() {
    super.initState();
    myDB.create().then((value) => loadMenu());
  }

  Widget noItem(int count) {
    if (count == 0) {
      return Center(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 100),
              child: Column(children: [
                Text(
                  "No hay menus guardados",
                  style: TextStyle(fontSize: 16),
                ),
              ])));
    } else
      return Padding(padding: EdgeInsets.all(0));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Container(
          alignment: Alignment.center,
          child: Image.asset(
            "assets/images/logo.png",
            scale: 2,
          ),
        ),
        ...menus.map((menu) {
          return Container(
              child: Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('$menu eliminado'),
                      action: SnackBarAction(
                        label: "DESHACER",
                        onPressed: () {
                          myDB.insertMenu(menu).then((value) => loadMenu());
                        },
                      ),
                    ));

                    myDB.deleteMenu(menu.name).then((value) => loadMenu());
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Container(
                    decoration: boxDecoration,
                    child: ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuPage(menu.name))),
                      leading: CircleAvatar(
                        backgroundColor: colors[
                            letras.indexOf(menu.descripcion.toLowerCase()[0])],
                        child: Text(
                          menu.descripcion[0],
                          style: TextStyle(fontSize: 20),
                        ),
                        radius: 25,
                      ),
                      title: Text(
                        menu.descripcion,
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Row(
                        children: [
                          ratingBarReadOnly(menu.valoration, size: 15)
                        ],
                      ),
                      trailing: GestureDetector(
                          onTap: () {
                            FlutterShare.share(
                                title: menu.descripcion,
                                text: menu.descripcion,
                                linkUrl:
                                    'https://qrmenuapp.azurewebsites.net/home/privacy?name=' +
                                        menu.name,
                                chooserTitle: menu.descripcion);
                          },
                          child: Icon(Icons.share)),
                    ),
                  )));
        }).toList(),
        noItem(menus.length)
      ],
    )));
  }
}
