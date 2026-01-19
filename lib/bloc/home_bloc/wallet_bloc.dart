import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytracker/bloc/home_bloc/wallet_event.dart';
import 'package:moneytracker/bloc/home_bloc/wallet_state.dart';
import 'package:moneytracker/repo/wallet_repository.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository repo;

  WalletBloc(this.repo) : super(WalletState.initial()) {
    on<WalletLoadRequested>(_onLoad);
    on<WalletAddRequested>(_onAdd);
    on<WalletCashOutRequested>(_onCashOut);
  }

  Future<void> _onLoad(WalletLoadRequested event, Emitter<WalletState> emit) async {
    emit(state.copyWith(loading: true, error: null, totalExpense: 0.0, totalIncome: 0.0));
    try {
      final balance = await repo.getBalance();
      final txns = await repo.transactions();
      final summary = await repo.getSummaryMonthly(DateTime.now());

      emit(state.copyWith(loading: false, balance: balance, transactions: txns, totalIncome: summary.totalAdd, totalExpense: summary.totalCashOut));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onAdd(WalletAddRequested event, Emitter<WalletState> emit) async {
    try {
      await repo.addMoney(event.amount, event.note);
      add(WalletLoadRequested()); // ✅ auto refresh UI
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onCashOut(WalletCashOutRequested event, Emitter<WalletState> emit) async {
    try {
      await repo.cashOut(event.amount, event.note);
      add(WalletLoadRequested()); // ✅ auto refresh UI
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }


}
