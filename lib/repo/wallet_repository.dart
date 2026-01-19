import 'package:moneytracker/database/db_helper.dart';

import '../models/transction_model.dart';

class WalletRepository {

  Future<double> getBalance() async {
    final db = await DBHelper.database;
    final result = await db.query('wallet');
    return result.first['balance'] as double;
  }

  Future<void> addMoney(double amount, String note) async {
    final db = await DBHelper.database;
    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE wallet SET balance = balance + ?',
        [amount],
      );

      await txn.insert(
        'transactions',
        TransactionModel(
          type: 'ADD',
          amount: amount,
          note: note,
          createdAt: DateTime.now().toIso8601String(),
        ).toMap(),
      );
    });

  }

    Future<void> cashOut(double amount, String note) async {
    final db = await DBHelper.database;

    await db.transaction((txn) async {
      // 1) Read current balance (wallet row id=1 recommended)
      final res = await txn.query(
        'wallet',
        columns: ['balance'],
        where: 'id = ?',
        whereArgs: [1],
        limit: 1,
      );

      final current = res.isEmpty ? 0.0 : (res.first['balance'] as num).toDouble();

      // 2) Block if not enough money
      if (amount > current) {
        throw Exception("Not enough balance. Current: $current");
      }

      // 3) Update + insert transaction
      await txn.rawUpdate(
        'UPDATE wallet SET balance = balance - ? WHERE id = 1',
        [amount],
      );

      await txn.insert(
        'transactions',
        TransactionModel(
          type: 'CASH_OUT',
          amount: amount,
          note: note.trim(),
          createdAt: DateTime.now().toIso8601String(),
        ).toMap(),
      );
    });
  }


  Future<List<Map<String, dynamic>>> transactions() async {
    final db = await DBHelper.database;
    return db.query(
      'transactions',
      orderBy: 'created_at DESC',
    );
  }


  Future<WalletSummary> getSummaryAllTime() async {
    final db = await DBHelper.database;
    final res = await db.rawQuery('''
      SELECT
        COALESCE(SUM(CASE WHEN type='ADD' THEN amount ELSE 0 END), 0) AS total_add,
        COALESCE(SUM(CASE WHEN type='CASH_OUT' THEN amount ELSE 0 END), 0) AS total_cashout
      FROM transactions
    ''');

    return WalletSummary(
      totalAdd: (res.first['total_add'] as num).toDouble(),
      totalCashOut: (res.first['total_cashout'] as num).toDouble(),
    );
  }


  Future<WalletSummary> getSummaryMonthly(DateTime date) async {
    final db = await DBHelper.database;
    final ym = "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}";

    final res = await db.rawQuery('''
      SELECT
        COALESCE(SUM(CASE WHEN type='ADD' THEN amount ELSE 0 END), 0) AS total_add,
        COALESCE(SUM(CASE WHEN type='CASH_OUT' THEN amount ELSE 0 END), 0) AS total_cashout
      FROM transactions
      WHERE substr(created_at, 1, 7) = ?
    ''', [ym]);

    return WalletSummary(
      totalAdd: (res.first['total_add'] as num).toDouble(),
      totalCashOut: (res.first['total_cashout'] as num).toDouble(),
    );
  }

  Future<WalletSummary> getSummaryYearly(int year) async {
    final db = await DBHelper.database;

    final res = await db.rawQuery('''
      SELECT
        COALESCE(SUM(CASE WHEN type='ADD' THEN amount ELSE 0 END), 0) AS total_add,
        COALESCE(SUM(CASE WHEN type='CASH_OUT' THEN amount ELSE 0 END), 0) AS total_cashout
      FROM transactions
      WHERE substr(created_at, 1, 4) = ?
    ''', [year.toString()]);

    return WalletSummary(
      totalAdd: (res.first['total_add'] as num).toDouble(),
      totalCashOut: (res.first['total_cashout'] as num).toDouble(),
    );
  }








}


class WalletSummary {
  final double totalAdd;
  final double totalCashOut;

  WalletSummary({required this.totalAdd, required this.totalCashOut});
}
