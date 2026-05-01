import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/Models/wallet_model.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Box<WalletModel> get _box {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Hive.box<WalletModel>('wallets_$uid');
  }

  var editingIndex = RxnInt();

  @override
  void onInit() {
    super.onInit();
    amountController.text = "0";

    if (FirebaseAuth.instance.currentUser != null) {
      loadWallets();
    }

    // Sync slider -> amount
    ever(sliderValue, (double val) {
      final amount = val * (maxSliderAmount / 100);
      if (amountController.text != amount.toStringAsFixed(0)) {
        amountController.text = amount.toStringAsFixed(0);
      }
    });
  }

  void loadWallets() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && Hive.isBoxOpen('wallets_$uid')) {
      wallets.assignAll(_box.values.toList());
    }
  }

  Future<void> addWalletToHive(WalletModel wallet) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && Hive.isBoxOpen('wallets_$uid')) {
      await _box.add(wallet);
    }
  }

  Future<void> updateWalletInHive(int index, WalletModel wallet) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && Hive.isBoxOpen('wallets_$uid')) {
      await _box.putAt(index, wallet);
    }
  }

  Future<void> deleteWalletFromHive(int index) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && Hive.isBoxOpen('wallets_$uid')) {
      await _box.deleteAt(index);
    }
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

  double get totalWealth =>
      wallets.fold(0.0, (sum, wallet) => sum + wallet.balance);

  double get budgetAmount => double.tryParse(amountController.text) ?? 0.0;

  Future<void> createWallet() async {
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
      final index = editingIndex.value!;
      wallets[index] = newWallet;
      await updateWalletInHive(index, newWallet);
    } else {
      wallets.add(newWallet);
      await addWalletToHive(newWallet);

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
          // Directly add to Hive and list in TransactionController
          await transController.addTransactionManually(initialTransaction);
        }
      }
    }

    clearFields();
    Get.back();
    showCustomSnackBar(
      "Success",
      editingIndex.value != null
          ? "Wallet updated successfully"
          : "Wallet added successfully",
    );
  }

  Future<void> deleteWallet(int index) async {
    await deleteWalletFromHive(index);
    wallets.removeAt(index);
    showCustomSnackBar("Success", "Wallet deleted successfully");
  }

  @override
  void onClose() {
    nameController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
