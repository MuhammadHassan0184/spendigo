// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/controller/budget_controller.dart';
import 'package:spendigo/controller/currency_controller.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_fab.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateBudgetController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: 'Budgets'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Obx(() {
                if (controller.budgets.isEmpty) {
                  return Column(
                    children: [
                      _BudgetCard(
                        category: 'Default Budget',
                        remaining: 0,
                        spent: 0,
                        total: 0,
                        onTap: () {},
                      ),
                    ],
                  );
                }
                return Column(
                  children: controller.budgets.asMap().entries.map((entry) {
                    int index = entry.key;
                    var budget = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _BudgetCard(
                        category: budget.category,
                        remaining: budget.remaining,
                        spent: budget.spent,
                        total: budget.total,
                        onTap: () {
                          controller.initForEdit(budget, index);
                          Get.toNamed(AppRoutesName.createBudget);
                        },
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFAB(
        onTap: () {
          controller.clearFields();
          Get.toNamed(AppRoutesName.createBudget);
        },
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final String category;
  final double remaining;
  final double spent;
  final double total;
  final VoidCallback onTap;

  const _BudgetCard({
    required this.category,
    required this.remaining,
    required this.spent,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.stroke, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.stroke, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black.withOpacity(0.87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Remaining
            Text(
              'Remaining ${Get.find<CurrencyController>().selectedCurrency.value} ${remaining.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: total > 0 ? spent / total : 0,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${Get.find<CurrencyController>().selectedCurrency.value}${spent.toStringAsFixed(0)} of ${Get.find<CurrencyController>().selectedCurrency.value}${total.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 13, color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
