import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';

class TotalWealthChart extends StatelessWidget {
  const TotalWealthChart({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
            _header(width),
            SizedBox(height: width * 0.05),
            _chart(width),
          ],
        ),
      );
  }

  Widget _header(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Wealth",
          style: TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
        ),
        Text(
          "Rs. 1345678",
          style: TextStyle(
            fontSize: width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _chart(double width) {
    return SizedBox(
      height: width * 0.6, // responsive height
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 10,

          // GRID
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 2,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.shade300, strokeWidth: 1),
            getDrawingVerticalLine: (value) =>
                FlLine(color: Colors.grey.shade300, strokeWidth: 1),
          ),

          // AXIS LABELS
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, _) => Text(
                  value.toInt().toString(),
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
                  const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN'];

                  if (value.toInt() >= months.length) return const SizedBox();

                  return Text(
                    months[value.toInt()],
                    style: TextStyle(
                      fontSize: width * 0.03,
                      color: AppColors.grey,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          borderData: FlBorderData(show: false),

          // LINE DATA
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 2.5),
                FlSpot(2, 4.5),
                FlSpot(3, 6.5),
                FlSpot(4, 4.7),
                FlSpot(5, 7.3),
                FlSpot(6, 6.8),
                FlSpot(7, 8),
              ],
              isCurved: false,
              color: Colors.black,
              barWidth: 2,

              // DOT STYLE (white circle with black border)
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                      radius: width * 0.012,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: Colors.black,
                    ),
              ),
            ),
          ],

          // TOOLTIP
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.black,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  return LineTooltipItem(
                    "\$${spot.y}",
                    TextStyle(color: Colors.white, fontSize: width * 0.03),
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
