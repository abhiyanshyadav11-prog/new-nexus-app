
import 'package:nexus_app/data/database/database_helper.dart';
import 'package:nexus_app/data/models/timetable_entry.dart';

class TimetableDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertTimetableEntry(TimetableEntry entry) async {
    final db = await _dbHelper.database;
    return await db.insert('timetable_entries', entry.toMap());
  }

  Future<List<TimetableEntry>> getTimetableEntries() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('timetable_entries');
    return List.generate(maps.length, (i) {
      return TimetableEntry.fromMap(maps[i]);
    });
  }

  Future<int> updateTimetableEntry(TimetableEntry entry) async {
    final db = await _dbHelper.database;
    return await db.update(
      'timetable_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteTimetableEntry(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'timetable_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
