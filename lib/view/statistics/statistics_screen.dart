import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/view/statistics/graph/Budget_graph.dart';
import 'package:spendigo/view/statistics/graph/expense_income_graph.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Statistics"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BudgetVsActualChart(),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ExpenseVsIncomeChart(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
