import 'dart:async';
import 'dart:io';
import 'package:todo_sqlite/model/model.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_sqlite/model/to_do_item.dart';

abstract class DB{
  static Database _db;
  static int get _version => 1;

  static Future<void> init() async{
    if(_db !=null) {return;}
    try{
      print('Fetching path');
      String _path = await getDatabasesPath() + 'toapp.db';
      print(_path);
      print('Path received and now opeaning database');
      _db = await openDatabase(_path, version:_version,);
      print('Database created');
      print(_db.toString());
      await onCreate(_db, _version);
      print('DB Created');
    }catch(ex){
      print('Unable to open database');

    }

  }
  static Future<String> getDatabasePath(String dbName) async{
    final databasePath = await getDatabasesPath();
    print(databasePath);
    final path =join(databasePath, dbName);
    print(dirname(path));
    if(await Directory(dirname(path)).exists()){
      print('Database file exists');

    }else{
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;  

    

  }
  static Future<void> onCreate(Database db, int version) async => await _db.execute('CREATE TABLE todo_items(id INTEGER PRIMARY KEY NOT NULL, task STRING, complete BOOLEAN)');

  static Future<int> insert(String table, Model model) async => await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model)async =>await _db.update(table, model.toMap(), where: 'id=?', whereArgs: [model.id]);

  static Future<List<Map<String, dynamic>>> query(String table) async =>await _db.query(table);

  static void delete(String table, TodoItem item) {}


}

