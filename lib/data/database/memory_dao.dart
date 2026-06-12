
import 'package:sqflite/sqflite.dart';
import 'package:nexus_app/data/database/database_helper.dart';
import 'package:nexus_app/data/models/memory_item.dart';

class MemoryDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertMemoryItem(MemoryItem item) async {
    final db = await _dbHelper.database;
    return await db.insert('memory_items', item.toMap());
  }

  Future<List<MemoryItem>> getMemoryItems() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('memory_items');
    return List.generate(maps.length, (i) {
      return MemoryItem.fromMap(maps[i]);
    });
  }

  Future<int> updateMemoryItem(MemoryItem item) async {
    final db = await _dbHelper.database;
    return await db.update(
      'memory_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteMemoryItem(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'memory_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
