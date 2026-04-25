import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../logic/queue_system.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var queueSystem = Provider.of<QueueSystem>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparison & Charts'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Running Simulations...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان المقارنة
                  const Text(
                    '📊 Performance Comparison',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // بطاقة المقارنة
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildComparisonRow(
                            'Avg Waiting Time',
                            queueSystem.singleResult?.avgWaitingTime,
                            queueSystem.doubleResult?.avgWaitingTime,
                            'sec',
                          ),
                          const Divider(),
                          _buildComparisonRow(
                            'Server Utilization',
                            queueSystem.singleResult?.serverUtilization,
                            queueSystem.doubleResult?.serverUtilization,
                            '%',
                            isPercentage: true,
                          ),
                          const Divider(),
                          _buildComparisonRow(
                            'Max Queue Length',
                            queueSystem.singleResult?.maxQueueLength
                                ?.toDouble(),
                            queueSystem.doubleResult?.maxQueueLength
                                ?.toDouble(),
                            'cust',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // رسم بياني لمتوسط وقت الانتظار
                  const Text(
                    '📈 Average Waiting Time Comparison',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: _getMaxY(
                          queueSystem.singleResult?.avgWaitingTime ?? 0,
                          queueSystem.doubleResult?.avgWaitingTime ?? 0,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text(
                                      'Single',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  case 1:
                                    return const Text(
                                      'Double',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  default:
                                    return const Text('');
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}s',
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY:
                                    queueSystem.singleResult?.avgWaitingTime ??
                                    0,
                                color: Colors.orange,
                                width: 40,
                                borderRadius: BorderRadius.circular(5),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY:
                                      _getMaxY(
                                        queueSystem
                                                .singleResult
                                                ?.avgWaitingTime ??
                                            0,
                                        queueSystem
                                                .doubleResult
                                                ?.avgWaitingTime ??
                                            0,
                                      ) *
                                      0.9,
                                  color: Colors.orange.shade100,
                                ),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY:
                                    queueSystem.doubleResult?.avgWaitingTime ??
                                    0,
                                color: Colors.green,
                                width: 40,
                                borderRadius: BorderRadius.circular(5),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY:
                                      _getMaxY(
                                        queueSystem
                                                .singleResult
                                                ?.avgWaitingTime ??
                                            0,
                                        queueSystem
                                                .doubleResult
                                                ?.avgWaitingTime ??
                                            0,
                                      ) *
                                      0.9,
                                  color: Colors.green.shade100,
                                ),
                              ),
                            ],
                          ),
                        ],
                        gridData: const FlGridData(show: true),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // رسم بياني لطول قائمة الانتظار مع الزمن لـ Single Server
                  if (queueSystem.singleResult != null &&
                      queueSystem.singleResult!.queueLengthHistory.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '⏳ Queue Length Over Time (Single Server)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: queueSystem
                                      .singleResult!
                                      .queueLengthHistory
                                      .asMap()
                                      .entries
                                      .map(
                                        (e) =>
                                            FlSpot(e.key.toDouble(), e.value),
                                      )
                                      .toList(),
                                  isCurved: true,
                                  color: Colors.orange,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.orange.withOpacity(0.1),
                                  ),
                                ),
                              ],
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}',
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}',
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                                drawVerticalLine: false,
                              ),
                              borderData: FlBorderData(show: false),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 25),

                  // زر تشغيل النظامين معًا
                  ElevatedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);

                            // تشغيل Single Server
                            queueSystem.runSimulationLive(
                              numCustomers: 50,
                              meanInterarrival: 2,
                              meanService: 3,
                              numServers: 1,
                            );

                            // نستنى شوية عشان السينجل يخلص
                            await Future.delayed(const Duration(seconds: 8));

                            // تشغيل Double Server
                            queueSystem.runSimulationLive(
                              numCustomers: 50,
                              meanInterarrival: 2,
                              meanService: 3,
                              numServers: 2,
                            );

                            // نستنى شوية عشان الدبل يخلص
                            await Future.delayed(const Duration(seconds: 8));

                            setState(() => _isLoading = false);

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '✅ Both systems simulated successfully! 🔥',
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                    icon: Icon(
                      _isLoading ? Icons.hourglass_empty : Icons.compare_arrows,
                    ),
                    label: Text(
                      _isLoading
                          ? 'Running Simulations...'
                          : 'Run Both Systems Together 🔥',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // رسالة توضيحية إذا لم توجد نتائج
                  if (queueSystem.singleResult == null &&
                      queueSystem.doubleResult == null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'No simulation results yet. Press the button above to run both systems and see comparison.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildComparisonRow(
    String label,
    double? single,
    double? doubleVal,
    String unit, {
    bool isPercentage = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Single',
                    style: TextStyle(color: Colors.orange.shade800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    single != null
                        ? (isPercentage
                              ? '${(single * 100).toStringAsFixed(1)}%'
                              : '${single.toStringAsFixed(2)} $unit')
                        : '—',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Double',
                    style: TextStyle(color: Colors.green.shade800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doubleVal != null
                        ? (isPercentage
                              ? '${(doubleVal * 100).toStringAsFixed(1)}%'
                              : '${doubleVal.toStringAsFixed(2)} $unit')
                        : '—',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY(double single, double doubleVal) {
    double max = single > doubleVal ? single : doubleVal;
    return max + 5;
  }
}
