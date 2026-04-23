class TransactionModel {
  final String type;
  final String category;
  final String wallet;
  final String budget;
  final String note;

  TransactionModel({
    required this.type,
    required this.category,
    required this.wallet,
    required this.budget,
    required this.note,
  });
}