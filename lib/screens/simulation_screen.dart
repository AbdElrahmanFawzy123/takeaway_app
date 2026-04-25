import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/queue_system.dart';
import '../screens/results_screen.dart';

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Simulation'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Consumer<QueueSystem>(
        builder: (context, queueSystem, child) {
          final isDoubleServer = queueSystem.servers.length > 1;

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/restaurant.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // Current Time Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.95),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Current Time: ${queueSystem.currentTime.toStringAsFixed(2)} sec',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: queueSystem.isRunning ? null : 1,
                        backgroundColor: Colors.white30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                // Servers Status
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildServerCard(
                            title: 'Server 1',
                            status: queueSystem.server1Status,
                            customerId: queueSystem.currentCustomerId1,
                            color: queueSystem.server1Status == 'Busy'
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        if (isDoubleServer) ...[
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildServerCard(
                              title: 'Server 2',
                              status: queueSystem.server2Status,
                              customerId: queueSystem.currentCustomerId2,
                              color: queueSystem.server2Status == 'Busy'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Queue Display
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.queue, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Queue (${queueSystem.currentQueueIds.length} customers)',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: queueSystem.currentQueueIds.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No customers waiting',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: queueSystem.currentQueueIds.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        child: Text(
                                          '${queueSystem.currentQueueIds[index]}',
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                      title: Text(
                                        'Customer ${queueSystem.currentQueueIds[index]}',
                                      ),
                                      subtitle: const Text('Waiting...'),
                                      trailing: const Icon(
                                        Icons.access_time,
                                        color: Colors.orange,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Event Log Area
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[900],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.list_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Event Log',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: queueSystem.eventLogs.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Waiting for events...',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  reverse: true,
                                  itemCount: queueSystem.eventLogs.length,
                                  itemBuilder: (context, index) {
                                    final log = queueSystem.eventLogs.reversed
                                        .toList()[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          _getLogIcon(log.type),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              log.message,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${log.time.toStringAsFixed(1)}s',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 10,
                                              fontFamily: 'monospace',
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

                // Results Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: queueSystem.isRunning
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResultsScreen(),
                              ),
                            );
                          },
                    icon: const Icon(Icons.bar_chart, size: 24),
                    label: const Text(
                      'Show Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServerCard({
    required String title,
    required String status,
    required int? customerId,
    required Color color,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'Busy' ? Icons.build : Icons.check_circle,
              color: color,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              status,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            if (customerId != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Serving: Customer $customerId',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getLogIcon(String type) {
    switch (type) {
      case 'start':
        return const Icon(Icons.play_arrow, color: Colors.green, size: 16);
      case 'finish':
        return const Icon(Icons.stop, color: Colors.red, size: 16);
      case 'arrive':
        return const Icon(Icons.person_add, color: Colors.blue, size: 16);
      default:
        return const Icon(Icons.info, color: Colors.grey, size: 16);
    }
  }
}
