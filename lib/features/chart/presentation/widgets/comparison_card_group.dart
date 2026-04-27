import 'package:flutter/material.dart';
import 'package:takeaway_app/features/chart/presentation/widgets/comparison_card_widget.dart';
import '../../../../../logic/queue_system.dart';

class ComparisonCardGroup extends StatelessWidget {
  final QueueSystem queueSystem;

  const ComparisonCardGroup({
    super.key,
    required this.queueSystem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ComparisonCard(
          label: 'Average Waiting Time',
          single: queueSystem.singleResult?.avgWaitingTime,
          doubleVal: queueSystem.doubleResult?.avgWaitingTime,
          unit: 'sec',
        ),
        const SizedBox(height: 12),
        ComparisonCard(
          label: 'Server Utilization',
          single: queueSystem.singleResult?.serverUtilization,
          doubleVal: queueSystem.doubleResult?.serverUtilization,
          unit: '%',
          isPercentage: true,
        ),
        const SizedBox(height: 12),
        ComparisonCard(
          label: 'Max Queue Length',
          single: queueSystem.singleResult?.maxQueueLength.toDouble(),
          doubleVal: queueSystem.doubleResult?.maxQueueLength.toDouble(),
          unit: 'customers',
        ),
      ],
    );
  }
}
