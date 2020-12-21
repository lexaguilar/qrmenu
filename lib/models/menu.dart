import 'item.dart';

class Menu {
  final String name;
  final String descripcion;
  final double valoration;

  Menu({this.name, this.descripcion, this.valoration});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'descripcion': descripcion,
      'valoration': valoration,
    };
  }
}

class MenuWithItems {
  final String categoryId;
  final String categoryName;
  final List<Item> items;

  MenuWithItems({this.categoryId, this.categoryName, this.items});

  factory MenuWithItems.fromJson(Map<String, dynamic> json, String token) {
    final _items = json['menuItems'].cast<Map<String, dynamic>>();

    return MenuWithItems(
        categoryId: json['categoryId'],
        categoryName: json['categoryName'],
        items: new List<Item>.from(
            _items.map((itemsJson) => Item.fromJson(itemsJson, token))));
  }
}

class Auth {
  final String companyName;
  final String branchName;
  final String jwtToken;

  Auth({this.companyName, this.branchName, this.jwtToken});

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
        companyName: json['companyName'],
        branchName: json['branchName'],
        jwtToken: json['jwtToken']);
  }
}
