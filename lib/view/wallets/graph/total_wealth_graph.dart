import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/wallet_controller.dart';

class TotalWealthChart extends StatelessWidget {
  const TotalWealthChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateWalletController>();
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      final wallets = controller.wallets;
      final total = controller.totalWealth;

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
            _chart(width, wallets),
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

  Widget _chart(double width, RxList wallets) {
    List<FlSpot> spots = [const FlSpot(0, 0)];
    double cumulative = 0;
    
    for (int i = 0; i < wallets.length; i++) {
      cumulative += wallets[i].balance;
      spots.add(FlSpot((i + 1).toDouble(), cumulative));
    }

    // Default spot if no wallets
    if (spots.length == 1) {
      spots = [const FlSpot(0, 0), const FlSpot(1, 0)];
    }

    double maxY = cumulative > 0 ? cumulative * 1.2 : 10;

    return SizedBox(
      height: width * 0.6,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: (maxY / 5) > 0 ? maxY / 5 : 2,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.shade300, strokeWidth: 1),
            getDrawingVerticalLine: (value) =>
                FlLine(color: Colors.grey.shade300, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (maxY / 5) > 0 ? maxY / 5 : 2,
                reservedSize: 40,
                getTitlesWidget: (value, _) => Text(
                  value >= 1000 ? '${(value / 1000).toStringAsFixed(0)}k' : value.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: width * 0.03,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  if (value == 0) return const Text('Start');
                  int idx = value.toInt() - 1;
                  if (idx >= 0 && idx < wallets.length) {
                    return Text(
                      wallets[idx].name.length > 5 
                          ? wallets[idx].name.substring(0, 5) 
                          : wallets[idx].name,
                      style: TextStyle(
                        fontSize: width * 0.03,
                        color: AppColors.grey,
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
              isCurved: false, // Original was not curved
              color: Colors.black, // Original was black
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                      radius: width * 0.012,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: Colors.black, // Original was black
                    ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.black,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  return LineTooltipItem(
                    "Rs. ${spot.y.toStringAsFixed(0)}",
                    const TextStyle(color: Colors.white, fontSize: 12),
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
