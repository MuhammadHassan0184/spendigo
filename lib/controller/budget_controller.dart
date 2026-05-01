import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/Models/budget_model.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';
import 'package:hive/hive.dart';

class CreateBudgetController extends GetxController {
  var sliderValue = 0.0.obs;
  var receiveAlert = true.obs;
  var selectedCategory = RxnString();
  var editingIndex = RxnInt();

  final TextEditingController amountController = TextEditingController();

  final List<String> categories = [
    'Food & Groceries',
    'Transport',
    'Entertainment',
    'Shopping',
    'Health',
    'Education',
    'Bills & Utilities',
    'Other',
  ];

  // Observable list of budgets
  var budgets = <BudgetModel>[].obs;

  final _box = Hive.box<BudgetModel>('budgets');
  var maxSliderAmount = 50000.0.obs;

  @override
  void onInit() {
    super.onInit();
    amountController.text = "0";

    // Load from Hive
    if (_box.isNotEmpty) {
      budgets.assignAll(_box.values.toList());
    }

    // Sync slider -> amount
    ever(sliderValue, (double val) {
      final amount = val * (maxSliderAmount.value / 100);
      if (amountController.text != amount.toStringAsFixed(0)) {
        amountController.text = amount.toStringAsFixed(0);
      }
    });

    // We also need to listen to maxSliderAmount changes to keep amount in sync if slider moves
    ever(maxSliderAmount, (double max) {
      final amount = sliderValue.value * (max / 100);
      amountController.text = amount.toStringAsFixed(0);
    });

    // Save to Hive whenever budgets list changes
    ever(budgets, (List<BudgetModel> list) {
      _box.clear();
      _box.addAll(list);
    });
  }

  void initForEdit(BudgetModel b, int index) {
    editingIndex.value = index;
    selectedCategory.value = b.category;
    amountController.text = b.total.toStringAsFixed(0);
    receiveAlert.value = b.receiveAlert;
    sliderValue.value = b.alertPercentage;
    if (b.total > maxSliderAmount.value) {
      maxSliderAmount.value = b.total;
    }
  }

  void clearFields() {
    editingIndex.value = null;
    selectedCategory.value = null;
    amountController.text = "0";
    sliderValue.value = 0.0;
    maxSliderAmount.value = 50000.0;
    receiveAlert.value = true;
  }

  void updateSliderFromAmount(String value) {
    final amount = double.tryParse(value) ?? 0.0;

    // If entered amount is greater than current max, increase max
    if (amount > maxSliderAmount.value) {
      maxSliderAmount.value = amount;
    }

    final newValue = (amount / maxSliderAmount.value) * 100;
    sliderValue.value = newValue.clamp(0.0, 100.0);
  }

  double get budgetAmount => double.tryParse(amountController.text) ?? 0.0;

  void createBudget() {
    if (selectedCategory.value == null) {
      showCustomSnackBar("Error", "Please select a category", isError: true);
      return;
    }

    if (amountController.text.isEmpty || budgetAmount <= 0) {
      showCustomSnackBar("Error", "Please enter a valid amount", isError: true);
      return;
    }

    final newBudget = BudgetModel(
      category: selectedCategory.value!,
      total: budgetAmount,
      receiveAlert: receiveAlert.value,
      alertPercentage: sliderValue.value,
      spent: editingIndex.value != null
          ? budgets[editingIndex.value!].spent
          : 0.0,
    );

    if (editingIndex.value != null) {
      budgets[editingIndex.value!] = newBudget;
    } else {
      budgets.add(newBudget);
    }

    final isEditing = editingIndex.value != null;
    clearFields();

    Get.back();
    showCustomSnackBar(
      "Success",
      isEditing ? "Budget updated successfully" : "Budget created successfully",
    );
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
