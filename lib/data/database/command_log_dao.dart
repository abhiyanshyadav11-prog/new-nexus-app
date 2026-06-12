
import 'package:sqflite/sqflite.dart';
import 'package:nexus_app/data/database/database_helper.dart';
import 'package:nexus_app/data/models/command_log.dart';

class CommandLogDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertCommandLog(CommandLog log) async {
    final db = await _dbHelper.database;
    return await db.insert('command_logs', log.toMap());
  }

  Future<List<CommandLog>> getCommandLogs() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('command_logs');
    return List.generate(maps.length, (i) {
      return CommandLog.fromMap(maps[i]);
    });
  }

  Future<int> deleteCommandLog(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'command_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
