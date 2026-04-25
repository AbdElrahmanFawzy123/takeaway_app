import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../models/server.dart';
import '../models/simulation_result.dart';
import '../models/event_log.dart';

class QueueSystem extends ChangeNotifier {
  final Random _random = Random();

  List<Customer> customers = [];
  List<Server> servers = [];
  List<Customer> queue = [];
  double currentTime = 0;
  bool isRunning = false;

  SimulationResult? singleResult;
  SimulationResult? doubleResult;

  List<int> currentQueueIds = [];
  String server1Status = "Idle";
  String server2Status = "Idle";
  int? currentCustomerId1;
  int? currentCustomerId2;
  List<EventLog> eventLogs = [];

  int _nextCustomerIndex = 0;
  List<double> _queueHistory = [];
  double _meanInterarrival = 0;
  double _meanService = 0;
  final List<Timer> _activeTimers = [];

  void reset() {
    for (var timer in _activeTimers) {
      timer.cancel();
    }
    _activeTimers.clear();

    customers.clear();
    servers.clear();
    queue.clear();
    currentTime = 0;
    currentQueueIds.clear();
    server1Status = "Idle";
    server2Status = "Idle";
    currentCustomerId1 = null;
    currentCustomerId2 = null;
    eventLogs.clear();
    _queueHistory.clear();
    _nextCustomerIndex = 0;
    isRunning = false;
    notifyListeners();
  }

  void _addLog(String message, String type) {
    eventLogs.add(EventLog(message: message, time: currentTime, type: type));
    notifyListeners();
  }

  void runSimulationLive({
    required int numCustomers,
    required double meanInterarrival,
    required double meanService,
    required int numServers,
  }) {
    reset();
    isRunning = true;
    _meanInterarrival = meanInterarrival;
    _meanService = meanService;
    _nextCustomerIndex = 0;
    currentTime = 0;

    customers = [];
    double time = 0;
    for (int i = 0; i < numCustomers; i++) {
      time += _exponential(meanInterarrival);
      customers.add(Customer(id: i + 1, arrivalTime: time));
    }

    servers = List.generate(numServers, (i) => Server(id: i + 1));
    notifyListeners();

    _scheduleNextArrival();
  }

  void _scheduleNextArrival() {
    if (!isRunning) return;

    if (_nextCustomerIndex < customers.length) {
      Customer nextCustomer = customers[_nextCustomerIndex];
      double waitTime = nextCustomer.arrivalTime - currentTime;
      if (waitTime < 0) waitTime = 0;

      Timer timer = Timer(
        Duration(milliseconds: (waitTime * 1000).toInt()),
        () {
          if (!isRunning) return;
          _arriveCustomer(_nextCustomerIndex);
          _nextCustomerIndex++;
          _scheduleNextArrival();
        },
      );
      _activeTimers.add(timer);
    }
  }

  void _arriveCustomer(int index) {
    if (!isRunning) return;

    Customer customer = customers[index];
    currentTime = customer.arrivalTime;
    _addLog('Customer ${customer.id} arrived 🚶‍♂️', 'arrive');

    queue.add(customer);
    _updateQueueDisplay();
    _tryStartService();
    notifyListeners();
  }

  void _tryStartService() {
    for (var server in servers) {
      if (!server.isBusy && queue.isNotEmpty) {
        Customer customer = queue.removeAt(0);
        server.isBusy = true;
        server.currentCustomer = customer;
        customer.serviceStartTime = currentTime;

        double serviceTime = _exponential(_meanService);
        customer.serviceEndTime = currentTime + serviceTime;
        server.totalBusyTime += serviceTime;
        server.servedCustomers++;

        _addLog(
          'Customer ${customer.id} started service on Server ${server.id} 🟢',
          'start',
        );

        if (server.id == 1) {
          server1Status = "Busy";
          currentCustomerId1 = customer.id;
        } else if (server.id == 2) {
          server2Status = "Busy";
          currentCustomerId2 = customer.id;
        }

        _updateQueueDisplay();
        notifyListeners();

        Timer timer = Timer(
          Duration(milliseconds: (serviceTime * 1000).toInt()),
          () {
            if (!isRunning) return;
            _finishService(server.id, customer.id);
          },
        );
        _activeTimers.add(timer);
      }
    }
  }

  void _finishService(int serverId, int customerId) {
    if (!isRunning) return;

    var server = servers.firstWhere((s) => s.id == serverId);
    _addLog('Customer $customerId finished service on Server $serverId 🔴',
        'finish');

    server.isBusy = false;
    server.currentCustomer = null;

    if (serverId == 1) {
      server1Status = "Idle";
      currentCustomerId1 = null;
    } else if (serverId == 2) {
      server2Status = "Idle";
      currentCustomerId2 = null;
    }

    notifyListeners();
    _tryStartService();
    _checkSimulationComplete();
  }

