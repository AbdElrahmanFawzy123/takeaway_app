import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../logic/queue_system.dart';
import '../../../../core/utils/chart_utils.dart';

class WaitingTimeChart extends StatelessWidget {
  final QueueSystem queueSystem;

  const WaitingTimeChart({
    super.key,
    required this.queueSystem,
  });

  @override
  Widget build(BuildContext context) {
    final single = queueSystem.singleResult?.avgWaitingTime ?? 0;
    final doubleVal = queueSystem.doubleResult?.avgWaitingTime ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📈 Average Waiting Time',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF121215),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: ChartUtils.getMaxY(single, doubleVal).ceilToDouble(),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: single,
                      color: const Color(0xFFFF8C00),
                      width: 35,
                      borderRadius: BorderRadius.circular(6),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: ChartUtils.getMaxY(single, doubleVal) * 0.9,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: doubleVal,
                      color: const Color(0xFF44DD88),
                      width: 35,
                      borderRadius: BorderRadius.circular(6),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: ChartUtils.getMaxY(single, doubleVal) * 0.9,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ],
                ),
              ],
              titlesData: ChartUtils.barTitles(),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white.withValues(alpha: 0.05),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
