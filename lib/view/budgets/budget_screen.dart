import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/controller/budget_controller.dart';
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
                  return const Column(
                    children: [
                      _BudgetCard(
                        category: 'Default Budget',
                        remaining: 0,
                        spent: 0,
                        total: 0,
                      ),
                    ],
                  );
                }
                return Column(
                  children: controller.budgets.map((budget) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _BudgetCard(
                        category: budget.category,
                        remaining: budget.remaining,
                        spent: budget.spent,
                        total: budget.total,
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

  const _BudgetCard({
    required this.category,
    required this.remaining,
    required this.spent,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Remaining
          Text(
            'Remaining Rs. ${remaining.toStringAsFixed(0)}',
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
          // Spent / Total
          Text(
            'Rs.${spent.toStringAsFixed(0)} of Rs.${total.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 13, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
