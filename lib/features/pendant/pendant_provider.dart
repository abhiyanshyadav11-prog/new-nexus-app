
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/services/ble_service.dart';

final pendantProvider = StateNotifierProvider<PendantNotifier, BleConnectionState>((ref) {
  final bleService = ref.watch(bleServiceProvider);
  return PendantNotifier(bleService);
});

final pendantConnectionStateProvider = StreamProvider<BleConnectionState>((ref) {
  final bleService = ref.watch(bleServiceProvider);
  return bleService.connectionState;
});

final pendantBatteryLevelProvider = StreamProvider<int?>((ref) {
  final bleService = ref.watch(bleServiceProvider);
  return bleService.batteryLevel;
});

class PendantNotifier extends StateNotifier<BleConnectionState> {
  final BleService _bleService;

  PendantNotifier(this._bleService) : super(BleConnectionState.disconnected) {
    _bleService.connectionState.listen((state) {
      this.state = state;
    });
  }

  Future<void> scanAndConnect() async {
    await _bleService.scanAndConnect();
  }

  Future<void> disconnect() async {
    await _bleService.disconnect();
  }
}
