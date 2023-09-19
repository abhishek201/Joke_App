//This class is used to manage database operations on the app
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:joke_app/model/joke.dart';

class AppDatabase {
  static final AppDatabase _singleton = AppDatabase._internal();

  factory AppDatabase() {
    return _singleton;
  }

  AppDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'jokes_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jokes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT
      )
    ''');
  }
  //this function is used to insert joke into database
  Future<void> insertJoke(Joke joke) async {
    final db = await database;
    await db.insert('jokes', joke.toMap());
  }
  //this function is used to get all the joke from database
  Future<List<Joke>> getAllJokes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('jokes', orderBy: 'id DESC');
    return List.generate(maps.length, (i) {
      return Joke(
        id: maps[i]['id'],
        text: maps[i]['text'],
      );
    });
  }
  //this function is used to delete joke from database
  Future<void> deleteOldJokes(int maxCount) async {
    final db = await database;
    final oldestId = (await db.query('jokes', columns: ['id'], orderBy: 'id ASC', limit: 1))[0]['id'];
    if (oldestId != null) {
      int id = oldestId as int;
      await db.delete('jokes', where: 'id <= ?', whereArgs: [id - maxCount]);
    }
  }
}
