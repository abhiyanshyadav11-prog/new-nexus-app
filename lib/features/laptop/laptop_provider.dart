
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/data/models/laptop_command.dart';
import 'package:nexus_app/data/repositories/laptop_repository.dart';
import 'package:nexus_app/core/utils/logger.dart';

final laptopProvider = StateNotifierProvider<LaptopNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return LaptopNotifier(ref.read(laptopRepositoryProvider));
});

final laptopStatusProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final laptopRepo = ref.watch(laptopRepositoryProvider);
  return laptopRepo.getStatus();
});

class LaptopNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final LaptopRepository _laptopRepository;

  LaptopNotifier(this._laptopRepository) : super(const AsyncValue.loading()) {
    fetchStatus();
  }

  Future<void> fetchStatus() async {
    state = const AsyncValue.loading();
    try {
      final status = await _laptopRepository.getStatus();
      state = AsyncValue.data(status);
    } catch (e, st) {
      logger.e('Error fetching laptop status: $e', error: e, stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendTestCommand(String command, Map<String, dynamic> args) async {
    try {
      final laptopCommand = LaptopCommand(command: command, args: args);
      final response = await _laptopRepository.sendCommand(laptopCommand);
      logger.i('Test command response: $response');
      // Optionally update UI based on response
    } catch (e, st) {
      logger.e('Error sending test command: $e', error: e, stackTrace: st);
    }
  }
}
