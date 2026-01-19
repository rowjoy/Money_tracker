abstract class WalletEvent {}

class WalletLoadRequested extends WalletEvent {}

class WalletAddRequested extends WalletEvent {
  final double amount;
  final String note;
  WalletAddRequested(this.amount, this.note);
}

class WalletCashOutRequested extends WalletEvent {
  final double amount;
  final String note;
  WalletCashOutRequested(this.amount, this.note);
}
