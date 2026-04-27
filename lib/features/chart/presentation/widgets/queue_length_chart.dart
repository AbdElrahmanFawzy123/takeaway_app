import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../logic/queue_system.dart';
import '../../../../core/utils/chart_utils.dart';

class QueueLengthChart extends StatelessWidget {
  final QueueSystem queueSystem;

  const QueueLengthChart({
    super.key,
    required this.queueSystem,
  });

  @override
  Widget build(BuildContext context) {
    final data = queueSystem.singleResult?.queueLengthHistory ?? [];

    if (data.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⏳ Queue Length (Single Server)',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 16),
        Container(
          height: 220,
          padding: const EdgeInsets.all(20),
          decoration: _box(),
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: data
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                      .toList(),
                  isCurved: true,
                  color: const Color(0xFFFF8C00),
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFFFF8C00).withValues(alpha: 0.1),
                  ),
                ),
              ],
              titlesData: ChartUtils.lineTitles(),
              gridData: ChartUtils.grid(),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _box() => BoxDecoration(
        color: const Color(0xFF121215),
        borderRadius: BorderRadius.circular(20),
      );
}
