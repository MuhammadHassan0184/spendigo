import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/wallet_controller.dart';
import 'package:spendigo/controller/transaction_controller.dart';

class TotalWealthChart extends StatelessWidget {
  const TotalWealthChart({super.key});

  @override
  Widget build(BuildContext context) {
    final walletController = Get.find<CreateWalletController>();
    final transactionController = Get.find<AddTransactionController>();
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      final total = walletController.totalWealth;
      final wealthData = transactionController.monthlyWealth;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(width, total),
            SizedBox(height: width * 0.05),
            _chart(width, wealthData),
          ],
        ),
      );
    });
  }

  Widget _header(double width, double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Wealth",
          style: TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
        ),
        Text(
          "Rs. ${total.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _chart(double width, List<double> wealthData) {
    const monthNames = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC",
    ];

    final now = DateTime.now();
    final months = List.generate(6, (i) {
      final date = DateTime(now.year, now.month - (5 - i), 1);
      return monthNames[date.month - 1];
    });

    List<FlSpot> spots = List.generate(
      6,
      (i) => FlSpot(i.toDouble(), wealthData[i]),
    );

    double minVal = wealthData.isEmpty
        ? 0
        : wealthData.reduce((a, b) => a < b ? a : b);
    double maxVal = wealthData.isEmpty
        ? 100
        : wealthData.reduce((a, b) => a > b ? a : b);

    // Ensure we include 0 and have a reasonable default range
    double viewMin = minVal < 0 ? minVal : 0;
    double viewMax = maxVal > 0 ? maxVal : 100;
    double range = viewMax - viewMin;
    if (range == 0) range = 100;

    // Add padding to handle curves and spikes
    double minY = viewMin - (range * 0.1);
    double maxY = viewMax + (range * 0.2); // Extra padding for top labels
    double interval = (maxY - minY) / 5;
    if (interval <= 0) interval = 20;

    return SizedBox(
      height: width * 0.6,
      child: LineChart(
        LineChartData(
          clipData: const FlClipData.all(),
          minX: 0,
          maxX: 5,
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: interval,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: AppColors.stroke, strokeWidth: 1),
            getDrawingVerticalLine: (value) =>
                FlLine(color: AppColors.stroke, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: interval,
                reservedSize: 40,
                getTitlesWidget: (value, _) => Text(
                  value.abs() >= 1000
                      ? '${(value / 1000).toStringAsFixed(0)}k'
                      : value.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: width * 0.025,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int idx = value.toInt();
                  if (idx >= 0 && idx < months.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        months[idx],
                        style: TextStyle(
                          fontSize: width * 0.025,
                          color: AppColors.grey,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
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
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: AppColors.black,
              barWidth: 2,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    // ignore: deprecated_member_use
                    AppColors.black.withOpacity(0.15),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                      radius: 3,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: AppColors.black,
                    ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.black,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  return LineTooltipItem(
                    "Rs. ${spot.y.toStringAsFixed(0)}",
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
