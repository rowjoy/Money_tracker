class WalletState {
  final bool loading;
  final double balance;
  final List<Map<String, dynamic>> transactions;
  final String? error;
  final double totalExpense;
  final double totalIncome;

  const WalletState({
    required this.loading,
    required this.balance,
    required this.transactions,
    required this.totalExpense,
    required this.totalIncome,
    this.error,
  });

  factory WalletState.initial() => const WalletState(
        loading: false,
        balance: 0,
        transactions: [],
        totalExpense: 0.0,
        totalIncome: 0.0,
      );

  WalletState copyWith({
    bool? loading,
    double? balance,
    List<Map<String, dynamic>>? transactions,
    double? totalExpense,
    double? totalIncome,
    String? error,
  }) {
    return WalletState(
      loading: loading ?? this.loading,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      totalExpense: totalExpense ?? this.totalExpense,
      totalIncome: totalIncome ?? this.totalIncome,
      error: error,
    );
  }
}
