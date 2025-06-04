import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  ///private constructor
  DBHelper._();

  static DBHelper getInstance() {
    return DBHelper._();
  }

  ///todos
  ///todo
  ///id
  ///title
  ///desc
  ///time
  ///priority(H<M<L)
  ///isCompleted (0,1)

  Database? db;
  String tableName = "note";
  static final String columnNoteId = "note_id";
  static final String columnNoteTitle = "note_title";
  static final String columnNoteDesc = "note_desc";
  static final String columnNoteCreatedAt = "created_at";

  Future<Database> initDB() async {
    if (db == null) {
      db = await openDB();
      return db!;
    } else {
      return db!;
    }
  }

  Future<Database> openDB() async {
    Directory mDir = await getApplicationDocumentsDirectory();
    String mPath = join(mDir.path, "notes.db");
    return await openDatabase(mPath, version: 1, onCreate: (db, version) {
      ///create all the tables here
      db.execute(
          "create table $tableName ( $columnNoteId integer primary key autoincrement, $columnNoteTitle text, $columnNoteDesc text, $columnNoteCreatedAt text)");
    });
  }

  ///events (queries)
  Future<bool> addNote({required String title, required String desc}) async {
    var db = await initDB();

    int rowsEffected = await db.insert(tableName, {
      columnNoteTitle: title,
      columnNoteDesc: desc,
      columnNoteCreatedAt: DateTime.now().millisecondsSinceEpoch.toString(),
    });

    return rowsEffected > 0;
  }

  ///fetch all notes
  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    var db = await initDB();

    List<Map<String, dynamic>> allData = await db.query(tableName);

    return allData;
  }

  ///update note
  Future<bool> updateNote({required String title, required String desc, required int id}) async{

    var db = await initDB();
    int rowsEffected = await db.update(tableName, {
      columnNoteTitle: title,
      columnNoteDesc: desc,
    }, where: "$columnNoteId = $id");

    return rowsEffected>0;
  }

  ///delete note
  Future<bool> deleteNote({required int id}) async{
    var db = await initDB();
    int rowsEffected = await db.delete(tableName, where: "$columnNoteId = ?", whereArgs: ["$id"]);
    return rowsEffected>0;
  }
}
