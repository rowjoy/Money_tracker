class WalletModel {
  final int id;
  final double balance;
  final String currency;

  WalletModel({
    required this.id,
    required this.balance,
    required this.currency,
  });

  factory WalletModel.fromMap(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      balance: json['balance'],
      currency: json['currency'],
    );
  }
}
