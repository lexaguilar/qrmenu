import 'package:flutter/material.dart';
import 'package:qrmenu/constants/index.dart';

import 'components/menuComponent.dart';
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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        //pinned: true,
        floating: false,
        expandedHeight: 120.0,
        flexibleSpace: FlexibleSpaceBar(
          background: Image(image: AssetImage('assets/images/logo2.png')),
        ),
      ),
      SliverFixedExtentList(
        itemExtent: 1,
        delegate: SliverChildListDelegate([
          Container(color: Colors.white),
          Container(color: Colors.white),
          Container(color: Colors.white),
          Container(color: Colors.white),
        ]),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            var companyName = menus[index].descripcion;
            return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  var menu = menus[index];
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
                //child: getCompany(context, menus[index])
                child: Container(
                  decoration: boxDecoration,
                  child: ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MenuPage(menus[index].name))),
                      leading: CircleAvatar(
                        backgroundColor: colors[
                            letras.indexOf(companyName.toLowerCase()[0])],
                        child: Text(companyName[0]),
                        radius: 25,
                      ),
                      title: Text(
                        menus[index].descripcion,
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(menus[index].date),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blueAccent,
                      )),
                ));
          },
          childCount: menus.length,
        ),
      ),
    ]);
    // return Scaffold(
    //   body: Container(
    //     child: menus == null || menus.length == 0
    //         ? Center(
    //             child: Text(
    //             "There is no menu yet",
    //             style: TextStyle(fontSize: 16),
    //           ))
    //         : RefreshIndicator(
    //             key: refreshKey,
    //             onRefresh: () async {
    //               await myDB.menus();
    //             },
    //             child: ListView.builder(
    //               padding: EdgeInsets.all(20.0),
    //               itemCount: menus.length,
    //               itemBuilder: (context, index) {
    //                 return Dismissible(
    //                     key: UniqueKey(),
    //                     onDismissed: (direction) {
    //                       var menu = menus[index];
    //                       Scaffold.of(context).showSnackBar(SnackBar(
    //                         content: Text('$menu eliminado'),
    //                         action: SnackBarAction(
    //                           label: "DESHACER",
    //                           onPressed: () {
    //                             myDB
    //                                 .insertMenu(menu)
    //                                 .then((value) => loadMenu());
    //                           },
    //                         ),
    //                       ));

    //                       myDB
    //                           .deleteMenu(menu.name)
    //                           .then((value) => loadMenu());
    //                     },
    //                     background: Container(
    //                       alignment: Alignment.centerRight,
    //                       padding: EdgeInsets.only(right: 20.0),
    //                       color: Colors.red,
    //                       child: const Icon(
    //                         Icons.delete,
    //                         color: Colors.white,
    //                       ),
    //                     ),
    //                     child: Card(
    //                       elevation: 3,
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(15.0),
    //                       ),
    //                       child: ListTile(
    //                           onTap: () => Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       MenuPage(menus[index].name))),
    //                           leading: Icon(
    //                             Icons.home,
    //                             size: 40,
    //                           ),
    //                           title: Text(
    //                             menus[index].descripcion,
    //                             style: TextStyle(fontSize: 18),
    //                           ),
    //                           subtitle: Text(menus[index].date),
    //                           trailing: Icon(
    //                             Icons.arrow_forward_ios,
    //                             color: Colors.blueAccent,
    //                           )),
    //                     ));
    //               },
    //             ),
    //           ),
    //   ),
    // );
  }
}
