import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/queue_system.dart';
import '../screens/chart_screen.dart';
import '../widgets/custom_card.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var queueSystem = Provider.of<QueueSystem>(context);
    var result = queueSystem.singleResult ?? queueSystem.doubleResult;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Results'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 64, color: Colors.orange),
              const SizedBox(height: 20),
              const Text(
                'No simulation results yet',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Results - ${result.systemType}'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    CustomCard(
                      title: '📊 Average Waiting Time',
                      value: '${result.avgWaitingTime.toStringAsFixed(2)} sec',
                      icon: Icons.timer,
                      color: Colors.orange,
                    ),
                    CustomCard(
                      title: '⚙️ Average Service Time',
                      value: '${result.avgServiceTime.toStringAsFixed(2)} sec',
                      icon: Icons.build,
                      color: Colors.blue,
                    ),
                    CustomCard(
                      title: '👥 Served Customers',
                      value: '${result.servedCustomers}',
                      icon: Icons.people,
                      color: Colors.green,
                    ),
                    CustomCard(
                      title: '📈 Server Utilization',
                      value:
                          '${(result.serverUtilization * 100).toStringAsFixed(1)}%',
                      icon: Icons.show_chart,
                      color: Colors.purple,
                    ),
                    CustomCard(
                      title: '⏳ Max Queue Length',
                      value: '${result.maxQueueLength}',
                      icon: Icons.queue,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChartScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.show_chart),
                      label: const Text('View Charts'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
