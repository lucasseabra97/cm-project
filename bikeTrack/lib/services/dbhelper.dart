import 'dart:io';
import 'package:bikeTrack/services/photo.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelperImages extends ChangeNotifier {
  static final _databaseName = "photos.db";
  static const String ID = 'id';
  static const String NAME = 'photoName';
  static const String TABLE = 'PhotosTable';

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  DatabaseHelperImages._privateConstructor();
  static final DatabaseHelperImages instance =
      DatabaseHelperImages._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, $NAME TEXT)');
  }

  Future<Photo> save(Photo photo) async {
    Database db = await database;
    photo.id = await db.insert(TABLE, photo.toMap());
    return photo;
  }

  Future<List<Photo>> getPhotos() async {
    Database db = await database;
    List<Map> maps = await db.query(TABLE, columns: [ID, NAME]);
    List<Photo> photos = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        photos.add(Photo.fromMap(maps[i]));
      }
    }
    return photos;
  }

  Future close() async {
    Database db = await database;
    db.close();
  }
}
