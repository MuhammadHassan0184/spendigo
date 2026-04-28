import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/Models/transaction_model.dart';
import 'package:spendigo/Models/wallet_model.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/wallet_controller.dart';
import 'package:spendigo/controller/budget_controller.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class AddTransactionController extends GetxController {
  var isIncome = false.obs;
  var repeat = false.obs;
  var transactionToEdit = Rxn<TransactionModel>();

  var category = RxnString();
  var wallet = RxnString();
  var budget = RxnString();

  var repeatType = "Every day".obs;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  var attachmentPath = RxnString();

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

  final List<String> defaultWallets = [
    "Cash",
    "Bank Account",
    "Credit Card",
    "Paypal",
  ];

  List<String> get wallets {
    final walletController = Get.find<CreateWalletController>();
    if (walletController.wallets.isEmpty) {
      return defaultWallets;
    }
    return walletController.wallets.map((w) => w.name).toList();
  }

  List<String> get availableBudgets {
    final budgetController = Get.find<CreateBudgetController>();
    if (budgetController.budgets.isEmpty) {
      return ["Monthly", "Weekly", "Travel", "Custom"];
    }
    return budgetController.budgets.map((b) => b.category).toSet().toList();
  }

  // Observable list of transactions
  var transactions = <TransactionModel>[].obs;

  final _box = Hive.box<TransactionModel>('transactions');

  @override
  void onInit() {
    super.onInit();
    loadTransactions();

    // Save to Hive whenever transactions list changes
    ever(transactions, (List<TransactionModel> list) {
      _box.clear();
      _box.addAll(list);
    });
  }

  void loadTransactions() {
    if (_box.isNotEmpty) {
      transactions.assignAll(_box.values.toList());
    }
  }

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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      attachmentPath.value = image.path;
    }
  }

  void addTransaction() {
    final amount = double.tryParse(amountController.text) ?? 0.0;

    if (amount <= 0) {
      showCustomSnackBar("Error", "Please enter a valid amount", isError: true);
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
      amount: amount,
      date: transactionToEdit.value?.date ?? DateTime.now(),
      attachmentPath: attachmentPath.value,
    );

    // If we are editing, remove the old one first
    if (transactionToEdit.value != null) {
      // Silence the "Deleted successfully" snackbar during edit
      _deleteSilently(transactionToEdit.value!);
    }

    // 1. Add to transactions list
    transactions.add(transaction);

    // 2. Update Wallet Balance
    final walletController = Get.find<CreateWalletController>();
    final selectedWalletIndex = walletController.wallets.indexWhere(
      (w) => w.name == transaction.wallet,
    );

    if (selectedWalletIndex != -1) {
      final oldWallet = walletController.wallets[selectedWalletIndex];
      final newBalance = transaction.type == "Income"
          ? oldWallet.balance + transaction.amount
          : oldWallet.balance - transaction.amount;
      walletController.wallets[selectedWalletIndex] = oldWallet.copyWith(
        balance: newBalance,
      );
    } else {
      // If no wallet exists with this name, create a new one automatically
      final newWallet = WalletModel(
        name: transaction.wallet,
        balance: transaction.type == "Income"
            ? transaction.amount
            : -transaction.amount,
        receiveAlert: false,
        alertPercentage: 0,
      );
      walletController.wallets.add(newWallet);
    }

    // 3. Update Budget Spent (only for expenses)
    if (transaction.type == "Expense") {
      final budgetController = Get.find<CreateBudgetController>();
      final selectedBudgetIndex = budgetController.budgets.indexWhere(
        (b) => b.category == transaction.budget,
      );
      if (selectedBudgetIndex != -1) {
        final oldBudget = budgetController.budgets[selectedBudgetIndex];
        budgetController.budgets[selectedBudgetIndex] = oldBudget.copyWith(
          spent: oldBudget.spent + transaction.amount,
        );
      }
    }

    // Clear fields
    clearFields();

    Get.back(); // Navigate back to home
    showCustomSnackBar(
      "Success",
      transactionToEdit.value != null
          ? "Transaction updated"
          : "${transaction.type} added successfully",
    );
    transactionToEdit.value = null;
  }

  void deleteTransaction(TransactionModel transaction) {
    // 1. Reverse Wallet Balance
    final walletController = Get.find<CreateWalletController>();
    final selectedWalletIndex = walletController.wallets.indexWhere(
      (w) => w.name == transaction.wallet,
    );

    if (selectedWalletIndex != -1) {
      final oldWallet = walletController.wallets[selectedWalletIndex];
      final newBalance = transaction.type == "Income"
          ? oldWallet.balance - transaction.amount
          : oldWallet.balance + transaction.amount;
      walletController.wallets[selectedWalletIndex] = oldWallet.copyWith(
        balance: newBalance,
      );
    }

    // 2. Reverse Budget Spent (only for expenses)
    if (transaction.type == "Expense") {
      final budgetController = Get.find<CreateBudgetController>();
      final selectedBudgetIndex = budgetController.budgets.indexWhere(
        (b) => b.category == transaction.budget,
      );
      if (selectedBudgetIndex != -1) {
        final oldBudget = budgetController.budgets[selectedBudgetIndex];
        budgetController.budgets[selectedBudgetIndex] = oldBudget.copyWith(
          spent: oldBudget.spent - transaction.amount,
        );
      }
    }

    // 3. Remove from transactions list
    transactions.remove(transaction);
    showCustomSnackBar("Success", "Transaction deleted successfully");
  }

  void _deleteSilently(TransactionModel transaction) {
    // 1. Reverse Wallet Balance
    final walletController = Get.find<CreateWalletController>();
    final selectedWalletIndex = walletController.wallets.indexWhere(
      (w) => w.name == transaction.wallet,
    );

    if (selectedWalletIndex != -1) {
      final oldWallet = walletController.wallets[selectedWalletIndex];
      final newBalance = transaction.type == "Income"
          ? oldWallet.balance - transaction.amount
          : oldWallet.balance + transaction.amount;
      walletController.wallets[selectedWalletIndex] = oldWallet.copyWith(
        balance: newBalance,
      );
    }

    // 2. Reverse Budget Spent (only for expenses)
    if (transaction.type == "Expense") {
      final budgetController = Get.find<CreateBudgetController>();
      final selectedBudgetIndex = budgetController.budgets.indexWhere(
        (b) => b.category == transaction.budget,
      );
      if (selectedBudgetIndex != -1) {
        final oldBudget = budgetController.budgets[selectedBudgetIndex];
        budgetController.budgets[selectedBudgetIndex] = oldBudget.copyWith(
          spent: oldBudget.spent - transaction.amount,
        );
      }
    }

    // 3. Remove from transactions list
    transactions.remove(transaction);
  }

  void initForEdit(TransactionModel t) {
    transactionToEdit.value = t;
    isIncome.value = t.type == "Income";
    amountController.text = t.amount.toStringAsFixed(0);
    noteController.text = t.note;
    category.value = t.category;
    wallet.value = t.wallet;
    budget.value = t.budget;
    attachmentPath.value = t.attachmentPath;
  }

  void clearFields() {
    amountController.clear();
    noteController.clear();
    category.value = null;
    wallet.value = null;
    budget.value = null;
    transactionToEdit.value = null;
    repeat.value = false;
    attachmentPath.value = null;
  }

  double get totalIncome => transactions
      .where((t) => t.type == "Income")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.type == "Expense")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalBalance {
    final walletController = Get.find<CreateWalletController>();
    return walletController.totalWealth;
  }

  // Statistics Data Getters
  List<double> get monthlyIncome {
    List<double> data = List.filled(6, 0.0);
    DateTime now = DateTime.now();
    for (var t in transactions) {
      if (t.type == "Income") {
        int monthDiff =
            (now.year - t.date.year) * 12 + now.month - t.date.month;
        if (monthDiff >= 0 && monthDiff < 6) {
          data[5 - monthDiff] += t.amount;
        }
      }
    }
    return data;
  }

  List<double> get monthlyExpense {
    List<double> data = List.filled(6, 0.0);
    DateTime now = DateTime.now();
    for (var t in transactions) {
      if (t.type == "Expense") {
        int monthDiff =
            (now.year - t.date.year) * 12 + now.month - t.date.month;
        if (monthDiff >= 0 && monthDiff < 6) {
          data[5 - monthDiff] += t.amount;
        }
      }
    }
    return data;
  }

  List<double> get monthlyWealth {
    List<double> income = monthlyIncome;
    List<double> expense = monthlyExpense;
    List<double> wealth = List.filled(6, 0.0);
    double current = totalBalance;

    wealth[5] = current;
    for (int i = 4; i >= 0; i--) {
      wealth[i] = wealth[i + 1] - (income[i + 1] - expense[i + 1]);
    }
    return wealth;
  }

  // Monthly Budget vs Actual (Last 4 months)
  List<double> get last4MonthsActual {
    List<double> data = List.filled(4, 0.0);
    DateTime now = DateTime.now();
    for (var t in transactions) {
      if (t.type == "Expense") {
        int monthDiff =
            (now.year - t.date.year) * 12 + now.month - t.date.month;
        if (monthDiff >= 0 && monthDiff < 4) {
          data[3 - monthDiff] += t.amount;
        }
      }
    }
    return data;
  }

  List<double> get last4MonthsBudget {
    final budgetController = Get.find<CreateBudgetController>();
    double totalBudget = budgetController.budgets.fold(
      0.0,
      (sum, b) => sum + b.total,
    );
    // Since we don't have historical budget data, we use current total budget for current month
    // and a simulated/historical average for others, or just the same for simplicity in this demo.
    return [
      totalBudget * 0.8,
      totalBudget * 0.9,
      totalBudget * 1.1,
      totalBudget,
    ];
  }

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
