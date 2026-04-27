import 'dart:io';
import 'dart:math' as math;
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
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
      var excel = Excel.createExcel();

      var summarySheet = excel['Summary'];
      summarySheet.appendRow([TextCellValue('Takeaway Simulation Report')]);
      summarySheet.appendRow(
          [TextCellValue('Generated: ${DateTime.now().toString()}')]);
      summarySheet.appendRow([]);

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

      var queueSheet = excel['Queue History'];
      queueSheet.appendRow(
          [TextCellValue('Time Step'), TextCellValue('Queue Length')]);

      for (int i = 0; i < result.queueLengthHistory.length; i++) {
        queueSheet.appendRow([
          IntCellValue(i),
          IntCellValue(result.queueLengthHistory[i].toInt())
        ]);
      }

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

      final directory = await getTemporaryDirectory();
      final fileName =
          'simulation_report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final filePath = '${directory.path}/$fileName';
      debugPrint('📁 Saving to: $filePath');

      final fileBytes = excel.save();
      if (fileBytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(fileBytes, flush: true);
        debugPrint('✅ File saved successfully!');

        try {
          final downloadsDir = await getDownloadsDirectory();
          if (downloadsDir != null) {
            final finalPath = '${downloadsDir.path}/$fileName';
            await file.copy(finalPath);
            debugPrint('✅ Also saved to downloads: $finalPath');
            return finalPath;
          }
        } catch (e) {
          debugPrint('⚠️ Could not save to downloads: $e');
        }

        return filePath;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Excel Export Error: $e');
      return null;
    }
  }

  static Future<void> openExcelFile(String filePath) async {
    debugPrint('📂 Trying to open Excel file: $filePath');

    try {
      final result = await OpenFile.open(filePath);

      debugPrint('📂 Open result: ${result.type} - ${result.message}');

      if (result.type != ResultType.done) {
        debugPrint('⚠️ OpenFile failed: ${result.message}');

        await _shareExcelFile(filePath);
      }
    } catch (e) {
      debugPrint('❌ Exception while opening file: $e');

      await _shareExcelFile(filePath);
    }
  }

  static Future<void> _shareExcelFile(String filePath) async {
    debugPrint('📤 Opening share sheet instead...');

    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Simulation Excel Report',
      );
    } catch (e) {
      debugPrint('❌ Share failed: $e');
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
