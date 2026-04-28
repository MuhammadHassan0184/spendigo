import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/Models/wallet_model.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';
import 'package:hive/hive.dart';
import 'package:spendigo/controller/transaction_controller.dart';
import 'package:spendigo/Models/transaction_model.dart';
class CreateWalletController extends GetxController {
  var sliderValue = 0.0.obs;
  var receiveAlert = true.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Observable list of wallets
  final RxList<WalletModel> wallets = <WalletModel>[].obs;

  final double maxSliderAmount = 100000.0;

  final _box = Hive.box<WalletModel>('wallets');

  var editingIndex = RxnInt();

  @override
  void onInit() {
    super.onInit();
    // Default value set to 0 as requested
    amountController.text = "0";

    // Load from Hive
    if (_box.isNotEmpty) {
      wallets.assignAll(_box.values.toList());
    }
    
    // Sync slider -> amount
    ever(sliderValue, (double val) {
      final amount = val * (maxSliderAmount / 100);
      if (amountController.text != amount.toStringAsFixed(0)) {
        amountController.text = amount.toStringAsFixed(0);
      }
    });

    // Save to Hive whenever wallets list changes
    ever(wallets, (List<WalletModel> list) {
      _box.clear();
      _box.addAll(list);
    });
  }

  void initForEdit(WalletModel w, int index) {
    editingIndex.value = index;
    nameController.text = w.name;
    amountController.text = w.balance.toStringAsFixed(0);
    receiveAlert.value = w.receiveAlert;
    sliderValue.value = w.alertPercentage;
  }

  void clearFields() {
    editingIndex.value = null;
    nameController.clear();
    amountController.text = "0";
    sliderValue.value = 0.0;
    receiveAlert.value = true;
  }

  void updateSliderFromAmount(String value) {
    final amount = double.tryParse(value) ?? 0.0;
    final newValue = (amount / maxSliderAmount) * 100;
    sliderValue.value = newValue.clamp(0.0, 100.0);
  }

  double get totalWealth => wallets.fold(0.0, (sum, wallet) => sum + wallet.balance);

  double get budgetAmount => double.tryParse(amountController.text) ?? 0.0;

  void createWallet() {
    if (nameController.text.isEmpty) {
      showCustomSnackBar("Error", "Please enter a wallet name", isError: true);
      return;
    }

    if (amountController.text.isEmpty) {
      showCustomSnackBar("Error", "Please enter an amount", isError: true);
      return;
    }

    final newWallet = WalletModel(
      name: nameController.text,
      balance: budgetAmount,
      receiveAlert: receiveAlert.value,
      alertPercentage: sliderValue.value,
    );

    if (editingIndex.value != null) {
      // Editing existing wallet
      wallets[editingIndex.value!] = newWallet;
      
      // We might want to adjust the transactions if balance changed? 
      // The prompt asks "if user change anything wallet update", 
      // let's just update the wallet model. The initial transaction might be mismatched, 
      // but matching the exact logic the user wants for now.
    } else {
      // Creating new wallet
      wallets.add(newWallet);
      
      // Add income transaction for the initial balance so it reflects in the transaction list
      if (budgetAmount > 0) {
        if (Get.isRegistered<AddTransactionController>()) {
          final transController = Get.find<AddTransactionController>();
          final initialTransaction = TransactionModel(
            type: "Income",
            category: "Other Income",
            wallet: nameController.text,
            budget: "Default",
            note: "Initial Balance",
            amount: budgetAmount,
            date: DateTime.now(),
          );
          transController.transactions.add(initialTransaction);
        }
      }
    }
    
    clearFields();

    Get.back();
    showCustomSnackBar("Success", editingIndex.value != null ? "Wallet updated successfully" : "Wallet added successfully");
  }

  @override
  void onClose() {
    nameController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
