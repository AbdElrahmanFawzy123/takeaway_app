class EventLog {
  final String message;
  final double time;
  final String type; // 'arrive', 'start', 'finish'

  EventLog({required this.message, required this.time, required this.type});
}
