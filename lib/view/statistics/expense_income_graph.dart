// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';

class ExpenseVsIncomeChart extends StatelessWidget {
  const ExpenseVsIncomeChart({super.key});

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
          /// Title + Legend (Responsive)
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
                maxY: 10,

                clipData: FlClipData.all(),

                /// Grid
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 2,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: AppColors.stroke, strokeWidth: 1);
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(color: AppColors.stroke, strokeWidth: 1);
                  },
                ),

                borderData: FlBorderData(show: false),

                /// Titles
                titlesData: FlTitlesData(
                  /// Left Numbers
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(color: AppColors.grey, fontSize: 12),
                        );
                      },
                    ),
                  ),

                  /// Bottom Months
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          "JAN",
                          "FEB",
                          "MAR",
                          "APR",
                          "MAY",
                          "JUN",
                        ];

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            months[value.toInt()],
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
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

                /// Lines
                lineBarsData: [
                  /// Expense Line (Black)
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

                    spots: const [
                      FlSpot(0, 1),
                      FlSpot(1, 2.6),
                      FlSpot(2, 4.4),
                      FlSpot(3, 6.5),
                      FlSpot(4, 4.7),
                      FlSpot(5, 8),
                    ],
                  ),

                  /// Income Line (Green Dashed + Area)
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

                    dotData: FlDotData(show: false),

                    spots: const [
                      FlSpot(0, 0.5),
                      FlSpot(1, 1.4),
                      FlSpot(2, 2.9),
                      FlSpot(3, 2.1),
                      FlSpot(4, 5.8),
                      FlSpot(5, 5.6),
                    ],
                  ),
                ],

                /// Tooltip
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.black,
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          "\$${spot.y}",
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
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
  }

  /// Legend Widget
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
