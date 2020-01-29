import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recommed_places/core/models/places.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DbProvider {
  Database _db;
  static const String dbName = 'place11.db';
  static const String placeTable = 'Places';
  static const String userTable = "users";

  DbProvider() {
    _init();
  }

  Future<void> _init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, dbName);
    _db = await openDatabase(
      path,
      version: 3,
      onCreate: (Database newDb, int version) {
        final Batch batch = newDb.batch();

        batch.execute("""
          CREATE TABLE $placeTable (
            id TEXT PRIMARY KEY,
            title TEXT,
            address TEXT,
            imagePath TEXT,
            latitude REAL,
            longitude REAL,
            isSynced INTEGER,
            serverImagePath TEXT
          )
          """);

        batch.execute("""
         CREATE TABLE IF NOT EXISTS $userTable(
           id INTEGER PRIMARY KEY,
           name TEXT,
           username TEXT )
        """);

        batch.commit();
      },
      onUpgrade: _onDbUpgrade,
    );
  }

  Future<Place> getPlaceById(String id) async {
    final data = await _db.query(placeTable, where: "id = ?", whereArgs: [id]);
    if (data.length > 0) {
      return Place.fromJson(data.first);
    }
    return null;

    //select * from placetable where id = id
  }

  Future<List<Place>> getAllPlaces() async {
    if (_db == null) {
      await _init();
    }
    final data = await _db.query(placeTable);
    final placeList = data.map((value) {
      return Place.fromJson(value);
    }).toList();
    return placeList;
  }

  Future<int> insertPlace(Place places) {
    return _db.insert(placeTable, places.toJson());
  }

  Future<int> wipeLocalData() {
    return _db.delete(placeTable);
  }

  void _onDbUpgrade(Database db, int oldVersion, int newVersion) {
    Batch batch = db.batch();

    for (int i = oldVersion; i < newVersion; i++) {
      getMigrationScripts()[i - 1].forEach((String script) {
        batch.execute(script);
      });
    }
    batch.commit();
  }

  List<List<String>> getMigrationScripts() {
    List<List<String>> list = [];
    List<String> one = [
      "ALTER TABLE $placeTable ADD COLUMN isSynced INTEGER DEFAULT 0",
      "ALTER TABLE $placeTable ADD COLUMN serverImagePath TEXT"
    ];

    List<String> two = [
      """CREATE TABLE IF NOT EXISTS $userTable(
      id INTEGER PRIMARY KEY,
      name TEXT,
      username TEXT
      )"""
    ];
    list.add(one);
    list.add(two);

    return list;
  }

  updatePlace(Place place, String oldId) {
    _db.update(placeTable, place.toJson(),
        where: " id = ?", whereArgs: [oldId]);
  }
}
