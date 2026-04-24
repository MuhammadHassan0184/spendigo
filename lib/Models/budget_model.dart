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

  double get remaining => total - spent;
}
