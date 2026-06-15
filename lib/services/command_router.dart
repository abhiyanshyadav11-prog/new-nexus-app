import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/core/utils/logger.dart';
import 'package:nexus_app/data/models/laptop_command.dart';
import 'package:nexus_app/data/models/reminder.dart';
import 'package:nexus_app/data/models/memory_item.dart';
import 'package:nexus_app/data/repositories/reminder_repository.dart';
import 'package:nexus_app/data/repositories/memory_repository.dart';
import 'package:nexus_app/data/repositories/timetable_repository.dart';
import 'package:nexus_app/services/ble_service.dart';
import 'package:nexus_app/services/laptop_api_service.dart';
import 'package:nexus_app/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

final commandRouterProvider = Provider<CommandRouter>((ref) {
  return CommandRouter(
    bleService: ref.read(bleServiceProvider),
    laptopApiService: ref.read(laptopApiServiceProvider),
    reminderRepository: ref.read(reminderRepositoryProvider),
    memoryRepository: ref.read(memoryRepositoryProvider),
    timetableRepository: ref.read(timetableRepositoryProvider),
    notificationService: ref.read(notificationServiceProvider),
  );
});

class CommandRouter {
  final BleService _bleService;
  final LaptopApiService _laptopApiService;
  final ReminderRepository _reminderRepository;
  final MemoryRepository _memoryRepository;
  final TimetableRepository _timetableRepository;
  final NotificationService _notificationService;

  CommandRouter({
    required BleService bleService,
    required LaptopApiService laptopApiService,
    required ReminderRepository reminderRepository,
    required MemoryRepository memoryRepository,
    required TimetableRepository timetableRepository,
    required NotificationService notificationService,
  })
      : _bleService = bleService,
        _laptopApiService = laptopApiService,
        _reminderRepository = reminderRepository,
        _memoryRepository = memoryRepository,
        _timetableRepository = timetableRepository,
        _notificationService = notificationService;

  Future<void> routeCommand(String commandText) async {
    logger.i('Routing command: $commandText');

    // Simple rule-based intent parsing for MVP
    if (commandText.toLowerCase().contains('set reminder for')) {
      _handleSetReminder(commandText);
    } else if (commandText.toLowerCase().contains('remember this')) {
      _handleRememberThis(commandText);
    } else if (commandText.toLowerCase() == 'open chrome') {
      _openChrome();
    }  else if (commandText.toLowerCase().contains('open')) {
      _handleLaptopCommand('open_app', {'app_name': commandText.split('open ')[1]});
    } else if (commandText.toLowerCase().contains('play')) {
      _handleLaptopCommand('media_control', {'action': 'play', 'query': commandText.split('play ')[1]});
    } else if (commandText.toLowerCase().contains('pause')) {
      _handleLaptopCommand('media_control', {'action': 'pause'});
    } else if (commandText.toLowerCase().contains('next song')) {
      _handleLaptopCommand('media_control', {'action': 'next'});
    } else if (commandText.toLowerCase().contains('previous song')) {
      _handleLaptopCommand('media_control', {'action': 'previous'});
    } else if (commandText.toLowerCase().contains('volume up')) {
      _handleLaptopCommand('system_control', {'action': 'volume_up'});
    } else if (commandText.toLowerCase().contains('volume down')) {
      _handleLaptopCommand('system_control', {'action': 'volume_down'});
    } else {
      logger.w('No matching command found for: $commandText');
      // Optionally send a NACK to pendant or TTS feedback
    }
  }

  Future<void> _handleSetReminder(String commandText) async {
    // Example: "Set reminder for 10 AM tomorrow to call John"
    // This parsing is very basic and needs significant improvement for real-world use
    try {
      final parts = commandText.split('for');
      final timePart = parts[1].split('to')[0].trim();
      final descriptionPart = parts[1].split('to')[1].trim();

      // Basic time parsing (e.g., 
      // "10 AM tomorrow" -> needs a proper date/time parser
      final now = DateTime.now();
      DateTime scheduledTime = now.add(const Duration(minutes: 1)); // Placeholder

      final reminder = Reminder(
        title: descriptionPart,
        description: commandText,
        dateTime: scheduledTime,
      );
      await _reminderRepository.addReminder(reminder);
      await _notificationService.scheduleNotification(
        id: reminder.hashCode, // Simple ID for now
        title: reminder.title,
        body: reminder.description,
        scheduledDate: reminder.dateTime,
      );
      logger.i("Reminder set: ${reminder.title} at ${reminder.dateTime}");
      // Send ACK to pendant
    } catch (e) {
      logger.e("Error setting reminder: $e");
      // Send NACK to pendant
    }
  }

  Future<void> _handleRememberThis(String commandText) async {
    // Example: "Remember this: My car parking is on level 3, spot B12"
    try {
      final content = commandText.split(":")[1].trim();
      final memoryItem = MemoryItem(
        content: content,
        timestamp: DateTime.now(),
      );
      await _memoryRepository.addMemoryItem(memoryItem);
      logger.i("Memory item added: $content");
      // Send ACK to pendant
    } catch (e) {
      logger.e("Error adding memory item: $e");
      // Send NACK to pendant
    }
  }

  Future<void> _handleLaptopCommand(String command, Map<String, dynamic> args) async {
    try {
      final laptopCommand = LaptopCommand(command: command, args: args);
      final response = await _laptopApiService.sendCommand(laptopCommand);
      logger.i("Laptop command response: $response");
      // Send ACK/NACK to pendant based on response
    } catch (e) {
      logger.e("Error sending laptop command: $e");
      // Send NACK to pendant
    }
  }
  Future<void> _openChrome() async {
   final Uri url = Uri.parse('https://google.com');

   if (await canLaunchUrl(url)) {
     await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
     );
    }
  }
}
