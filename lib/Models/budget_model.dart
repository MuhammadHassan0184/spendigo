class BudgetModel {
  final String category;
  final double total;
  final double spent;
  final bool receiveAlert;
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
