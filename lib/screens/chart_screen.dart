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
      backgroundColor: const Color(0xFF0A0A0C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0C),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 18),
          ),
        ),
        title: const Text(
          'Comparison & Charts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFFF8C00)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Running Simulations...',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 Performance Comparison',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  _buildComparisonCard(
                    'Average Waiting Time',
                    queueSystem.singleResult?.avgWaitingTime,
                    queueSystem.doubleResult?.avgWaitingTime,
                    'sec',
                  ),
                  const SizedBox(height: 12),
                  _buildComparisonCard(
                    'Server Utilization',
                    queueSystem.singleResult?.serverUtilization,
                    queueSystem.doubleResult?.serverUtilization,
                    '%',
                    isPercentage: true,
                  ),
                  const SizedBox(height: 12),
                  _buildComparisonCard(
                    'Max Queue Length',
                    queueSystem.singleResult?.maxQueueLength?.toDouble(),
                    queueSystem.doubleResult?.maxQueueLength?.toDouble(),
                    'customers',
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    '📈 Average Waiting Time',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: const Color(0xFF121215),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    padding: const EdgeInsets.all(20),
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
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Single',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  case 1:
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Double',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold),
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
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.white54),
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
                                toY: queueSystem.singleResult?.avgWaitingTime ??
                                    0,
                                color: const Color(0xFFFF8C00),
                                width: 35,
                                borderRadius: BorderRadius.circular(6),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: _getMaxY(
                                        queueSystem
                                                .singleResult?.avgWaitingTime ??
                                            0,
                                        queueSystem
                                                .doubleResult?.avgWaitingTime ??
                                            0,
                                      ) *
                                      0.9,
                                  color: Colors.white.withOpacity(0.05),
                                ),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: queueSystem.doubleResult?.avgWaitingTime ??
                                    0,
                                color: const Color(0xFF44DD88),
                                width: 35,
                                borderRadius: BorderRadius.circular(6),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: _getMaxY(
                                        queueSystem
                                                .singleResult?.avgWaitingTime ??
                                            0,
                                        queueSystem
                                                .doubleResult?.avgWaitingTime ??
                                            0,
                                      ) *
                                      0.9,
                                  color: Colors.white.withOpacity(0.05),
                                ),
                              ),
                            ],
                          ),
                        ],
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.white.withOpacity(0.05),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  if (queueSystem.singleResult != null &&
                      queueSystem.singleResult!.queueLengthHistory.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⏳ Queue Length (Single Server)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: const Color(0xFF121215),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.05)),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: queueSystem
                                      .singleResult!.queueLengthHistory
                                      .asMap()
                                      .entries
                                      .map(
                                        (e) =>
                                            FlSpot(e.key.toDouble(), e.value),
                                      )
                                      .toList(),
                                  isCurved: true,
                                  color: const Color(0xFFFF8C00),
                                  barWidth: 3,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: const Color(0xFFFF8C00)
                                        .withOpacity(0.1),
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
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          '${value.toInt()}',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white54),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.white54),
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
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.white.withOpacity(0.05),
                                  strokeWidth: 1,
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () async {
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

                            if (mounted) {
                              setState(() => _isLoading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '✅ Both systems simulated successfully! 🔥',
                                  ),
                                  backgroundColor: Color(0xFF44DD88),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B00).withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isLoading
                                ? Icons.hourglass_empty
                                : Icons.compare_arrows,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _isLoading
                                ? 'Running Simulations...'
                                : 'Run Both Systems Together 🔥',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (queueSystem.singleResult == null &&
                      queueSystem.doubleResult == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8C00).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFFF8C00).withOpacity(0.2),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Color(0xFFFF8C00), size: 24),
                            SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'No simulation results yet. Press the button above to run both systems and see comparison.',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                    height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildComparisonCard(
    String label,
    double? single,
    double? doubleVal,
    String unit, {
    bool isPercentage = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121215),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C00).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text('Single',
                      style: TextStyle(
                          fontSize: 11, color: Colors.white.withOpacity(0.6))),
                  const SizedBox(height: 4),
                  Text(
                    single != null
                        ? (isPercentage
                            ? '${(single * 100).toStringAsFixed(1)}%'
                            : '${single.toStringAsFixed(2)}$unit')
                        : '—',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Color(0xFFFF8C00),
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF44DD88).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text('Double',
                      style: TextStyle(
                          fontSize: 11, color: Colors.white.withOpacity(0.6))),
                  const SizedBox(height: 4),
                  Text(
                    doubleVal != null
                        ? (isPercentage
                            ? '${(doubleVal * 100).toStringAsFixed(1)}%'
                            : '${doubleVal.toStringAsFixed(2)}$unit')
                        : '—',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Color(0xFF44DD88),
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
