// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';
import 'package:moneytracker/repo/insights_repo.dart';


class AnalyticsState extends Equatable {
  final bool loading;
  final AnalyticsPeriod period;
  final DateTime anchor;

  final List<Map<String, dynamic>> walletSeries;
  final double income;
  final double expense;

  final List<Map<String, dynamic>> bazaarSeries;
  final double bazaarTotal;

  final String? error;

  const AnalyticsState({
    required this.loading,
    required this.period,
    required this.anchor,
    required this.walletSeries,
    required this.income,
    required this.expense,
    required this.bazaarSeries,
    required this.bazaarTotal,
    this.error,
  });

  double get net => income - expense;

  AnalyticsState copyWith({
    bool? loading,
    AnalyticsPeriod? period,
    DateTime? anchor,
    List<Map<String, dynamic>>? walletSeries,
    double? income,
    double? expense,
    List<Map<String, dynamic>>? bazaarSeries,
    double? bazaarTotal,
    String? error,
  }) {
    return AnalyticsState(
      loading: loading ?? this.loading,
      period: period ?? this.period,
      anchor: anchor ?? this.anchor,
      walletSeries: walletSeries ?? this.walletSeries,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      bazaarSeries: bazaarSeries ?? this.bazaarSeries,
      bazaarTotal: bazaarTotal ?? this.bazaarTotal,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [loading, period, anchor, walletSeries, income, expense, bazaarSeries, bazaarTotal, error];

  static AnalyticsState initial() => AnalyticsState(
        loading: true,
        period: AnalyticsPeriod.week,
        anchor: DateTime.now(),
        walletSeries: const [],
        income: 0,
        expense: 0,
        bazaarSeries: const [],
        bazaarTotal: 0,
      );
}
