import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/Models/transaction_model.dart';
import 'package:spendigo/Models/wallet_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/wallet_controller.dart';
import 'package:spendigo/controller/budget_controller.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spendigo/services/notification_service.dart';

class AddTransactionController extends GetxController
    with WidgetsBindingObserver {
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
  var incomeCategories = <String>[
    "Salary",
    "Freelance",
    "Investment",
    "Business",
    "Pocket Money",
    "Rent Income",
    "Gifts",
    "Bonus",
    "Other Income",
  ].obs;

  var expenseCategories = <String>[
    "Food & Drink",
    "Shopping",
    "Transportation",
    "Rent",
    "Groceries",
    "Fuel",
    "Entertainment",
    "Health & Fitness",
    "Utilities",
    "Subscriptions",
    "Education",
    "Other Expense",
  ].obs;

  final List<String> defaultWallets = [
    "Cash",
    "Bank Account",
    "Credit Card",
    "Savings",
    "Paypal",
    "Digital Wallet",
    "Crypto",
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

  Box<TransactionModel> get _box {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Hive.box<TransactionModel>('transactions_$uid');
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    if (FirebaseAuth.instance.currentUser != null) {
      loadTransactions();
    }

    // Check for recurring transactions on startup
    checkAndProcessRecurringTransactions();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkAndProcessRecurringTransactions();
    }
  }

  void loadTransactions() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && Hive.isBoxOpen('transactions_$uid')) {
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

  void addCustomCategory(String name) {
    if (isIncome.value) {
      if (!incomeCategories.contains(name)) {
        incomeCategories.insert(incomeCategories.length - 1, name);
      }
    } else {
      if (!expenseCategories.contains(name)) {
        expenseCategories.insert(expenseCategories.length - 1, name);
      }
    }
    category.value = name;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      attachmentPath.value = image.path;
    }
  }

  Future<void> addTransaction() async {
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
      isRepeating: repeat.value,
      repeatInterval: repeat.value ? repeatType.value : null,
      lastRepeatedDate: repeat.value
          ? (transactionToEdit.value?.lastRepeatedDate ?? DateTime.now())
          : null,
    );

    // If we are editing, remove the old one first
    if (transactionToEdit.value != null) {
      await _deleteSilently(transactionToEdit.value!);
    }

    // 1. Add to Hive and local list
    await _box.add(transaction);
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

      final updatedWallet = oldWallet.copyWith(balance: newBalance);
      walletController.wallets[selectedWalletIndex] = updatedWallet;

      // Persist wallet change
      await walletController.updateWalletInHive(
        selectedWalletIndex,
        updatedWallet,
      );

      // Low Balance Notification Check
      if (transaction.type == "Expense" && oldWallet.receiveAlert) {
        final initialBalance = oldWallet.alertPercentage * 1000.0;
        final threshold = initialBalance * 0.2;
        if (newBalance <= threshold && oldWallet.balance > threshold) {
          NotificationService.showNotification(
            'Low Balance Alert!',
            'Your ${oldWallet.name} wallet balance has dropped below the threshold.',
          );
        }
      }
    } else {
      final newWallet = WalletModel(
        name: transaction.wallet,
        balance: transaction.type == "Income"
            ? transaction.amount
            : -transaction.amount,
        receiveAlert: false,
        alertPercentage: 0,
      );
      walletController.wallets.add(newWallet);
      await walletController.addWalletToHive(newWallet);
    }

    // 3. Update Budget Spent (only for expenses)
    if (transaction.type == "Expense") {
      final budgetController = Get.find<CreateBudgetController>();
      final selectedBudgetIndex = budgetController.budgets.indexWhere(
        (b) => b.category == transaction.budget,
      );
      if (selectedBudgetIndex != -1) {
        final oldBudget = budgetController.budgets[selectedBudgetIndex];
        final newSpent = oldBudget.spent + transaction.amount;

        final updatedBudget = oldBudget.copyWith(spent: newSpent);
        budgetController.budgets[selectedBudgetIndex] = updatedBudget;

        // Persist budget change
        await budgetController.updateBudgetInHive(
          selectedBudgetIndex,
          updatedBudget,
        );

        // Budget Low Alert Notification
        if (oldBudget.receiveAlert && oldBudget.total > 0) {
          final threshold = oldBudget.total * (oldBudget.alertPercentage / 100);
          final oldSpent = oldBudget.spent;
          if (newSpent >= threshold && oldSpent < threshold) {
            NotificationService.showNotification(
              'Budget Alert: ${oldBudget.category}',
              'You have used ${oldBudget.alertPercentage.toInt()}% of your ${oldBudget.category} budget!',
            );
          }
        }
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

  Future<void> addTransactionManually(TransactionModel transaction) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && Hive.isBoxOpen('transactions_$uid')) {
      await _box.add(transaction);
      transactions.add(transaction);
    }
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
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

      final updatedWallet = oldWallet.copyWith(balance: newBalance);
      walletController.wallets[selectedWalletIndex] = updatedWallet;
      await walletController.updateWalletInHive(
        selectedWalletIndex,
        updatedWallet,
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
        final updatedBudget = oldBudget.copyWith(
          spent: oldBudget.spent - transaction.amount,
        );
        budgetController.budgets[selectedBudgetIndex] = updatedBudget;
        await budgetController.updateBudgetInHive(
          selectedBudgetIndex,
          updatedBudget,
        );
      }
    }

    // 3. Remove from transactions Hive and list
    final index = transactions.indexOf(transaction);
    if (index != -1) {
      await _box.deleteAt(index);
      transactions.removeAt(index);
    }
    showCustomSnackBar("Success", "Transaction deleted successfully");
  }

  Future<void> _deleteSilently(TransactionModel transaction) async {
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

      final updatedWallet = oldWallet.copyWith(balance: newBalance);
      walletController.wallets[selectedWalletIndex] = updatedWallet;
      await walletController.updateWalletInHive(
        selectedWalletIndex,
        updatedWallet,
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
        final updatedBudget = oldBudget.copyWith(
          spent: oldBudget.spent - transaction.amount,
        );
        budgetController.budgets[selectedBudgetIndex] = updatedBudget;
        await budgetController.updateBudgetInHive(
          selectedBudgetIndex,
          updatedBudget,
        );
      }
    }

    // 3. Remove from transactions Hive and list
    final index = transactions.indexOf(transaction);
    if (index != -1) {
      await _box.deleteAt(index);
      transactions.removeAt(index);
    }
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
    repeat.value = t.isRepeating ?? false;
    if (t.repeatInterval != null) {
      repeatType.value = t.repeatInterval!;
    }
  }

  void clearFields() {
    amountController.clear();
    noteController.clear();
    category.value = null;
    wallet.value = null;
    budget.value = null;
    transactionToEdit.value = null;
    repeat.value = false;
    repeatType.value = "Every day"; // Reset to default
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
      case "Bonus":
      case "Freelance":
      case "Investment":
      case "Business":
      case "Rent Income":
        return "assets/salary.svg";
      case "Pocket Money":
        return "assets/pocketmoney.svg";
      case "Entertainment":
        return "assets/entertainment.svg";
      case "Food & Drink":
      case "Groceries":
        return "assets/food.svg";
      case "Transportation":
      case "Fuel":
      case "Shopping":
        return "assets/budget.svg";
      case "Rent":
        return "assets/home.svg";
      case "Health & Fitness":
      case "Subscriptions":
      case "Education":
        return "assets/report.svg";
      case "Wallet":
        return "assets/wallet.svg";
      case "Budget":
        return "assets/budget.svg";
      default:
        return "assets/statistics.svg";
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case "Salary":
      case "Bonus":
      case "Investment":
        return const Color(0xFF25A969);
      case "Pocket Money":
      case "Freelance":
        return Colors.blue;
      case "Entertainment":
        return Colors.blue.shade300;
      case "Food & Drink":
      case "Groceries":
        return AppColors.yellowgreen;
      case "Shopping":
        return Colors.orange;
      case "Business":
      case "Rent Income":
        return Colors.purple;
      case "Gifts":
        return Colors.pink;
      case "Transportation":
      case "Fuel":
        return Colors.cyan;
      case "Rent":
        return Colors.brown;
      case "Health & Fitness":
        return Colors.redAccent;
      case "Subscriptions":
        return Colors.indigo;
      case "Education":
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Future<void> checkAndProcessRecurringTransactions() async {
    print("Checking for recurring transactions...");
    bool updated = false;
    DateTime now = DateTime.now();
    List<TransactionModel> newTransactions = [];

    for (int i = 0; i < transactions.length; i++) {
      var t = transactions[i];
      if (t.isRepeating == true && t.repeatInterval != null) {
        DateTime lastDate = t.lastRepeatedDate ?? t.date;
        DateTime nextDate = _calculateNextDate(lastDate, t.repeatInterval!);

        while (nextDate.isBefore(now) ||
            (nextDate.year == now.year &&
                nextDate.month == now.month &&
                nextDate.day == now.day)) {
          final repeatedTransaction = TransactionModel(
            type: t.type,
            category: t.category,
            wallet: t.wallet,
            budget: t.budget,
            note: "${t.note} (Repeated)",
            amount: t.amount,
            date: nextDate,
            attachmentPath: t.attachmentPath,
            isRepeating: false,
          );

          newTransactions.add(repeatedTransaction);

          t = TransactionModel(
            type: t.type,
            category: t.category,
            wallet: t.wallet,
            budget: t.budget,
            note: t.note,
            amount: t.amount,
            date: t.date,
            attachmentPath: t.attachmentPath,
            isRepeating: true,
            repeatInterval: t.repeatInterval,
            lastRepeatedDate: nextDate,
          );

          // Update in local list and Hive
          transactions[i] = t;
          await _box.putAt(i, t);

          updated = true;

          NotificationService.showNotification(
            "Transaction Repeated",
            "A recurring ${t.type.toLowerCase()} of ${t.amount} for ${t.category} has been added.",
          );

          nextDate = _calculateNextDate(nextDate, t.repeatInterval!);
        }
      }
    }

    if (updated) {
      for (var nt in newTransactions) {
        await _box.add(nt);
        transactions.add(nt);
        await _updateBalancesForRecurring(nt);
      }
    }
  }

  DateTime _calculateNextDate(DateTime from, String interval) {
    switch (interval) {
      case "Every day":
        return from.add(const Duration(days: 1));
      case "Every 2 days":
        return from.add(const Duration(days: 2));
      case "Every work day":
        DateTime next = from.add(const Duration(days: 1));
        while (next.weekday == DateTime.saturday ||
            next.weekday == DateTime.sunday) {
          next = next.add(const Duration(days: 1));
        }
        return next;
      case "Every week":
        return from.add(const Duration(days: 7));
      case "Every 2 weeks":
        return from.add(const Duration(days: 14));
      case "Every 4 weeks":
        return from.add(const Duration(days: 28));
      case "Every month":
        return DateTime(from.year, from.month + 1, from.day);
      case "Every 2 months":
        return DateTime(from.year, from.month + 2, from.day);
      case "Every 4 months":
        return DateTime(from.year, from.month + 4, from.day);
      default:
        return from.add(const Duration(days: 1));
    }
  }

  Future<void> _updateBalancesForRecurring(TransactionModel transaction) async {
    final walletController = Get.find<CreateWalletController>();
    final selectedWalletIndex = walletController.wallets.indexWhere(
      (w) => w.name == transaction.wallet,
    );

    if (selectedWalletIndex != -1) {
      final oldWallet = walletController.wallets[selectedWalletIndex];
      final newBalance = transaction.type == "Income"
          ? oldWallet.balance + transaction.amount
          : oldWallet.balance - transaction.amount;
      final updatedWallet = oldWallet.copyWith(balance: newBalance);
      walletController.wallets[selectedWalletIndex] = updatedWallet;
      await walletController.updateWalletInHive(
        selectedWalletIndex,
        updatedWallet,
      );
    }

    if (transaction.type == "Expense") {
      final budgetController = Get.find<CreateBudgetController>();
      final selectedBudgetIndex = budgetController.budgets.indexWhere(
        (b) => b.category == transaction.budget,
      );
      if (selectedBudgetIndex != -1) {
        final oldBudget = budgetController.budgets[selectedBudgetIndex];
        final updatedBudget = oldBudget.copyWith(
          spent: oldBudget.spent + transaction.amount,
        );
        budgetController.budgets[selectedBudgetIndex] = updatedBudget;
        await budgetController.updateBudgetInHive(
          selectedBudgetIndex,
          updatedBudget,
        );
      }
    }
  }
}
