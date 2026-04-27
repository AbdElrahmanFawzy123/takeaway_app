import 'dart:io';
import 'dart:math' as math;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../models/simulation_result.dart';
import '../models/event_log.dart';
import '../models/customer.dart';

class ExportService {
  static Future<String?> exportSimulationToExcel({
    required SimulationResult result,
    required List<EventLog> eventLogs,
    required List<Customer> customers,
    required double currentTime,
    required int numServers,
  }) async {
    try {
      print('📊 Starting Excel export...');
      print('📊 Customers: ${customers.length}, Events: ${eventLogs.length}');

      // إنشاء ملف Excel جديد
      var excel = Excel.createExcel();

      // ==================== SHEET 1: SUMMARY ====================
      var summarySheet = excel['Summary'];
      summarySheet.appendRow([TextCellValue('Takeaway Simulation Report')]);
      summarySheet.appendRow(
          [TextCellValue('Generated: ${DateTime.now().toString()}')]);
      summarySheet.appendRow([]);

      // System Configuration
      summarySheet.appendRow([TextCellValue('SYSTEM CONFIGURATION')]);
      summarySheet.appendRow(
          [TextCellValue('System Type'), TextCellValue(result.systemType)]);
      summarySheet.appendRow(
          [TextCellValue('Number of Servers'), IntCellValue(numServers)]);
      summarySheet.appendRow([
        TextCellValue('Number of Customers'),
        IntCellValue(result.servedCustomers)
      ]);
      summarySheet.appendRow([
        TextCellValue('Total Simulation Time'),
        TextCellValue('${currentTime.toStringAsFixed(2)} sec')
      ]);
      summarySheet.appendRow([]);

      // Performance Metrics
      summarySheet.appendRow([TextCellValue('PERFORMANCE METRICS')]);
      summarySheet.appendRow([
        TextCellValue('Average Waiting Time'),
        TextCellValue('${result.avgWaitingTime.toStringAsFixed(2)} sec')
      ]);
      summarySheet.appendRow([
        TextCellValue('Average Service Time'),
        TextCellValue('${result.avgServiceTime.toStringAsFixed(2)} sec')
      ]);
      summarySheet.appendRow([
        TextCellValue('Server Utilization'),
        TextCellValue('${(result.serverUtilization * 100).toStringAsFixed(1)}%')
      ]);
      summarySheet.appendRow([
        TextCellValue('Maximum Queue Length'),
        IntCellValue(result.maxQueueLength)
      ]);
      summarySheet.appendRow([]);

      // ==================== SHEET 2: CUSTOMER DETAILS ====================
      var customerSheet = excel['Customer Details'];
      customerSheet.appendRow([
        TextCellValue('Customer ID'),
        TextCellValue('Arrival Time (sec)'),
        TextCellValue('Waiting Time (sec)'),
        TextCellValue('Service Time (sec)')
      ]);

      for (int i = 0; i < customers.length; i++) {
        final customer = customers[i];
        customerSheet.appendRow([
          IntCellValue(customer.id),
          DoubleCellValue(customer.arrivalTime),
          DoubleCellValue(customer.waitingTime),
          DoubleCellValue(customer.serviceTime),
        ]);
      }

      // ==================== SHEET 3: QUEUE HISTORY ====================
      var queueSheet = excel['Queue History'];
      queueSheet.appendRow(
          [TextCellValue('Time Step'), TextCellValue('Queue Length')]);

      for (int i = 0; i < result.queueLengthHistory.length; i++) {
        queueSheet.appendRow([
          IntCellValue(i),
          IntCellValue(result.queueLengthHistory[i].toInt())
        ]);
      }

      // ==================== SHEET 4: EVENT LOG ====================
      var eventSheet = excel['Event Log'];
      eventSheet.appendRow([
        TextCellValue('Time (sec)'),
        TextCellValue('Event Type'),
        TextCellValue('Event Message')
      ]);

      for (var log in eventLogs) {
        String eventType = '';
        switch (log.type) {
          case 'arrive':
            eventType = 'ARRIVAL';
            break;
          case 'start':
            eventType = 'SERVICE START';
            break;
          case 'finish':
            eventType = 'SERVICE END';
            break;
          default:
            eventType = 'INFO';
        }
        eventSheet.appendRow([
          DoubleCellValue(log.time),
          TextCellValue(eventType),
          TextCellValue(log.message)
        ]);
      }

      // ==================== SHEET 5: STATISTICS ====================
      var statsSheet = excel['Statistics'];
      statsSheet.appendRow([TextCellValue('STATISTICAL SUMMARY')]);
      statsSheet.appendRow([]);

      List<double> waitingTimes = List.from(result.waitingTimes);
      if (waitingTimes.isNotEmpty) {
        waitingTimes.sort();
        double sum = waitingTimes.reduce((a, b) => a + b);
        double mean = sum / waitingTimes.length;
        double variance = waitingTimes
                .map((w) => math.pow(w - mean, 2))
                .reduce((a, b) => a + b) /
            waitingTimes.length;
        double stdDev = math.sqrt(variance);

        statsSheet.appendRow([
          TextCellValue('Minimum Waiting Time'),
          TextCellValue('${waitingTimes.first.toStringAsFixed(2)} sec')
        ]);
        statsSheet.appendRow([
          TextCellValue('Maximum Waiting Time'),
          TextCellValue('${waitingTimes.last.toStringAsFixed(2)} sec')
        ]);
        statsSheet.appendRow([
          TextCellValue('Median Waiting Time'),
          TextCellValue(
              '${waitingTimes[waitingTimes.length ~/ 2].toStringAsFixed(2)} sec')
        ]);
        statsSheet.appendRow([
          TextCellValue('Standard Deviation'),
          TextCellValue('${stdDev.toStringAsFixed(2)} sec')
        ]);
        statsSheet.appendRow([
          TextCellValue('Average Waiting Time'),
          TextCellValue('${mean.toStringAsFixed(2)} sec')
        ]);
        statsSheet.appendRow([
          TextCellValue('Total Waiting Time'),
          TextCellValue('${sum.toStringAsFixed(2)} sec')
        ]);
      }

      // ==================== SAVE FILE ====================
      final directory = await getTemporaryDirectory();
      final fileName =
          'simulation_report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final filePath = '${directory.path}/$fileName';
      print('📁 Saving to: $filePath');

      final fileBytes = excel.save();
      if (fileBytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(fileBytes, flush: true);
        print('✅ File saved successfully!');

        // محاولة النسخ إلى مجلد التنزيلات
        try {
          final downloadsDir = await getDownloadsDirectory();
          if (downloadsDir != null) {
            final finalPath = '${downloadsDir.path}/$fileName';
            await file.copy(finalPath);
            print('✅ Also saved to downloads: $finalPath');
            return finalPath;
          }
        } catch (e) {
          print('⚠️ Could not save to downloads: $e');
        }

        return filePath;
      }

      return null;
    } catch (e) {
      print('❌ Excel Export Error: $e');
      return null;
    }
  }

  static Future<void> openExcelFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    print('📂 Open result: ${result.type} - ${result.message}');
    if (result.type != ResultType.done) {
      print('⚠️ Could not open file: ${result.message}');
    }
  }

  static Future<bool> exportAndOpen({
    required SimulationResult result,
    required List<EventLog> eventLogs,
    required List<Customer> customers,
    required double currentTime,
    required int numServers,
  }) async {
    String? filePath = await exportSimulationToExcel(
      result: result,
      eventLogs: eventLogs,
      customers: customers,
      currentTime: currentTime,
      numServers: numServers,
    );

    if (filePath != null) {
      await openExcelFile(filePath);
      return true;
    }
    return false;
  }
}
