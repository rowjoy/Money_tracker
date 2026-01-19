class TransactionModel {
  final int? id;
  final String type;
  final double amount;
  final String note;
  final String createdAt;

  TransactionModel({
    this.id,
    required this.type,
    required this.amount,
    required this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'amount': amount,
      'note': note,
      'status': 'SUCCESS',
      'created_at': createdAt,
    };
  }
}
