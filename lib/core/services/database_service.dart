import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'millwright_toolbelt.db';
  static const int _dbVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Favorites table for fastener sizes
    await db.execute('''
      CREATE TABLE fastener_favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bolt_diameter TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL
      )
    ''');

    // Recent conversions table
    await db.execute('''
      CREATE TABLE recent_conversions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        conversion_type TEXT NOT NULL,
        input_value REAL NOT NULL,
        from_unit TEXT NOT NULL,
        to_unit TEXT NOT NULL,
        result_value REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // User preferences table
    await db.execute('''
      CREATE TABLE preferences (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  // Fastener Favorites
  static Future<void> addFastenerFavorite(String boltDiameter) async {
    final db = await database;
    await db.insert(
      'fastener_favorites',
      {
        'bolt_diameter': boltDiameter,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<void> removeFastenerFavorite(String boltDiameter) async {
    final db = await database;
    await db.delete(
      'fastener_favorites',
      where: 'bolt_diameter = ?',
      whereArgs: [boltDiameter],
    );
  }

  static Future<List<String>> getFastenerFavorites() async {
    final db = await database;
    final results = await db.query(
      'fastener_favorites',
      orderBy: 'created_at DESC',
    );
    return results.map((row) => row['bolt_diameter'] as String).toList();
  }

  static Future<bool> isFastenerFavorite(String boltDiameter) async {
    final db = await database;
    final results = await db.query(
      'fastener_favorites',
      where: 'bolt_diameter = ?',
      whereArgs: [boltDiameter],
    );
    return results.isNotEmpty;
  }

  // Recent Conversions
  static Future<void> addRecentConversion({
    required String conversionType,
    required double inputValue,
    required String fromUnit,
    required String toUnit,
    required double resultValue,
  }) async {
    final db = await database;
    await db.insert(
      'recent_conversions',
      {
        'conversion_type': conversionType,
        'input_value': inputValue,
        'from_unit': fromUnit,
        'to_unit': toUnit,
        'result_value': resultValue,
        'created_at': DateTime.now().toIso8601String(),
      },
    );

    // Keep only last 50 conversions
    await db.execute('''
      DELETE FROM recent_conversions
      WHERE id NOT IN (
        SELECT id FROM recent_conversions
        ORDER BY created_at DESC
        LIMIT 50
      )
    ''');
  }

  static Future<List<Map<String, dynamic>>> getRecentConversions({
    String? conversionType,
    int limit = 10,
  }) async {
    final db = await database;
    String? where;
    List<dynamic>? whereArgs;

    if (conversionType != null) {
      where = 'conversion_type = ?';
      whereArgs = [conversionType];
    }

    return await db.query(
      'recent_conversions',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
      limit: limit,
    );
  }

  static Future<void> clearRecentConversions() async {
    final db = await database;
    await db.delete('recent_conversions');
  }

  // User Preferences
  static Future<void> setPreference(String key, String value) async {
    final db = await database;
    await db.insert(
      'preferences',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String?> getPreference(String key) async {
    final db = await database;
    final results = await db.query(
      'preferences',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (results.isEmpty) return null;
    return results.first['value'] as String;
  }

  static Future<void> deletePreference(String key) async {
    final db = await database;
    await db.delete(
      'preferences',
      where: 'key = ?',
      whereArgs: [key],
    );
  }
}

// Preference keys
class PreferenceKeys {
  static const String defaultHexType = 'default_hex_type';
  static const String defaultLengthFromUnit = 'default_length_from_unit';
  static const String defaultLengthToUnit = 'default_length_to_unit';
  static const String defaultTorqueFromUnit = 'default_torque_from_unit';
  static const String defaultTorqueToUnit = 'default_torque_to_unit';
  static const String defaultBoltGrade = 'default_bolt_grade';
}
