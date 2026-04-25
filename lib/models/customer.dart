class Customer {
  final int id;
  final double arrivalTime;
  double? serviceStartTime;
  double? serviceEndTime;

  Customer({required this.id, required this.arrivalTime});

  double get waitingTime => (serviceStartTime ?? 0) - arrivalTime;
  double get serviceTime => (serviceEndTime ?? 0) - (serviceStartTime ?? 0);
}
