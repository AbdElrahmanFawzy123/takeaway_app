class SimulationResult {
  final String systemType;
  final double avgWaitingTime;
  final double avgServiceTime;
  final int servedCustomers;
  final double serverUtilization;
  final int maxQueueLength;
  final List<double> queueLengthHistory;
  final List<double> waitingTimes;

  SimulationResult({
    required this.systemType,
    required this.avgWaitingTime,
    required this.avgServiceTime,
    required this.servedCustomers,
    required this.serverUtilization,
    required this.maxQueueLength,
    required this.queueLengthHistory,
    required this.waitingTimes,
  });
}
