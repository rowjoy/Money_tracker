// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';
import 'package:moneytracker/repo/insights_repo.dart';


abstract class AnalyticsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AnalyticsInit extends AnalyticsEvent {}

class AnalyticsChangePeriod extends AnalyticsEvent {
  final AnalyticsPeriod period;
  AnalyticsChangePeriod(this.period);
  @override
  List<Object?> get props => [period];
}

class AnalyticsChangeDate extends AnalyticsEvent {
  final DateTime anchor;
  AnalyticsChangeDate(this.anchor);
  @override
  List<Object?> get props => [anchor];
}

class AnalyticsRefresh extends AnalyticsEvent {}
