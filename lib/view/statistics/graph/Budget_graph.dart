// ignore_for_file: deprecated_member_use, file_names

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';

class BudgetVsActualChart extends StatelessWidget {
  const BudgetVsActualChart({super.key});

  @override
  Widget build(BuildContext context) {
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
          Text(
            "Budget vs Actual Spending",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20),

          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 12,
                barTouchData: BarTouchData(enabled: false),

                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: AppColors.grey,
                            // fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = [
                          "November",
                          "December",
                          "January",
                          "February",
                        ];

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            titles[value.toInt()],
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),

                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 2,
                  drawVerticalLine: false,
                ),

                borderData: FlBorderData(show: false),

                barGroups: [
                  makeGroup(0, 7, 10),
                  makeGroup(1, 12, 7),
                  makeGroup(2, 11, 9),
                  makeGroup(3, 8.3, 9),
                ],
              ),
            ),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              legend(Colors.black, "Budget"),
              const SizedBox(width: 20),
              legend(AppColors.primary, "Actual Spending"),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroup(int x, double budget, double actual) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: budget,
          width: 16,
          borderRadius: BorderRadius.circular(6),
          color: Colors.black,
        ),

        BarChartRodData(
          toY: actual,
          width: 16,
          borderRadius: BorderRadius.circular(6),
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
