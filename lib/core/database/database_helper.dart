import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String databaseName = 'nota.db';
  static const int databaseVersion = 2;
  static const String tableItems = 'items';

  // Columns
  static const String columnId = 'id';
  static const String columnType = 'type';
  static const String columnContent = 'content';
  static const String columnTitle = 'title';
  static const String columnImageUrl = 'imageUrl';
  static const String columnTags = 'tags';
  static const String columnCategory = 'category';
  static const String columnCreatedAt = 'createdAt';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);

    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableItems (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnType TEXT NOT NULL,
        $columnContent TEXT NOT NULL,
        $columnTitle TEXT,
        $columnImageUrl TEXT,
        $columnTags TEXT,
        $columnCategory TEXT DEFAULT 'أخرى',
        $columnCreatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $tableItems ADD COLUMN $columnCategory TEXT DEFAULT "أخرى"');
    }
  }

  Future<int> insertItem(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(tableItems, row);
  }

  Future<List<Map<String, dynamic>>> queryAllItems() async {
    final db = await database;
    return await db.query(tableItems, orderBy: '$columnCreatedAt DESC');
  }

  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    final db = await database;
    return await db.query(
      tableItems,
      where: '$columnContent LIKE ? OR $columnTitle LIKE ? OR $columnTags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: '$columnCreatedAt DESC',
    );
  }

  Future<void> updateItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.update(
      tableItems,
      item,
      where: '$columnId = ?',
      whereArgs: [item[columnId]],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(
      tableItems,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
