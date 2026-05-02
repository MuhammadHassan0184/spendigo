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

  @HiveField(8)
  final bool? isRepeating;

  @HiveField(9)
  final String? repeatInterval;

  @HiveField(10)
  final DateTime? lastRepeatedDate;

  TransactionModel({
    required this.type,
    required this.category,
    required this.wallet,
    required this.budget,
    required this.note,
    required this.amount,
    required this.date,
    this.attachmentPath,
    this.isRepeating = false,
    this.repeatInterval,
    this.lastRepeatedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'category': category,
      'wallet': wallet,
      'budget': budget,
      'note': note,
      'amount': amount,
      'date': date.toIso8601String(),
      'attachmentPath': attachmentPath,
      'isRepeating': isRepeating,
      'repeatInterval': repeatInterval,
      'lastRepeatedDate': lastRepeatedDate?.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      type: map['type'] ?? '',
      category: map['category'] ?? '',
      wallet: map['wallet'] ?? '',
      budget: map['budget'] ?? '',
      note: map['note'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      date: DateTime.parse(map['date']),
      attachmentPath: map['attachmentPath'],
      isRepeating: map['isRepeating'],
      repeatInterval: map['repeatInterval'],
      lastRepeatedDate: map['lastRepeatedDate'] != null
          ? DateTime.parse(map['lastRepeatedDate'])
          : null,
    );
  }
}
