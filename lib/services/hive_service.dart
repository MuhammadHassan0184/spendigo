import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendigo/Models/transaction_model.dart';
import 'package:spendigo/Models/wallet_model.dart';
import 'package:spendigo/Models/budget_model.dart';
import 'package:spendigo/Models/notification_model.dart';
import 'package:get/get.dart';
import 'package:spendigo/controller/transaction_controller.dart';
import 'package:spendigo/controller/wallet_controller.dart';
import 'package:spendigo/controller/budget_controller.dart';
import 'package:spendigo/controller/notification_controller.dart';
import 'package:spendigo/controller/currency_controller.dart';

class HiveService {
  static Future<void> openUserBoxes(String uid) async {
    await Future.wait([
      Hive.openBox<TransactionModel>('transactions_$uid'),
      Hive.openBox<WalletModel>('wallets_$uid'),
      Hive.openBox<BudgetModel>('budgets_$uid'),
      Hive.openBox<NotificationModel>('notifications_$uid'),
      Hive.openBox('settings_$uid'),
    ]);
  }

  static void refreshAllControllers() {
    if (Get.isRegistered<AddTransactionController>()) {
      Get.find<AddTransactionController>().loadTransactions();
    }
    if (Get.isRegistered<CreateWalletController>()) {
      Get.find<CreateWalletController>().loadWallets();
    }
    if (Get.isRegistered<CreateBudgetController>()) {
      Get.find<CreateBudgetController>().loadBudgets();
    }
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().loadNotifications();
    }
    if (Get.isRegistered<CurrencyController>()) {
      Get.find<CurrencyController>().loadCurrency();
      Get.find<CurrencyController>().checkHintStatus();
    }
  }

  static void clearAllControllers() {
    if (Get.isRegistered<AddTransactionController>()) {
      Get.find<AddTransactionController>().transactions.clear();
    }
    if (Get.isRegistered<CreateWalletController>()) {
      Get.find<CreateWalletController>().wallets.clear();
    }
    if (Get.isRegistered<CreateBudgetController>()) {
      Get.find<CreateBudgetController>().budgets.clear();
    }
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().notifications.clear();
    }
    if (Get.isRegistered<CurrencyController>()) {
      Get.find<CurrencyController>().selectedCurrency.value = "Rs.";
    }
  }
}
