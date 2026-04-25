import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/queue_system.dart';
import 'results_screen.dart';

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 18),
          ),
        ),
        title: const Text(
          'Live Simulation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<QueueSystem>(
        builder: (context, queueSystem, child) {
          final isDoubleServer = queueSystem.servers.length > 1;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B00).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Current Time: ${queueSystem.currentTime.toStringAsFixed(2)} sec',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: queueSystem.isRunning ? null : 1,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        color: Colors.white,
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _ServerCard(
                        title: 'Server 1',
                        status: queueSystem.server1Status,
                        customerId: queueSystem.currentCustomerId1,
                      ),
                    ),
                    if (isDoubleServer) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ServerCard(
                          title: 'Server 2',
                          status: queueSystem.server2Status,
                          customerId: queueSystem.currentCustomerId2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(
                      color: const Color(0xFFFF6B00).withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.queue,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Queue (${queueSystem.currentQueueIds.length} customers)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 100),
                        child: queueSystem.currentQueueIds.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    'No customers waiting',
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: queueSystem.currentQueueIds.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFFF8C00),
                                                Color(0xFFFF4500)
                                              ],
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${queueSystem.currentQueueIds[index]}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Customer ${queueSystem.currentQueueIds[index]}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Spacer(),
                                        const Text(
                                          'Waiting...',
                                          style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.access_time,
                                            color: Color(0xFFFF8C00), size: 14),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF111111),
                      border: Border.all(
                        color: const Color(0xFFFF6B00).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            color: Colors.white.withOpacity(0.05),
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFFFF6B00).withOpacity(0.2),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      const Color(0xFFFF6B00).withOpacity(0.15),
                                ),
                                child: const Icon(Icons.list_alt,
                                    color: Color(0xFFFF8C00), size: 16),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Event Log',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      const Color(0xFFFF6B00).withOpacity(0.15),
                                ),
                                child: Text(
                                  '${queueSystem.eventLogs.length} events',
                                  style: const TextStyle(
                                    color: Color(0xFFFF8C00),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: queueSystem.eventLogs.isEmpty
                              ? Center(
                                  child: Text(
                                    'Waiting for events...',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                      fontSize: 13,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  reverse: true,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  itemCount: queueSystem.eventLogs.length,
                                  itemBuilder: (context, index) {
                                    final log = queueSystem.eventLogs.reversed
                                        .toList()[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      child: Row(
                                        children: [
                                          _getLogIcon(log.type),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              log.message,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${log.time.toStringAsFixed(1)}s',
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: queueSystem.isRunning
                      ? null
                      : () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ResultsScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                            ),
                          ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: queueSystem.isRunning
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
                            ),
                      color: queueSystem.isRunning
                          ? Colors.white.withOpacity(0.05)
                          : null,
                      boxShadow: queueSystem.isRunning
                          ? null
                          : [
                              BoxShadow(
                                color:
                                    const Color(0xFFFF6B00).withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          queueSystem.isRunning
                              ? Icons.hourglass_empty
                              : Icons.bar_chart_rounded,
                          color: queueSystem.isRunning
                              ? Colors.white30
                              : Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          queueSystem.isRunning
                              ? 'Simulation Running...'
                              : 'View Results',
                          style: TextStyle(
                            color: queueSystem.isRunning
                                ? Colors.white30
                                : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _getLogIcon(String type) {
    switch (type) {
      case 'start':
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withOpacity(0.2),
          ),
          child: const Icon(Icons.play_arrow, color: Colors.green, size: 12),
        );
      case 'finish':
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.withOpacity(0.2),
          ),
          child: const Icon(Icons.stop, color: Colors.red, size: 12),
        );
      case 'arrive':
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(0.2),
          ),
          child: const Icon(Icons.person_add, color: Colors.blue, size: 12),
        );
      default:
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.08),
          ),
          child: const Icon(Icons.info, color: Colors.white38, size: 12),
        );
    }
  }
}

class _ServerCard extends StatelessWidget {
  final String title;
  final String status;
  final int? customerId;

  const _ServerCard({
    required this.title,
    required this.status,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    final isBusy = status == 'Busy';
    final statusColor =
        isBusy ? const Color(0xFFFF4444) : const Color(0xFF44DD88);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: statusColor.withOpacity(0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor.withOpacity(0.12),
              border: Border.all(
                color: statusColor.withOpacity(0.3),
              ),
            ),
            child: Icon(
              isBusy ? Icons.build_rounded : Icons.check_circle_rounded,
              color: statusColor,
              size: 26,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: statusColor.withOpacity(0.15),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          if (customerId != null) ...[
            const SizedBox(height: 6),
            Text(
              'Customer #$customerId',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
