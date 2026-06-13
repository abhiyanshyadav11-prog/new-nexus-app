
import 'package:nexus_app/data/database/database_helper.dart';
import 'package:nexus_app/data/models/reminder.dart';

class ReminderDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertReminder(Reminder reminder) async {
    final db = await _dbHelper.database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> getReminders() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) {
      return Reminder.fromMap(maps[i]);
    });
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await _dbHelper.database;
    return await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
