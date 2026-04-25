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

  // ✅ تم تصحيح الدالة - هتاخد currentTime كـ parameter
  double getUtilization(double currentTime) {
    if (currentTime == 0) return 0;
    return totalBusyTime / currentTime;
  }
}
