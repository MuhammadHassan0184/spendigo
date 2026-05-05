// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/view/statistics/graph/Budget_graph.dart';
import 'package:spendigo/view/statistics/graph/expense_income_graph.dart';
import 'package:spendigo/view/statistics/graph/category_pie_chart.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "statistics".tr,
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutesName.reports),
            child: Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.picture_as_pdf, color: AppColors.black),
            ),
          ),
        ],
      ),
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
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CategoryPieChart(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
