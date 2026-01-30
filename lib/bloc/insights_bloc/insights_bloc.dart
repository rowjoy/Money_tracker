import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytracker/bloc/insights_bloc/insights_event.dart';
import 'package:moneytracker/bloc/insights_bloc/insights_state.dart';

import '../../repo/insights_repo.dart';


class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepo repo;

  AnalyticsBloc(this.repo) : super(AnalyticsState.initial()) {
    on<AnalyticsInit>((e, emit) async => _load(emit, state.period, state.anchor));
    on<AnalyticsChangePeriod>((e, emit) async => _load(emit, e.period, state.anchor));
    on<AnalyticsChangeDate>((e, emit) async => _load(emit, state.period, e.anchor));
    on<AnalyticsRefresh>((e, emit) async => _load(emit, state.period, state.anchor));
  }

  Future<void> _load(Emitter<AnalyticsState> emit, AnalyticsPeriod p, DateTime anchor) async {
    emit(state.copyWith(loading: true, period: p, anchor: anchor, error: null));

    try {
      final range = repo.rangeOf(p, anchor);

      final walletSeries = await repo.walletSeries(period: p, anchor: anchor);
      final totals = await repo.walletTotalsForRange(range);

      final bazaarSeries = await repo.bazaarSeries(period: p, anchor: anchor);
      final bazaarTotal = await repo.bazaarTotalForRange(range);

      emit(state.copyWith(
        loading: false,
        walletSeries: walletSeries,
        income: totals["income"] ?? 0,
        expense: totals["expense"] ?? 0,
        bazaarSeries: bazaarSeries,
        bazaarTotal: bazaarTotal,
      ));
    } catch (err) {
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }
}
