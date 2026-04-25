import 'package:takeaway_app/models/customer.dart';

class Server {
  final int id;
  bool isBusy;
  Customer? currentCustomer;
  double totalBusyTime;
  int servedCustomers;

  Server({
    required this.id,
    this.isBusy = false,
    this.currentCustomer,
    this.totalBusyTime = 0,
    this.servedCustomers = 0,
  });

  double get utilization =>
      totalBusyTime / (DateTime.now().millisecondsSinceEpoch.toDouble());
}
