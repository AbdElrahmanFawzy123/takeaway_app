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

  // متغيرات للمحاكاة
  int _nextCustomerIndex = 0;
  List<double> queueHistory = [];
  double _meanInterarrival = 0;
  double _meanService = 0;
  List<Timer> _activeTimers = []; // لتتبع التايمرز ومنع التسريب

  void reset() {
    // إلغاء كل التايمرز النشطة
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
    queueHistory.clear();
    _nextCustomerIndex = 0;
    isRunning = false;
    notifyListeners();
  }

  void _addLog(String message, String type) {
    eventLogs.add(EventLog(message: message, time: currentTime, type: type));
    notifyListeners();
  }

  // بدء المحاكاة الحية
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

    // إنشاء العملاء بزمن وصول حقيقي
    customers = [];
    double time = 0;
    for (int i = 0; i < numCustomers; i++) {
      time += _exponential(meanInterarrival);
      customers.add(Customer(id: i + 1, arrivalTime: time));
    }

    servers = List.generate(numServers, (i) => Server(id: i + 1));
    notifyListeners();

    // بدأ أول عميل
    _scheduleNextArrival();
  }

  // جدولة وصول العميل التالي
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

  // عميل جديد وصل
  void _arriveCustomer(int index) {
    if (!isRunning) return;

    Customer customer = customers[index];
    currentTime = customer.arrivalTime;

    _addLog('Customer ${customer.id} arrived 🚶', 'arrive');

    // ضيفه في الطابور
    queue.add(customer);
    _updateQueueDisplay();
    _tryStartService();
    notifyListeners();
  }

  // حاول تبدأ خدمة لأي سيرفر فاضي
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

        // تحديث واجهة المستخدم
        if (server.id == 1) {
          server1Status = "Busy";
          currentCustomerId1 = customer.id;
        } else if (server.id == 2) {
          server2Status = "Busy";
          currentCustomerId2 = customer.id;
        }

        _updateQueueDisplay();
        notifyListeners();

        // جدول انتهاء الخدمة بعد وقت الخدمة
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

  // عميل خلص خدمته
  void _finishService(int serverId, int customerId) {
    if (!isRunning) return;

    var server = servers.firstWhere((s) => s.id == serverId);

    _addLog(
      'Customer $customerId finished service on Server $serverId 🔴',
      'finish',
    );

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

    // بعد ما يخلص، نحاول نخدم عميل تاني
    _tryStartService();

    // نفحص لو المحاكاة خلصت
    _checkSimulationComplete();
  }

  // تحديث واجهة الطابور
  void _updateQueueDisplay() {
    currentQueueIds = queue.map((c) => c.id).toList();
    queueHistory.add(queue.length.toDouble());
    notifyListeners();
  }

  // نفحص لو كل العملاء اتعاملوا
  void _checkSimulationComplete() {
    bool allArrived = _nextCustomerIndex >= customers.length;
    bool allServed = servers.every((s) => !s.isBusy) && queue.isEmpty;

    if (allArrived && allServed && isRunning) {
      _endSimulation();
    }
  }

  // إنهاء المحاكاة وحساب النتائج
  void _endSimulation() {
    if (!isRunning) return;

    // حساب النتائج
    List<double> waitingTimes = customers.map((c) => c.waitingTime).toList();
    double avgWaiting =
        waitingTimes.reduce((a, b) => a + b) / waitingTimes.length;
    double avgService =
        customers.map((c) => c.serviceTime).toList().reduce((a, b) => a + b) /
        customers.length;
    double utilization =
        servers
            .map((s) => s.totalBusyTime / currentTime)
            .reduce((a, b) => a + b) /
        servers.length;
    int maxQueue = queueHistory.isEmpty
        ? 0
        : queueHistory.reduce((a, b) => a > b ? a : b).toInt();

    SimulationResult result = SimulationResult(
      systemType: servers.length == 1 ? "Single Server" : "Double Server",
      avgWaitingTime: avgWaiting,
      avgServiceTime: avgService,
      servedCustomers: customers.length,
      serverUtilization: utilization,
      maxQueueLength: maxQueue,
      queueLengthHistory: List.from(queueHistory), // 👈 تعديل هنا
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

  // التوزيع الأسي
  double _exponential(double mean) {
    double u = _random.nextDouble();
    while (u == 0) {
      u = _random.nextDouble();
    }
    return -mean * log(1 - u);
  }

  @override
  void dispose() {
    for (var timer in _activeTimers) {
      timer.cancel();
    }
    _activeTimers.clear();
    super.dispose();
  }
}
