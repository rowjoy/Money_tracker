import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'wallet.db');

    return openDatabase(
      path,
      version: 2, // ✅ bump version
      onCreate: (db, version) async {
        await _createAllTables(db);
        await _insertInitialWallet(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // ✅ upgrade step-by-step (safe)
        if (oldVersion < 2) {
          await db.execute(''' 
            CREATE TABLE IF NOT EXISTS daily_bazaar(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              bazaar_name TEXT NOT NULL,
              amount REAL NOT NULL,
              note TEXT,
              receipt_no TEXT NOT NULL,
              created_at TEXT NOT NULL
            );
          ''');

          await db.execute(''' 
            CREATE TABLE IF NOT EXISTS bazaar_suggestions(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL UNIQUE,
              last_used_at TEXT NOT NULL
            );
          ''');

          await db.execute(''' 
            CREATE TABLE IF NOT EXISTS app_settings(
              key TEXT PRIMARY KEY,
              value TEXT
            );
          ''');
        }
      },
    );
  }

  static Future<void> _createAllTables(Database db) async {
    await db.execute('''
      CREATE TABLE wallet (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        balance REAL NOT NULL,
        currency TEXT DEFAULT 'BDT',
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        amount REAL,
        note TEXT,
        status TEXT,
        created_at TEXT
      )
    ''');

    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS daily_bazaar(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bazaar_name TEXT NOT NULL,
        amount REAL NOT NULL,
        note TEXT,
        receipt_no TEXT NOT NULL,
        created_at TEXT NOT NULL
      );
    ''');

    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS bazaar_suggestions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        last_used_at TEXT NOT NULL
      );
    ''');

    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS app_settings(
        key TEXT PRIMARY KEY,
        value TEXT
      );
    ''');
  }

  static Future<void> _insertInitialWallet(Database db) async {
    await db.insert('wallet', {
      'balance': 0,
      'currency': 'BDT',
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}

