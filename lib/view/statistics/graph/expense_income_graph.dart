// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/transaction_controller.dart';

class ExpenseVsIncomeChart extends StatelessWidget {
  const ExpenseVsIncomeChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddTransactionController>();

    const monthNames = [
      "JAN", "FEB", "MAR", "APR", "MAY", "JUN", 
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    ];

    return Obx(() {
      final incomeData = controller.monthlyIncome;
      final expenseData = controller.monthlyExpense;

      // Calculate max Y for scaling
      double maxY = 0;
      for (var val in incomeData) { if (val > maxY) maxY = val; }
      for (var val in expenseData) { if (val > maxY) maxY = val; }
      maxY = maxY == 0 ? 100 : maxY * 1.2;

      // Get month labels for the last 6 months
      final now = DateTime.now();
      final months = List.generate(6, (i) {
        final date = DateTime(now.year, now.month - (5 - i), 1);
        return monthNames[date.month - 1];
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
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 10,
              children: [
                const Text(
                  "Expense vs Income",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    legend(AppColors.primary, "Income"),
                    const SizedBox(width: 16),
                    legend(Colors.black, "Expense"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 260,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: maxY,
                  clipData: const FlClipData.all(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: maxY / 5,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: AppColors.stroke, strokeWidth: 1),
                    getDrawingVerticalLine: (value) =>
                        FlLine(color: AppColors.stroke, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: maxY / 5,
                        reservedSize: 35,
                        getTitlesWidget: (value, _) => Text(
                          value >= 1000 ? '${(value / 1000).toStringAsFixed(0)}k' : value.toStringAsFixed(0),
                          style: TextStyle(color: AppColors.grey, fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          int idx = value.toInt();
                          if (idx < 0 || idx >= months.length) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[idx],
                              style: TextStyle(color: AppColors.grey, fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    // Expense Line (Black)
                    LineChartBarData(
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: Colors.black,
                      barWidth: 2,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: Colors.black,
                            ),
                      ),
                      spots: List.generate(6, (i) => FlSpot(i.toDouble(), expenseData[i])),
                    ),
                    // Income Line (Green Dashed + Area)
                    LineChartBarData(
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: AppColors.primary,
                      barWidth: 2,
                      dashArray: [6, 6],
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: const FlDotData(show: false),
                      spots: List.generate(6, (i) => FlSpot(i.toDouble(), incomeData[i])),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.black,
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          return LineTooltipItem(
                            "Rs. ${spot.y.toStringAsFixed(0)}",
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget legend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
