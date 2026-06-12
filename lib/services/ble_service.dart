
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/core/constants/ble_uuids.dart';
import 'package:nexus_app/core/constants/command_types.dart';
import 'package:nexus_app/core/utils/logger.dart';

enum BleConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

final bleServiceProvider = Provider<BleService>((ref) => BleService());

class BleService {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _audioDataCharacteristic;
  BluetoothCharacteristic? _commandRxCharacteristic;
  BluetoothCharacteristic? _commandTxCharacteristic;
  BluetoothCharacteristic? _statusCharacteristic;
  BluetoothCharacteristic? _batteryCharacteristic;

  final _connectionStateController = StreamController<BleConnectionState>.broadcast();
  Stream<BleConnectionState> get connectionState => _connectionStateController.stream;

  final _batteryLevelController = StreamController<int>.broadcast();
  Stream<int> get batteryLevel => _batteryLevelController.stream;

  final _statusUpdateController = StreamController<Uint8List>.broadcast();
  Stream<Uint8List> get statusUpdate => _statusUpdateController.stream;

  final _commandTxController = StreamController<Uint8List>.broadcast();
  Stream<Uint8List> get commandTx => _commandTxController.stream;

  BleService() {
   // FlutterBluePlus.set  logLevel(LogLevel.debug);
  }

  Future<void> scanAndConnect() async {
    _connectionStateController.add(BleConnectionState.connecting);
    logger.i('Starting BLE scan...');

    var subscription = FlutterBluePlus.scanResults.listen(
      (results) async {
        for (ScanResult r in results) {
          if (r.device.platformName == 'NEXUS_PENDANT') {
            logger.i('Found Nexus Pendant: ${r.device.platformName}');
            FlutterBluePlus.stopScan();
            _device = r.device;
            await connectToDevice();
            return;
          }
        }
      },
    );

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    // Listen for scan to stop
    FlutterBluePlus.isScanning.listen((isScanning) {
      if (!isScanning && _device == null) {
        _connectionStateController.add(BleConnectionState.disconnected);
        logger.w('Scan stopped, Nexus Pendant not found.');
      }
    });

    // Cancel subscription when not needed
    // This might need more sophisticated management in a real app
    await Future.delayed(const Duration(seconds: 15));
    subscription.cancel();
  }

  Future<void> connectToDevice() async {
    if (_device == null) {
      logger.e('No device to connect to.');
      _connectionStateController.add(BleConnectionState.disconnected);
      return;
    }

    try {
      await _device!.connect();
      logger.i('Connected to ${_device!.platformName}');
      _connectionStateController.add(BleConnectionState.connected);

      _device!.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          logger.w('Device disconnected: ${_device!.platformName}');
          _connectionStateController.add(BleConnectionState.disconnected);
          _device = null;
        }
      });

      List<BluetoothService> services = await _device!.discoverServices();
      for (var service in services) {
        if (service.uuid == BleUuids.NEXUS_SERVICE_UUID) {
          logger.i('Found Nexus Service: ${service.uuid}');
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid == BleUuids.AUDIO_DATA_CHAR_UUID) {
              _audioDataCharacteristic = characteristic;
              _audioDataCharacteristic!.setNotifyValue(true);
              _audioDataCharacteristic!.lastValueStream.listen((value) {
                // Handle incoming audio data
                // logger.d('Audio Data: $value');
              });
            } else if (characteristic.uuid == BleUuids.COMMAND_RX_CHAR_UUID) {
              _commandRxCharacteristic = characteristic;
            } else if (characteristic.uuid == BleUuids.COMMAND_TX_CHAR_UUID) {
              _commandTxCharacteristic = characteristic;
              _commandTxCharacteristic!.setNotifyValue(true);
              _commandTxCharacteristic!.lastValueStream.listen((value) {
                _commandTxController.add(Uint8List.fromList(value));
                logger.d('Command TX: $value');
              });
            } else if (characteristic.uuid == BleUuids.STATUS_CHAR_UUID) {
              _statusCharacteristic = characteristic;
              _statusCharacteristic!.setNotifyValue(true);
              _statusCharacteristic!.lastValueStream.listen((value) {
                _statusUpdateController.add(Uint8List.fromList(value));
                logger.d('Status Update: $value');
              });
            } else if (characteristic.uuid == BleUuids.BATTERY_CHAR_UUID) {
              _batteryCharacteristic = characteristic;
              _batteryCharacteristic!.setNotifyValue(true);
              _batteryCharacteristic!.lastValueStream.listen((value) {
                if (value.isNotEmpty) {
                  _batteryLevelController.add(value[0]);
                  logger.d('Battery Level: ${value[0]}%');
                }
              });
            }
          }
          break;
        }
      }
    } catch (e) {
      logger.e('Error connecting to device: $e');
      _connectionStateController.add(BleConnectionState.disconnected);
      _device = null;
    }
  }

  Future<void> disconnect() async {
    if (_device != null) {
      _connectionStateController.add(BleConnectionState.disconnecting);
      try {
        await _device!.disconnect();
        logger.i('Disconnected from ${_device!.platformName}');
      } catch (e) {
        logger.e('Error disconnecting from device: $e');
      } finally {
        _connectionStateController.add(BleConnectionState.disconnected);
        _device = null;
      }
    }
  }

  Future<void> writeCommand(List<int> commandBytes) async {
    if (_commandRxCharacteristic != null) {
      try {
        await _commandRxCharacteristic!.write(commandBytes, withoutResponse: true);
        logger.i('Command sent: $commandBytes');
      } catch (e) {
        logger.e('Error writing command: $e');
      }
    } else {
      logger.w('Command RX characteristic not found.');
    }
  }

  void dispose() {
    _connectionStateController.close();
    _batteryLevelController.close();
    _statusUpdateController.close();
    _commandTxController.close();
  }
}