  void _updateQueueDisplay() {
    currentQueueIds = queue.map((c) => c.id).toList();
    _queueHistory.add(queue.length.toDouble());
    notifyListeners();
  }

  void _checkSimulationComplete() {
    bool allArrived = _nextCustomerIndex >= customers.length;
    bool allServed = servers.every((s) => !s.isBusy) && queue.isEmpty;

    if (allArrived && allServed && isRunning) {
      _endSimulation();
    }
  }

  void _endSimulation() {
    if (!isRunning) return;

    List<double> waitingTimes = customers.map((c) => c.waitingTime).toList();
    double avgWaiting =
        waitingTimes.reduce((a, b) => a + b) / waitingTimes.length;
    double avgService =
        customers.map((c) => c.serviceTime).toList().reduce((a, b) => a + b) /
            customers.length;

    double totalUtilization = 0;
    for (var server in servers) {
      totalUtilization += server.getUtilization(currentTime);
    }
    double utilization = totalUtilization / servers.length;

    int maxQueue = _queueHistory.isEmpty
        ? 0
        : _queueHistory.reduce((a, b) => a > b ? a : b).toInt();

    SimulationResult result = SimulationResult(
      systemType: servers.length == 1 ? "Single Server" : "Double Server",
      avgWaitingTime: avgWaiting,
      avgServiceTime: avgService,
      servedCustomers: customers.length,
      serverUtilization: utilization,
      maxQueueLength: maxQueue,
      queueLengthHistory: List.from(_queueHistory),
      waitingTimes: waitingTimes,
    );

    if (servers.length == 1) {
      singleResult = result;
    } else {
      doubleResult = result;
    }

    isRunning = false;
    notifyListeners();
  }

  double _exponential(double mean) {
    double u = _random.nextDouble();
    while (u == 0) {
      u = _random.nextDouble();
    }
    return -mean * log(1 - u);
  }

  SimulationResult calculateResultsFast({
    required int numCustomers,
    required double meanInterarrival,
    required double meanService,
    required int numServers,
  }) {
    List<Customer> simCustomers = [];
    double t = 0;
    for (int i = 0; i < numCustomers; i++) {
      t += _exponential(meanInterarrival);
      simCustomers.add(Customer(id: i + 1, arrivalTime: t));
    }

    List<double> freeAt = List.filled(numServers, 0.0);
    List<double> qHistory = [];
    int maxQ = 0;
    double totalBusyTime = 0;

    for (var c in simCustomers) {
      freeAt.sort();
      double earliestFree = freeAt[0];

      if (earliestFree > c.arrivalTime) {
        c.serviceStartTime = earliestFree;
        maxQ = max(
            maxQ,
            simCustomers
                .where((x) =>
                    x.arrivalTime <= earliestFree &&
                    (x.serviceStartTime == null ||
                        x.serviceStartTime! >= earliestFree))
                .length);
      } else {
        c.serviceStartTime = c.arrivalTime;
      }

      double serviceTime = _exponential(meanService);
      c.serviceEndTime = c.serviceStartTime! + serviceTime;
      freeAt[0] = c.serviceEndTime!;
      totalBusyTime += serviceTime;

      qHistory
          .add((c.serviceStartTime! > c.arrivalTime) ? maxQ.toDouble() : 0.0);
    }

    double finalTime = freeAt.reduce(max);
    double avgWait =
        simCustomers.fold(0.0, (sum, c) => sum + c.waitingTime) / numCustomers;
    double avgServ =
        simCustomers.fold(0.0, (sum, c) => sum + c.serviceTime) / numCustomers;
    double util = (totalBusyTime / numServers) / finalTime;

    return SimulationResult(
      systemType: numServers == 1 ? "Single Server" : "Double Server",
      avgWaitingTime: avgWait,
      avgServiceTime: avgServ,
      servedCustomers: numCustomers,
      serverUtilization: util,
      maxQueueLength: maxQ,
      queueLengthHistory: qHistory,
      waitingTimes: simCustomers.map((c) => c.waitingTime).toList(),
    );
  }

  bool get hasBothResults => singleResult != null && doubleResult != null;

  @override
  void dispose() {
    for (var timer in _activeTimers) {
      timer.cancel();
    }
    _activeTimers.clear();
    super.dispose();
  }
}
