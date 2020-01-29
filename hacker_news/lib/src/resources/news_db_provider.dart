//create a database
//ability to insert some data in the database
//ability to fetch those data
import 'dart:io';

import 'package:hacker_news/src/models/news_model.dart';
import 'package:hacker_news/src/resources/provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NewsDbProvider implements Provider {
  Database db;
  final dbName = 'items1.db';

  NewsDbProvider() {
    init();
  }

  void init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);

    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
        CREATE TABLE Items(
        id INTEGER PRIMARY KEY,
        deleted INTEGER,
        type TEXT,
        by TEXT,
        time INTEGER,
        text TEXT,
        dead INTEGER,
        parent INTEGER,
        url TEXT,
        score INTEGER,
        title TEXT,
        descendants INTEGER,
        kids BLOB
        )
        """);
    });
  }

  @override
  Future<int> insertData(NewsModel model) {
    return db.insert(
      'Items',
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<NewsModel> fetchItem(int id) async {
    final data = await db.query('Items',
        columns: ['*'], where: 'id = ?', whereArgs: [id]);
    if (data.length > 0) {
      final item = data.first;
      return NewsModel.fromDb(item);
    }
    return null;
    //select * from Items where id = id
  }

  @override
  Future<List<int>> fetchTopIds() {
    return null;
  }

  @override
 Future<int> clearCache() {
   return db.delete('Items');
  }
}
