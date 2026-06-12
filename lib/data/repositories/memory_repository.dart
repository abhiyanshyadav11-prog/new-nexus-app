
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/data/database/memory_dao.dart';
import 'package:nexus_app/data/models/memory_item.dart';

final memoryRepositoryProvider = Provider<MemoryRepository>((ref) => MemoryRepository(ref.read(memoryDaoProvider)));

final memoryDaoProvider = Provider<MemoryDao>((ref) => MemoryDao());

class MemoryRepository {
  final MemoryDao _memoryDao;

  MemoryRepository(this._memoryDao);

  Future<int> addMemoryItem(MemoryItem item) async {
    return await _memoryDao.insertMemoryItem(item);
  }

  Future<List<MemoryItem>> getMemoryItems() async {
    return await _memoryDao.getMemoryItems();
  }

  Future<int> updateMemoryItem(MemoryItem item) async {
    return await _memoryDao.updateMemoryItem(item);
  }

  Future<int> deleteMemoryItem(int id) async {
    return await _memoryDao.deleteMemoryItem(id);
  }
}
