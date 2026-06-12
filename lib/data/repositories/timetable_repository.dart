
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/data/database/timetable_dao.dart';
import 'package:nexus_app/data/models/timetable_entry.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) => TimetableRepository(ref.read(timetableDaoProvider)));

final timetableDaoProvider = Provider<TimetableDao>((ref) => TimetableDao());

class TimetableRepository {
  final TimetableDao _timetableDao;

  TimetableRepository(this._timetableDao);

  Future<int> addTimetableEntry(TimetableEntry entry) async {
    return await _timetableDao.insertTimetableEntry(entry);
  }

  Future<List<TimetableEntry>> getTimetableEntries() async {
    return await _timetableDao.getTimetableEntries();
  }

  Future<int> updateTimetableEntry(TimetableEntry entry) async {
    return await _timetableDao.updateTimetableEntry(entry);
  }

  Future<int> deleteTimetableEntry(int id) async {
    return await _timetableDao.deleteTimetableEntry(id);
  }
}
