import 'item.dart';

class Menu {
  final String name;
  final String descripcion;
  final String date;

  Menu({this.name, this.date, this.descripcion});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'descripcion': descripcion,
      'date':
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    };
  }
}

class MenuWithItems {
  final String name;
  final String descripcion;
  final List<Item> items;

  MenuWithItems({this.name, this.descripcion, this.items});

  factory MenuWithItems.fromJson(Map<String, dynamic> json) {
    final _items = json['items'].cast<Map<String, dynamic>>();
    return MenuWithItems(
        name: json['name'],
        descripcion: json['descripcionName'],
        items: new List<Item>.from(
            _items.map((itemsJson) => Item.fromJson(itemsJson))));
  }
}
