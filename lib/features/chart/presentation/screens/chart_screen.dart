import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../logic/queue_system.dart';
import '../widgets/chart_body_widget.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final queueSystem = context.watch<QueueSystem>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      appBar: _buildAppBar(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ChartBody(
              queueSystem: queueSystem,
              isLoading: _isLoading,
              onRun: _runSimulation,
            ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0A0A0C),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: const Text("Comparison & Charts"),
    );
  }

  Future<void> _runSimulation() async {
    final queueSystem = context.read<QueueSystem>();

    setState(() => _isLoading = true);

    queueSystem.runSimulationLive(
      numCustomers: 50,
      meanInterarrival: 2,
      meanService: 3,
      numServers: 1,
    );

    await Future.delayed(const Duration(seconds: 10));

    queueSystem.runSimulationLive(
      numCustomers: 50,
      meanInterarrival: 2,
      meanService: 3,
      numServers: 2,
    );

    await Future.delayed(const Duration(seconds: 10));

    if (mounted) setState(() => _isLoading = false);
  }
}
