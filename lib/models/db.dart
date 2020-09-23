import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'menu.dart';

class MyDB {
  Future<Database> database;
  final menuTable = "menus";
  final configTable = "config";

  Future create() async {
    WidgetsFlutterBinding.ensureInitialized();
    database = openDatabase(
      join(await getDatabasesPath(), 'menu_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS config(saveInfo INT2)",
        );

        final List<Map<String, dynamic>> config = await db.query(configTable);
        if (config.length == 0)
          await db.execute(
            "INSERT INTO config VALUES(1)",
          );

        return db.execute(
          "CREATE TABLE IF NOT EXISTS menus(name TEXT PRIMARY KEY, descripcion TEXT, date TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertMenu(Menu menu) async {
    // Get a reference to the database.
    final Database db = await database;

    await db.insert(
      menuTable,
      menu.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Menu>> menus() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The menu.
    final List<Map<String, dynamic>> maps = await db.query(menuTable);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Menu(
        name: maps[i]['name'],
        descripcion: maps[i]['descripcion'],
        date: maps[i]['date'],
      );
    });
  }

  Future<void> deleteMenu(String name) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      menuTable,
      // Use a `where` clause to delete a specific dog.
      where: "name = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [name],
    );
  }
}
