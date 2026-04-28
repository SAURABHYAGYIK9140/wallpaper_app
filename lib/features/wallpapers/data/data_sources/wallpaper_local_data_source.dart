import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/wallpaper_model.dart';

abstract class WallpaperLocalDataSource {
  Future<void> addToCollection(WallpaperModel wallpaper);
  Future<void> removeFromCollection(int id);
  Future<List<WallpaperModel>> getCollection();
  Future<bool> isInCollection(int id);
}

class WallpaperLocalDataSourceImpl implements WallpaperLocalDataSource {
  static Database? _database;
  static const String tableName = 'wallpapers';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'wallpaper_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, width INTEGER, height INTEGER, url TEXT, photographer TEXT, photographer_url TEXT, photographer_id INTEGER, avg_color TEXT, liked INTEGER, alt TEXT, src TEXT)',
        );
      },
    );
  }

  @override
  Future<void> addToCollection(WallpaperModel wallpaper) async {
    final db = await database;
    await db.insert(
      tableName,
      {
        ...wallpaper.toJson(),
        'liked': wallpaper.liked ? 1 : 0,
        'src': jsonEncode(wallpaper.src),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> removeFromCollection(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<WallpaperModel>> getCollection() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return WallpaperModel(
        id: maps[i]['id'],
        width: maps[i]['width'],
        height: maps[i]['height'],
        url: maps[i]['url'],
        photographer: maps[i]['photographer'],
        photographerUrl: maps[i]['photographer_url'],
        photographerId: maps[i]['photographer_id'],
        avgColor: maps[i]['avg_color'],
        liked: maps[i]['liked'] == 1,
        alt: maps[i]['alt'],
        src: Map<String, String>.from(jsonDecode(maps[i]['src'])),
      );
    });
  }

  @override
  Future<bool> isInCollection(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}
