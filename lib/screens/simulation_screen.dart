import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/queue_system.dart';
import '../screens/results_screen.dart';

class SimulationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Simulation'),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<QueueSystem>(
        builder: (context, queueSystem, child) {
          return Column(
            children: [
              // الوقت الحالي
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                color: Colors.orange[100],
                child: Column(
                  children: [
                    Text(
                      'Current Time: ${queueSystem.currentTime.toStringAsFixed(2)} sec',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: queueSystem.isRunning ? null : 1,
                      backgroundColor: Colors.orange[200],
                    ),
                  ],
                ),
              ),

              // حالة السيرفرات
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
                      SizedBox(width: 16),
                      if (Provider.of<QueueSystem>(context).servers.length > 1)
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
                  ),
                ),
              ),

              // قائمة الانتظار
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.orange,
                        child: Text(
                          'Queue (${queueSystem.currentQueueIds.length} customers)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
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
                              subtitle: Text('Waiting...'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ================== 🔥 الـ LOG AREA الجديد 🔥 ==================
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[900],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.list_alt, color: Colors.white, size: 20),
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
                        child: ListView.builder(
                          reverse: true, // الأحدث في الأعلى
                          itemCount: queueSystem.eventLogs.length,
                          itemBuilder: (context, index) {
                            // reverse true فبنعكس الترتيب
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
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      log.message,
                                      style: TextStyle(
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

              // زر الانتقال للنتائج
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: queueSystem.isRunning
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultsScreen(),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Show Results →', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
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
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'Busy' ? Icons.build : Icons.check_circle,
              color: color,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              status,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            if (customerId != null)
              Text(
                'Serving: Customer $customerId',
                style: TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getLogIcon(String type) {
    switch (type) {
      case 'start':
        return Icon(Icons.play_arrow, color: Colors.green, size: 16);
      case 'finish':
        return Icon(Icons.stop, color: Colors.red, size: 16);
      case 'arrive':
        return Icon(Icons.person_add, color: Colors.blue, size: 16);
      default:
        return Icon(Icons.info, color: Colors.grey, size: 16);
    }
  }
}
