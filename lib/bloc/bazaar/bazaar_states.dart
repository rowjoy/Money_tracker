class BazaarState {
  final DateTime selectedDate;
  final bool loading;
  final List<Map<String, dynamic>> list;
  final List<String> suggestions;
  final String? error;

  const BazaarState({
    required this.selectedDate,
    this.loading = false,
    this.list = const [],
    this.suggestions = const [],
    this.error,
  });

  double get total => list.fold<double>(
        0,
        (sum, r) => sum + ((r["amount"] as num?)?.toDouble() ?? 0.0),
      );

  BazaarState copyWith({
    DateTime? selectedDate,
    bool? loading,
    List<Map<String, dynamic>>? list,
    List<String>? suggestions,
    String? error,
  }) {
    return BazaarState(
      selectedDate: selectedDate ?? this.selectedDate,
      loading: loading ?? this.loading,
      list: list ?? this.list,
      suggestions: suggestions ?? this.suggestions,
      error: error,
    );
  }
}