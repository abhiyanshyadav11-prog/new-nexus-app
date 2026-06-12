
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/data/database/reminder_dao.dart';
import 'package:nexus_app/data/models/reminder.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) => ReminderRepository(ref.read(reminderDaoProvider)));

final reminderDaoProvider = Provider<ReminderDao>((ref) => ReminderDao());

class ReminderRepository {
  final ReminderDao _reminderDao;

  ReminderRepository(this._reminderDao);

  Future<int> addReminder(Reminder reminder) async {
    return await _reminderDao.insertReminder(reminder);
  }

  Future<List<Reminder>> getReminders() async {
    return await _reminderDao.getReminders();
  }

  Future<int> updateReminder(Reminder reminder) async {
    return await _reminderDao.updateReminder(reminder);
  }

  Future<int> deleteReminder(int id) async {
    return await _reminderDao.deleteReminder(id);
  }
}
