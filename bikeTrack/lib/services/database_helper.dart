import 'dart:developer';
import 'dart:io';
import 'package:bikeTrack/services/track_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper extends ChangeNotifier {
  static final _databaseName = "trackInfo.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    log(documentsDirectory.toString());
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE TableTrackInfo (
                _id INTEGER PRIMARY KEY AUTOINCREMENT,
                avgSpeed DOUBLE NOT NULL,
                distance DOUBLE NOT NULL,
                initialPosLat DOUBLE NOT NULL,
                initialPosLng DOUBLE NOT NULL,
                finalPosLat DOUBLE NOT NULL,
                finalPosLng DOUBLE NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(TrackInfo location) async {
    Database db = await database;
    int id = await db.insert('TableTrackInfo', location.toMap());
    notifyListeners();
    return id;
  }

  Future<List<TrackInfo>> queryAll() async {
    Database db = await database;
    List<Map> maps = await db.query('TableTrackInfo');
    return List.generate(maps.length, (i) {
      return TrackInfo(
        id: maps[i]['_id'],
        avgSpeed: maps[i]['avgSpeed'],
        distance: maps[i]['distance'],
        initPosLat: maps[i]['initialPosLat'],
        initPosLng: maps[i]['initialPosLng'],
        fPosLat: maps[i]['finalPosLat'],
        fPosLng: maps[i]['finalPosLng'],
      );
    });
  }

  Future<TrackInfo> queryTrackInfo(int id) async {
    Database db = await database;
    List<Map> maps = await db.query('TableTrackInfo',
        columns: [
          '_id',
          'avgSpeed',
          'distance',
          'initialPosLat',
          'initialPosLng',
          'finalPosLat',
          'finalPosLng'
        ],
        where: '_id= ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return TrackInfo.fromMap(maps.first);
    }
    return null;
  }
}
