import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('newsapp.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final pathToDB = join(dbPath, path);

    return await openDatabase(
      pathToDB,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            url TEXT UNIQUE,
            imageUrl TEXT
          )
        ''');
      },
    );
  }

  // Insert a new favorite
  Future<int> insertFavorite(Map<String, dynamic> favorite) async {
    final db = await instance.database;
    return await db.insert('favorites', favorite, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all favorites
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await instance.database;
    return await db.query('favorites');
  }

  // Delete a favorite
  Future<int> deleteFavorite(int id) async {
    final db = await instance.database;
    return await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  // Check if an item is already a favorite
  Future<bool> isFavorite(String url) async {
    final db = await instance.database;
    final result = await db.query(
      'favorites',
      where: 'url = ?',
      whereArgs: [url],
    );
    return result.isNotEmpty;
  }
}
