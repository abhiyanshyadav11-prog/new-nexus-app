
class CommandLog {
  int? id;
  String command;
  DateTime timestamp;
  String status;

  CommandLog({
    this.id,
    required this.command,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'command': command,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  factory CommandLog.fromMap(Map<String, dynamic> map) {
    return CommandLog(
      id: map['id'],
      command: map['command'],
      timestamp: DateTime.parse(map['timestamp']),
      status: map['status'],
    );
  }
}
