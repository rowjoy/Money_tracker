// =====================================================
// 2) REPOSITORY (SQLite)
// =====================================================
import 'package:moneytracker/database/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class BazaarRepository {
  Future<Database> get _db async => await DBHelper.database; // ✅ uses your DBHelper

  Future<void> addBazaar({
    required String bazaarName,
    required double amount,
    required String note,
  }) async {
    final db = await _db;
    final now = DateTime.now().toIso8601String();
    final receiptNo = "BZ-${DateTime.now().millisecondsSinceEpoch}";

    await db.transaction((txn) async {
      await txn.insert("daily_bazaar", {
        "bazaar_name": bazaarName.trim(),
        "amount": amount,
        "note": note.trim(),
        "receipt_no": receiptNo,
        "created_at": now,
      });

      // suggestion (no duplicates)
      await txn.insert(
        "bazaar_suggestions",
        {"name": bazaarName.trim(), "last_used_at": now},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );

      // update last used
      await txn.update(
        "bazaar_suggestions",
        {"last_used_at": now},
        where: "name = ?",
        whereArgs: [bazaarName.trim()],
      );
    });
  }

  Future<List<Map<String, dynamic>>> listByDate(DateTime date) async {
    final db = await _db;
    final start = DateTime(date.year, date.month, date.day).toIso8601String();
    final end =
        DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();

    return db.query(
      "daily_bazaar",
      where: "created_at BETWEEN ? AND ?",
      whereArgs: [start, end],
      orderBy: "created_at DESC",
    );
  }

  Future<Map<String, dynamic>?> getById(int id) async {
    final db = await _db;
    final rows = await db.query("daily_bazaar", where: "id = ?", whereArgs: [id]);
    return rows.isEmpty ? null : rows.first;
  }

  

  Future<List<String>> suggestions({String query = ""}) async {
    final db = await _db;
    final q = query.trim();

    final rows = await db.query(
      "bazaar_suggestions",
      where: q.isEmpty ? null : "name LIKE ?",
      whereArgs: q.isEmpty ? null : ["%$q%"],
      orderBy: "last_used_at DESC",
      limit: 8,
    );

    return rows.map((e) => (e["name"] as String)).toList();
  }

  Future<void> setSetting(String key, String value) async {
    final db = await _db;
    await db.insert(
      "app_settings",
      {"key": key, "value": value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await _db;
    final rows = await db.query("app_settings", where: "key = ?", whereArgs: [key]);
    if (rows.isEmpty) return null;
    return rows.first["value"] as String?;
  }
}
