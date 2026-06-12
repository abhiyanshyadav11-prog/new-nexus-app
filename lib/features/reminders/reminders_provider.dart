
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/data/models/reminder.dart';
import 'package:nexus_app/data/repositories/reminder_repository.dart';
import 'package:nexus_app/services/notification_service.dart';

final remindersProvider = StateNotifierProvider<RemindersNotifier, AsyncValue<List<Reminder>>>((ref) {
  return RemindersNotifier(ref.read(reminderRepositoryProvider), ref.read(notificationServiceProvider));
});

class RemindersNotifier extends StateNotifier<AsyncValue<List<Reminder>>> {
  final ReminderRepository _reminderRepository;
  final NotificationService _notificationService;

  RemindersNotifier(this._reminderRepository, this._notificationService) : super(const AsyncValue.loading()) {
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    try {
      final reminders = await _reminderRepository.getReminders();
      state = AsyncValue.data(reminders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addReminder(Reminder reminder) async {
    state = const AsyncValue.loading();
    try {
      await _reminderRepository.addReminder(reminder);
      await _notificationService.scheduleNotification(
        id: reminder.hashCode, // Simple ID for now
        title: reminder.title,
        body: reminder.description,
        scheduledDate: reminder.dateTime,
      );
      await _loadReminders();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteReminder(int id) async {
    state = const AsyncValue.loading();
    try {
      await _reminderRepository.deleteReminder(id);
      await _notificationService.cancelNotification(id.hashCode);
      await _loadReminders();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
