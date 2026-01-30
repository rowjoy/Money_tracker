import 'package:moneytracker/database/db_helper.dart';
import 'package:sqflite/sqflite.dart';


enum AnalyticsPeriod { day, week, month, year }
class DateRange {
  final DateTime start;
  final DateTime end;
  const DateRange(this.start, this.end);
}

class AnalyticsRepo {
  Future<Database> get _db async => DBHelper.database;

  DateRange rangeOf(AnalyticsPeriod p, DateTime anchor) {
    switch (p) {
      case AnalyticsPeriod.day:
        final s = DateTime(anchor.year, anchor.month, anchor.day);
        final e = DateTime(anchor.year, anchor.month, anchor.day, 23, 59, 59);
        return DateRange(s, e);

      case AnalyticsPeriod.week:
        // week starts Monday
        final weekday = anchor.weekday; // Mon=1
        final monday = DateTime(anchor.year, anchor.month, anchor.day)
            .subtract(Duration(days: weekday - 1));
        final sunday = monday.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        return DateRange(monday, sunday);

      case AnalyticsPeriod.month:
        final s = DateTime(anchor.year, anchor.month, 1);
        final e = DateTime(anchor.year, anchor.month + 1, 0, 23, 59, 59);
        return DateRange(s, e);

      case AnalyticsPeriod.year:
        final s = DateTime(anchor.year, 1, 1);
        final e = DateTime(anchor.year, 12, 31, 23, 59, 59);
        return DateRange(s, e);
    }
  }

  /// ---- WALLET: get aggregated points for chart ----
  /// Returns list of maps: {label, income, expense}
  Future<List<Map<String, dynamic>>> walletSeries({
    required AnalyticsPeriod period,
    required DateTime anchor,
  }) async {
    final db = await _db;

    // choose grouping
    // day => last 7 days (per day)
    // week => current week (per day)
    // month => current month (per week bucket)
    // year => current year (per month)
    switch (period) {
      case AnalyticsPeriod.day:
        // last 7 days
        final end = DateTime(anchor.year, anchor.month, anchor.day, 23, 59, 59);
        final start = end.subtract(const Duration(days: 6));
        return _walletGroupByDay(db, start, end);

      case AnalyticsPeriod.week:
        final r = rangeOf(AnalyticsPeriod.week, anchor);
        return _walletGroupByDay(db, r.start, r.end);

      case AnalyticsPeriod.month:
        final r = rangeOf(AnalyticsPeriod.month, anchor);
        return _walletGroupByWeek(db, r.start, r.end);

      case AnalyticsPeriod.year:
        final r = rangeOf(AnalyticsPeriod.year, anchor);
        return _walletGroupByMonth(db, r.start, r.end);
    }
  }

  Future<List<Map<String, dynamic>>> _walletGroupByDay(
    Database db,
    DateTime start,
    DateTime end,
  ) async {
    // created_at iso: "YYYY-MM-DD..."
    // group by date part
    final rows = await db.rawQuery('''
      SELECT
        substr(created_at, 1, 10) as k,
        SUM(CASE WHEN type = 'ADD' THEN amount ELSE 0 END) as income,
        SUM(CASE WHEN type = 'CASH_OUT' THEN amount ELSE 0 END) as expense
      FROM transactions
      WHERE created_at BETWEEN ? AND ?
      GROUP BY k
      ORDER BY k ASC
    ''', [start.toIso8601String(), end.toIso8601String()]);

    return rows;
  }

  Future<List<Map<String, dynamic>>> _walletGroupByWeek(
    Database db,
    DateTime start,
    DateTime end,
  ) async {
    // weekly buckets inside a month: k = week index (1..6)
    // Simple approach: group by date then bucket in dart (stable + easy)
    final daily = await _walletGroupByDay(db, start, end);
    // return daily and bucket later in bloc if you want.
    // For now, return daily, UI can show weekly as daily (still ok).
    return daily;
  }

  Future<List<Map<String, dynamic>>> _walletGroupByMonth(
    Database db,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await db.rawQuery('''
      SELECT
        substr(created_at, 1, 7) as k,
        SUM(CASE WHEN type = 'ADD' THEN amount ELSE 0 END) as income,
        SUM(CASE WHEN type = 'CASH_OUT' THEN amount ELSE 0 END) as expense
      FROM transactions
      WHERE created_at BETWEEN ? AND ?
      GROUP BY k
      ORDER BY k ASC
    ''', [start.toIso8601String(), end.toIso8601String()]);
    return rows;
  }

  /// ---- BAZAAR: series ----
  Future<List<Map<String, dynamic>>> bazaarSeries({
    required AnalyticsPeriod period,
    required DateTime anchor,
  }) async {
    final db = await _db;

    switch (period) {
      case AnalyticsPeriod.day:
        final end = DateTime(anchor.year, anchor.month, anchor.day, 23, 59, 59);
        final start = end.subtract(const Duration(days: 6));
        return _bazaarGroupByDay(db, start, end);

      case AnalyticsPeriod.week:
        final r = rangeOf(AnalyticsPeriod.week, anchor);
        return _bazaarGroupByDay(db, r.start, r.end);

      case AnalyticsPeriod.month:
        final r = rangeOf(AnalyticsPeriod.month, anchor);
        return _bazaarGroupByDay(db, r.start, r.end);

      case AnalyticsPeriod.year:
        final r = rangeOf(AnalyticsPeriod.year, anchor);
        return _bazaarGroupByMonth(db, r.start, r.end);
    }
  }

  Future<List<Map<String, dynamic>>> _bazaarGroupByDay(
    Database db,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await db.rawQuery('''
      SELECT
        substr(created_at, 1, 10) as k,
        SUM(amount) as total
      FROM daily_bazaar
      WHERE created_at BETWEEN ? AND ?
      GROUP BY k
      ORDER BY k ASC
    ''', [start.toIso8601String(), end.toIso8601String()]);
    return rows;
  }

  Future<List<Map<String, dynamic>>> _bazaarGroupByMonth(
    Database db,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await db.rawQuery('''
      SELECT
        substr(created_at, 1, 7) as k,
        SUM(amount) as total
      FROM daily_bazaar
      WHERE created_at BETWEEN ? AND ?
      GROUP BY k
      ORDER BY k ASC
    ''', [start.toIso8601String(), end.toIso8601String()]);
    return rows;
  }

  /// quick totals for cards
  Future<Map<String, double>> walletTotalsForRange(DateRange r) async {
    final db = await _db;
    final rows = await db.rawQuery('''
      SELECT
        SUM(CASE WHEN type = 'ADD' THEN amount ELSE 0 END) as income,
        SUM(CASE WHEN type = 'CASH_OUT' THEN amount ELSE 0 END) as expense
      FROM transactions
      WHERE created_at BETWEEN ? AND ?
    ''', [r.start.toIso8601String(), r.end.toIso8601String()]);

    final m = rows.first;
    return {
      "income": ((m["income"] as num?)?.toDouble() ?? 0.0),
      "expense": ((m["expense"] as num?)?.toDouble() ?? 0.0),
    };
  }

  Future<double> bazaarTotalForRange(DateRange r) async {
    final db = await _db;
    final rows = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM daily_bazaar
      WHERE created_at BETWEEN ? AND ?
    ''', [r.start.toIso8601String(), r.end.toIso8601String()]);

    return ((rows.first["total"] as num?)?.toDouble() ?? 0.0);
  }
}
