// =====================================================
// 3) BLoC
// =====================================================
abstract class BazaarEvent {}

class BazaarLoadByDate extends BazaarEvent {
  final DateTime date;
  BazaarLoadByDate(this.date);
}

class BazaarAdd extends BazaarEvent {
  final String name;
  final double amount;
  final String note;
  BazaarAdd({required this.name, required this.amount, required this.note});
}

class BazaarSuggestionsQuery extends BazaarEvent {
  final String query;
  BazaarSuggestionsQuery(this.query);
}