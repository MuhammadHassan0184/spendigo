import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/Models/transaction_model.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';

class AddTransactionController extends GetxController {
  var isIncome = false.obs;
  var repeat = false.obs;

  var category = RxnString();
  var wallet = RxnString();
  var budget = RxnString();

  var repeatType = "Every day".obs;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // Predefined lists
  final List<String> incomeCategories = [
    "Salary",
    "Pocket Money",
    "Business",
    "Gifts",
    "Other Income",
  ];

  final List<String> expenseCategories = [
    "Entertainment",
    "Food & Drink",
    "Shopping",
    "Fuel",
    "Utilities",
    "Other Expense",
  ];

  final List<String> wallets = [
    "Cash",
    "Bank Account",
    "Credit Card",
    "Paypal",
  ];

  final List<String> budgets = ["Monthly", "Weekly", "Travel", "Custom"];

  // Observable list of transactions
  var transactions = <TransactionModel>[].obs;

  void toggleIncome(bool value) {
    isIncome.value = value;
    category.value = null; // Clear category when type changes
  }

  void toggleRepeat(bool value) {
    repeat.value = value;
  }

  void setRepeatType(String value) {
    repeatType.value = value;
  }

  void addTransaction() {
    if (amountController.text.isEmpty) {
      showCustomSnackBar("Error", "Please enter an amount", isError: true);
      return;
    }

    if (category.value == null) {
      showCustomSnackBar("Error", "Please select a category", isError: true);
      return;
    }

    final transaction = TransactionModel(
      type: isIncome.value ? "Income" : "Expense",
      category: category.value!,
      wallet: wallet.value ?? "Default",
      budget: budget.value ?? "Default",
      note: noteController.text,
      amount: double.tryParse(amountController.text) ?? 0.0,
      date: DateTime.now(),
    );

    transactions.add(transaction);

    // Clear fields
    amountController.clear();
    noteController.clear();
    category.value = null;
    wallet.value = null;
    budget.value = null;

    Get.back(); // Navigate back to home
    showCustomSnackBar("Success", "${transaction.type} added successfully");
  }

  double get totalIncome => transactions
      .where((t) => t.type == "Income")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.type == "Expense")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalBalance => totalIncome - totalExpense;

  String getIconPath(String category) {
    switch (category) {
      case "Salary":
        return "assets/salary.svg";
      case "Pocket Money":
        return "assets/pocketmoney.svg";
      case "Entertainment":
        return "assets/entertainment.svg";
      case "Food & Drink":
        return "assets/food.svg";
      case "Budget":
        return "assets/budget.svg";
      case "Wallet":
        return "assets/wallet.svg";
      case "Shopping":
        return "assets/budget.svg"; // Fallback to budget for shopping
      default:
        return "assets/statistics.svg"; // Default icon
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case "Salary":
        return const Color(0xFF25A969); // green
      case "Pocket Money":
        return Colors.blue;
      case "Entertainment":
        return Colors.blue.shade300;
      case "Food & Drink":
        return AppColors.yellowgreen;
      case "Shopping":
        return Colors.orange;
      case "Business":
        return Colors.purple;
      case "Gifts":
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
