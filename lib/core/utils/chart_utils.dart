import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartUtils {
  static double getMaxY(double a, double b) {
    final max = a > b ? a : b;
    return max + 5;
  }

  static BarChartGroupData barGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 35,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  static FlTitlesData barTitles() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(
              value == 0 ? 'Single' : 'Double',
              style: const TextStyle(color: Colors.white70),
            );
          },
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: true),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  static FlTitlesData lineTitles() {
    return const FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  static FlGridData grid() {
    return const FlGridData(
      show: true,
      drawVerticalLine: false,
    );
  }
}
