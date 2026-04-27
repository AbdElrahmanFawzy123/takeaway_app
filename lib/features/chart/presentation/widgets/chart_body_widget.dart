import 'package:flutter/material.dart';

import '../../../../logic/queue_system.dart';
import 'comparison_card_group.dart';
import 'run_simulation_button.dart';
import 'waiting_time_chart.dart';

class ChartBody extends StatelessWidget {
  final QueueSystem queueSystem;
  final bool isLoading;
  final VoidCallback onRun;

  const ChartBody({
    super.key,
    required this.queueSystem,
    required this.isLoading,
    required this.onRun,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            '📊 Performance Comparison',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 20),
          ComparisonCardGroup(queueSystem: queueSystem),
          const SizedBox(height: 30),
          WaitingTimeChart(queueSystem: queueSystem),
          const SizedBox(height: 30),
          RunSimulationButton(
            isLoading: isLoading,
            onTap: onRun,
          ),
        ],
      ),
    );
  }
}
