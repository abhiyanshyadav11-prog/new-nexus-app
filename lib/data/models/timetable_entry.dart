
class TimetableEntry {
  int? id;
  String title;
  int dayOfWeek; // 0 for Monday, 6 for Sunday
  String startTime;
  String endTime;

  TimetableEntry({
    this.id,
    required this.title,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory TimetableEntry.fromMap(Map<String, dynamic> map) {
    return TimetableEntry(
      id: map['id'],
      title: map['title'],
      dayOfWeek: map['dayOfWeek'],
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }
}
