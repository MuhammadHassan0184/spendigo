// ignore_for_file: deprecated_member_use, file_names

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/transaction_controller.dart';

class BudgetVsActualChart extends StatelessWidget {
  const BudgetVsActualChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddTransactionController>();

    const monthFullNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return Obx(() {
      final actualData = controller.last4MonthsActual;
      final budgetData = controller.last4MonthsBudget;

      double maxY = 0;
      for (var val in actualData) {
        if (val > maxY) maxY = val;
      }
      for (var val in budgetData) {
        if (val > maxY) maxY = val;
      }
      maxY = maxY == 0 ? 100 : maxY * 1.2;

      final now = DateTime.now();
      final months = List.generate(4, (i) {
        final date = DateTime(now.year, now.month - (3 - i), 1);
        return monthFullNames[date.month - 1];
      });

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Budget vs Actual Spending",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppColors.black,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          "Rs. ${rod.toY.toStringAsFixed(0)}",
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: maxY / 5,
                        reservedSize: 35,
                        getTitlesWidget: (value, _) => Text(
                          value >= 1000
                              ? '${(value / 1000).toStringAsFixed(0)}k'
                              : value.toStringAsFixed(0),
                          style: TextStyle(color: AppColors.grey, fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          int idx = value.toInt();
                          if (idx < 0 || idx >= months.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[idx],
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: maxY / 5,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: AppColors.stroke, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    4,
                    (i) => makeGroup(i, budgetData[i], actualData[i]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                legend(AppColors.black, "Budget"),
                const SizedBox(width: 20),
                legend(AppColors.primary, "Actual Spending"),
              ],
            ),
          ],
        ),
      );
    });
  }

  BarChartGroupData makeGroup(int x, double budget, double actual) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: budget,
          width: 14,
          borderRadius: BorderRadius.circular(4),
          color: AppColors.black,
        ),
        BarChartRodData(
          toY: actual,
          width: 14,
          borderRadius: BorderRadius.circular(4),
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget legend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: AppColors.grey)),
      ],
    );
  }
}
