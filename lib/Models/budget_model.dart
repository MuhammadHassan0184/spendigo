import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 2)
class BudgetModel {
  @HiveField(0)
  final String category;
  @HiveField(1)
  final double total;
  @HiveField(2)
  final double spent;
  @HiveField(3)
  final bool receiveAlert;
  @HiveField(4)
  final double alertPercentage;

  BudgetModel({
    required this.category,
    required this.total,
    this.spent = 0.0,
    required this.receiveAlert,
    required this.alertPercentage,
  });

  BudgetModel copyWith({
    String? category,
    double? total,
    double? spent,
    bool? receiveAlert,
    double? alertPercentage,
  }) {
    return BudgetModel(
      category: category ?? this.category,
      total: total ?? this.total,
      spent: spent ?? this.spent,
      receiveAlert: receiveAlert ?? this.receiveAlert,
      alertPercentage: alertPercentage ?? this.alertPercentage,
    );
  }

  double get remaining => total - spent;
}
