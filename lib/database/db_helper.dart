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
      version: 1,
      onCreate: (db, version) async {
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

        // await db.execute('''
        //   CREATE TABLE notes (
        //     id INTEGER PRIMARY KEY AUTOINCREMENT,
        //     text TEXT NOT NULL UNIQUE
        //   );
        // ''');

        // initial wallet
        await db.insert('wallet', {
          'balance': 0,
          'currency': 'BDT',
          'updated_at': DateTime.now().toIso8601String()
        });
      },
    );
  }
}
