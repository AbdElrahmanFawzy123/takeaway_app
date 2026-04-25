import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/queue_system.dart';
import '../screens/chart_screen.dart';
import '../widgets/custom_card.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var queueSystem = Provider.of<QueueSystem>(context);
    var result = queueSystem.singleResult ?? queueSystem.doubleResult;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Results'), backgroundColor: Colors.orange),
        body: Center(child: Text('No simulation results yet')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Results - ${result.systemType}'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              value: '${(result.serverUtilization * 100).toStringAsFixed(1)}%',
              icon: Icons.show_chart,
              color: Colors.purple,
            ),
            CustomCard(
              title: '⏳ Max Queue Length',
              value: '${result.maxQueueLength}',
              icon: Icons.queue,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChartScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'View Charts & Comparison 📈',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
