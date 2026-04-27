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
      "JAN", "FEB", "MAR", "APR", "MAY", "JUN", 
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    ];
    
    final now = DateTime.now();
    final months = List.generate(6, (i) {
      final date = DateTime(now.year, now.month - (5 - i), 1);
      return monthNames[date.month - 1];
    });

    List<FlSpot> spots = List.generate(6, (i) => FlSpot(i.toDouble(), wealthData[i]));

    double maxY = 0;
    for (var val in wealthData) { if (val > maxY) maxY = val; }
    maxY = maxY == 0 ? 100 : maxY * 1.2;

    return SizedBox(
      height: width * 0.6,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 5,
          minY: 0,
          maxY: maxY,
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
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxY / 5,
                reservedSize: 40,
                getTitlesWidget: (value, _) => Text(
                  value >= 1000 ? '${(value / 1000).toStringAsFixed(0)}k' : value.toStringAsFixed(0),
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
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                    const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
