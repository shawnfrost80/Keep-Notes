import 'package:keep_notes/mode_class/Note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';


class DatabaseHelper {

  String tableName = 'Notes';
  String columName = 'name';
  String columnDate = 'date';
  String columnId = 'id';

  static DatabaseHelper _instance = DatabaseHelper.internal();
  DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'notes_db.db';
    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $tableName(id INTEGER PRIMARY KEY, $columName TEXT, $columnDate TEXT)');
    print('Database Created');
  }

  Future<int> saveNote(Note note) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableName, note.toMap());
    return result;
  }

  Future<List> getAllNote() async {
    var dbClient = await db;
    return await dbClient.rawQuery('SELECT * FROM $tableName ORDER BY $columName ASC');
  }

  Future<int> deleteNote(int id) async {
    var dbClient = await db;
    return await dbClient.delete('$tableName', where: '$columnId = ?', whereArgs: [id]);
  }

  Future<Note> getaNote(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName WHERE id  = $id');
    if (result.length == 0) return null;
    return Note.map(result.first);
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableName')
    );
  }

  Future<int> updateNote(Note note) async {
    var dbClient = await db;
    return await dbClient.update(tableName, note.toMap(), where: 'id = ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    await dbClient.close();
  }

}