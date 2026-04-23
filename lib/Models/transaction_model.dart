class TransactionModel {
  final String type; // "Income" or "Expense"
  final String category;
  final String wallet;
  final String budget;
  final String note;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.type,
    required this.category,
    required this.wallet,
    required this.budget,
    required this.note,
    required this.amount,
    required this.date,
  });
}
