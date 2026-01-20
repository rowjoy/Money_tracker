import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytracker/bloc/bazaar/bazaar_event.dart';
import 'package:moneytracker/bloc/bazaar/bazaar_states.dart';
import 'package:moneytracker/repo/bazaar_repo.dart';

class BazaarBloc extends Bloc<BazaarEvent, BazaarState> {
  final BazaarRepository repo;

  BazaarBloc(this.repo) : super(BazaarState(selectedDate: DateTime.now())) {
    on<BazaarLoadByDate>(_loadByDate);
    on<BazaarAdd>(_add);
    on<BazaarSuggestionsQuery>(_suggest);
  }

  Future<void> _loadByDate(BazaarLoadByDate e, Emitter<BazaarState> emit) async {
    emit(state.copyWith(loading: true, selectedDate: e.date, error: null));
    try {
      final data = await repo.listByDate(e.date);
      emit(state.copyWith(loading: false, list: data));
    } catch (err) {
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }

  Future<void> _add(BazaarAdd e, Emitter<BazaarState> emit) async {
    try {
      await repo.addBazaar(bazaarName: e.name, amount: e.amount, note: e.note);
      add(BazaarLoadByDate(state.selectedDate));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> _suggest(
      BazaarSuggestionsQuery e, Emitter<BazaarState> emit) async {
    try {
      final list = await repo.suggestions(query: e.query);
      emit(state.copyWith(suggestions: list));
    } catch (_) {}
  }
}