import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel {
  @HiveField(0)
  final String type; // "Income" or "Expense"
  @HiveField(1)
  final String category;
  @HiveField(2)
  final String wallet;
  @HiveField(3)
  final String budget;
  @HiveField(4)
  final String note;
  @HiveField(5)
  final double amount;
  @HiveField(6)
  final DateTime date;

  @HiveField(7)
  final String? attachmentPath;

  TransactionModel({
    required this.type,
    required this.category,
    required this.wallet,
    required this.budget,
    required this.note,
    required this.amount,
    required this.date,
    this.attachmentPath,
  });
}
