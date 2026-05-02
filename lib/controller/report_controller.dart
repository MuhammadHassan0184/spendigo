import 'package:get/get.dart';
import 'package:spendigo/Models/transaction_model.dart';
import 'package:spendigo/controller/transaction_controller.dart';
import 'package:spendigo/controller/currency_controller.dart';
import 'package:spendigo/services/report_service.dart';

class ReportController extends GetxController {
  final transactionController = Get.find<AddTransactionController>();
  final currencyController = Get.find<CurrencyController>();

  var selectedRange = "This Month".obs;
  final List<String> ranges = [
    "This Week",
    "This Month",
    "This Year",
    "All Time",
  ];

  List<TransactionModel> get filteredTransactions {
    DateTime now = DateTime.now();
    DateTime start;

    switch (selectedRange.value) {
      case "This Week":
        start = now.subtract(Duration(days: now.weekday - 1));
        start = DateTime(start.year, start.month, start.day);
        break;
      case "This Month":
        start = DateTime(now.year, now.month, 1);
        break;
      case "This Year":
        start = DateTime(now.year, 1, 1);
        break;
      default:
        return transactionController.transactions;
    }

    return transactionController.transactions
        .where(
          (t) => t.date.isAfter(start.subtract(const Duration(seconds: 1))),
        )
        .toList();
  }

  double get totalIncome => filteredTransactions
      .where((t) => t.type == "Income")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => filteredTransactions
      .where((t) => t.type == "Expense")
      .fold(0.0, (sum, t) => sum + t.amount);

  void generateReport() {
    ReportService.generateAndPreviewReport(
      filteredTransactions,
      selectedRange.value,
      currencyController.selectedCurrency.value,
    );
  }
}
