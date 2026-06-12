
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/data/models/memory_item.dart';
import 'package:nexus_app/data/repositories/memory_repository.dart';

final memoryProvider = StateNotifierProvider<MemoryNotifier, AsyncValue<List<MemoryItem>>>((ref) {
  return MemoryNotifier(ref.read(memoryRepositoryProvider));
});

class MemoryNotifier extends StateNotifier<AsyncValue<List<MemoryItem>>> {
  final MemoryRepository _memoryRepository;

  MemoryNotifier(this._memoryRepository) : super(const AsyncValue.loading()) {
    _loadMemoryItems();
  }

  Future<void> _loadMemoryItems() async {
    try {
      final items = await _memoryRepository.getMemoryItems();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addMemoryItem(MemoryItem item) async {
    state = const AsyncValue.loading();
    try {
      await _memoryRepository.addMemoryItem(item);
      await _loadMemoryItems();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMemoryItem(int id) async {
    state = const AsyncValue.loading();
    try {
      await _memoryRepository.deleteMemoryItem(id);
      await _loadMemoryItems();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
