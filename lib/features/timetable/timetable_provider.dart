
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/data/models/timetable_entry.dart';
import 'package:nexus_app/data/repositories/timetable_repository.dart';

final timetableProvider = StateNotifierProvider<TimetableNotifier, AsyncValue<List<TimetableEntry>>>((ref) {
  return TimetableNotifier(ref.read(timetableRepositoryProvider));
});

class TimetableNotifier extends StateNotifier<AsyncValue<List<TimetableEntry>>> {
  final TimetableRepository _timetableRepository;

  TimetableNotifier(this._timetableRepository) : super(const AsyncValue.loading()) {
    _loadTimetableEntries();
  }

  Future<void> _loadTimetableEntries() async {
    try {
      final entries = await _timetableRepository.getTimetableEntries();
      state = AsyncValue.data(entries);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTimetableEntry(TimetableEntry entry) async {
    state = const AsyncValue.loading();
    try {
      await _timetableRepository.addTimetableEntry(entry);
      await _loadTimetableEntries();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTimetableEntry(int id) async {
    state = const AsyncValue.loading();
    try {
      await _timetableRepository.deleteTimetableEntry(id);
      await _loadTimetableEntries();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
